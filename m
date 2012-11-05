Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930Ab2KEGi4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 01:38:56 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:57549 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab2KEGiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 01:38:54 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jiri Kosina <jkosina@suse.cz>
Cc: Vivek Goyal <vgoyal@redhat.com>, Chris Friesen <chris.friesen@genband.com>,
        Pavel Machek <pavel@ucw.cz>, Eric Paris <eparis@parisplace.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Oliver Neukum <oneukum@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Josh Boyer <jwboyer@gmail.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
References: <50919EED.3020601@genband.com>
	<36538307.gzWq1oO7Kg@linux-lqwf.site>
	<1351760905.2391.19.camel@dabdike.int.hansenpartnership.com>
	<alpine.LNX.2.00.1211011017230.6606@pobox.suse.cz>
	<1351762703.2391.31.camel@dabdike.int.hansenpartnership.com>
	<alpine.LNX.2.00.1211011044290.6606@pobox.suse.cz>
	<1351763954.2391.37.camel@dabdike.int.hansenpartnership.com>
	<CACLa4puzLR2om6SHw3wVnfZ1nezVsKOp8+705AdHZ4_=JamYfw@mail.gmail.com>
	<20121101202701.GB20817@xo-6d-61-c0.localdomain>
	<5092E361.7080901@genband.com> <20121102154833.GG3300@redhat.com>
	<alpine.LNX.2.00.1211040008280.24253@pobox.suse.cz>
Date: Sun, 04 Nov 2012 22:38:41 -0800
In-Reply-To: <alpine.LNX.2.00.1211040008280.24253@pobox.suse.cz> (Jiri
	Kosina's message of "Sun, 4 Nov 2012 00:09:55 +0100 (CET)")
Message-ID: <87390ok0zy.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18PC4IDXhQ+ERKkbEq3LQUnT7pRzQV6FYo=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jiri Kosina <jkosina@suse.cz>
X-Spam-Relay-Country: 
Subject: Re: [RFC] Second attempt at kernel secure boot support
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina <jkosina@suse.cz> writes:

> On Fri, 2 Nov 2012, Vivek Goyal wrote:
>
>> > With secure boot enabled, then the kernel should refuse to let an
>> > unsigned kexec load new images, and kexec itself should refuse to
>> > load unsigned images.
>> 
>> Yep, good in theory. Now that basically means reimplementing kexec-tools
>> in kernel. 
>
> Why is "when kernel has been securely booted, the in-kernel kexec 
> mechanism has to verify the signature of the supplied image before 
> kexecing it" not enough? (basically the same thing we are doing for signed 
> modules already).

For modules the only untrusted part of their environment are the command
line parameters, and several of those have already been noted for
needing to be ignored in a non-trusted root scenario.

For kexec there is a bunch of glue code and data that takes care of
transitioning from the environment provided by kexec and the environment
that the linux kernel or memtest86 or whatever we are booting is
expecting.

Figuring out what glue code and data we need and supplying that glue
code and data is what kexec-tools does.  The situation is a bit like
dealing with the modules before most of the work of insmod was moved
into the kernel.

For kexec-tools it is desirable to have glue layers outside of the
kernel because every boot system in existence has a different set of
parameter passing rules.

So signing in the kernel gets us into how do we sign the glue code and
how dow we verify the glue code will jump to our signed and verified
kernel image.

I will be happy to review patches for that don't through the baby out
with the bath water.

Eric

