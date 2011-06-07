Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab1FGO5q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 10:57:46 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:35304 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab1FGO5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 10:57:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=Ua7IhEyI5GrpzBLbtxR1jNJ26YnSRgHQ7D8vMLcy1EWB4O135nLF8G05OB8OMb75w6
         Jlld2QMNGK1YS0NMac+YgqfSWLVYAuep85xqS/pUI9EQsOQG+dPjYqax3Bbo0X2pFwC7
         7oo4TZgEjoatNgC4iN9O/ilRlEE0kjqDgiOtc=
MIME-Version: 1.0
In-Reply-To: <1307456080.2322.264.camel@twins>
References: <17185480.5304.1307435255996.JavaMail.root@WARSBL214.highway.telekom.at>
 <alpine.LFD.2.02.1106071033350.11814@ionos> <4DEDF1F2.2080204@steinhoff.de>
 <1307439469.2322.235.camel@twins> <BANLkTi=KPyds_BWYpXHeUkAg000FGSuJOQ@mail.gmail.com>
 <1307456080.2322.264.camel@twins>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Tue, 7 Jun 2011 11:57:24 -0300
Message-ID: <BANLkTiknwh4N3xRFQXYq0AFPc5BxWwUkuA@mail.gmail.com>
Subject: Re: Changing Kernel thread priorities
To: Peter Zijlstra <peterz@infradead.org>
Cc: Remy Bohmer <linux@bohmer.net>, Armin Steinhoff <armin@steinhoff.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Bauer <hannes_bauer@aon.at>,
        Monica Puig-Pey <puigpeym@unican.es>,
        Rolando Martins <rolando.martins@gmail.com>,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 7, 2011 at 11:14, Peter Zijlstra <peterz@infradead.org> wrote:
> > Well, I 100% agree that it must be under full userspace control to be
> > able to set the priorities. But, the kernel default assumption of
> > starting everything at 50 is wrong as well.
> > Imagine the following situation:
> > * Realtime application is running and has threads active in the range
> > of prios 20 - 90.
> > * Now bring up a network device, it immediately starts spamming the
> > system at prio 50 _before_ you have the chance to set it below 20 by
> > means of chrt.
> > * RT behaviour is gone!

Why is the application using priorities in the range 20-90 if it's
well known that we default RT kernel threads to 50?

IMO it's a mistake in the application.


Lucas De Marchi
