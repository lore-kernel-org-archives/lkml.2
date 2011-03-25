Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab1CYWiB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 18:38:01 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64598 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754853Ab1CYWiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 18:38:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=d17stnDF+XUX4WR7TkHo3NAUyq/UVVR4c/cbSbQxB/otE+I2xRuDvLOmzQ/zaZYV8u
         urVtn1Fgp8brFxNzKxxfaNeY9UzpDBnUmUCjfscYdQ7gG1Q1rDsby1hy3iKTBjMEKDH0
         nCatJ0r4ORElIfy2eA8+rSIpHdQr2QelCiLTs=
MIME-Version: 1.0
In-Reply-To: <4D8D078C.1040201@redhat.com>
References: <cover.1300996141.git.mchehab@redhat.com>
	<20110324173257.36680b90@pedra>
	<20110324223907.GA10498@liondog.tnic>
	<4D8C6C80.8010600@redhat.com>
	<20110325141322.GB28313@gere.osrc.amd.com>
	<4D8D078C.1040201@redhat.com>
Date: Fri, 25 Mar 2011 15:37:59 -0700
X-Google-Sender-Auth: GR-oboHZVe48ludMEu8AjOYzzFE
Message-ID: <AANLkTi=jGB_nFO0nnWWZ60gqgdELAQjv5dpAZmz5zKSz@mail.gmail.com>
Subject: Re: [PATCH RFC 2/2] events/hw_event: Create a Hardware Anomaly Report
 Mechanism (HARM)
From: Tony Luck <tony.luck@intel.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>, Borislav Petkov <bp@alien8.de>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 2:22 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 25-03-2011 11:13, Borislav Petkov escreveu:
>> However, there's
>> another issue with fatal errors - you want to execute as less code as
>> possible in the wake of a fatal error.
>
> Yes. That's one of the reasons why it may make sense to have a separate event
> for fatal errors.

We have three categories (severities):
1) Corrected - log these
2) Uncorrected-but-not-immediately-fatal - log these too
3) Fatal - all we can do with these is log to some persistent store (or
    to a serial console connected to a logging device). perf style event
    tracing doesn't help when all the userland daemons will never get a
    chance to run.

> It would be good to use some non-volatile ram for these. I was told that
> APEI spec defines a way for that, but I'm not sure if low end machines would
> be shipped with that.

You are talking about ERST - and you are right, this is generally not going
to be present on low-end machines.  drivers/acpi/apei/erst.c was accepted
in 2.6.35.  My /dev/pstore changes are in the current merge for 2.6.39 (but
currently only show dmesg traces to the user).

> Alternatively, edac could fill a translation table, and the decoding code at
> mce would be just a table retrieve routine (in order to speed-up translation,
> in the case of fatal errors.

Eventually the translation table should move above edac (to the drivers/ras/
area that Borislav suggested earlier?) so that both mce and edac can access.
I think we'll need this for some time as SMBIOS continues to disappoint
me with its inaccuracies.

-Tony
