Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932577Ab2KEOkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 09:40:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56142 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932495Ab2KEOk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 09:40:27 -0500
Date: Mon, 5 Nov 2012 15:40:15 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Chris Friesen <chris.friesen@genband.com>,
        Pavel Machek <pavel@ucw.cz>, Eric Paris <eparis@parisplace.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Oliver Neukum <oneukum@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Josh Boyer <jwboyer@gmail.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
In-Reply-To: <87390ok0zy.fsf@xmission.com>
Message-ID: <alpine.LNX.2.00.1211051535060.24253@pobox.suse.cz>
References: <50919EED.3020601@genband.com> <36538307.gzWq1oO7Kg@linux-lqwf.site> <1351760905.2391.19.camel@dabdike.int.hansenpartnership.com> <alpine.LNX.2.00.1211011017230.6606@pobox.suse.cz> <1351762703.2391.31.camel@dabdike.int.hansenpartnership.com>
 <alpine.LNX.2.00.1211011044290.6606@pobox.suse.cz> <1351763954.2391.37.camel@dabdike.int.hansenpartnership.com> <CACLa4puzLR2om6SHw3wVnfZ1nezVsKOp8+705AdHZ4_=JamYfw@mail.gmail.com> <20121101202701.GB20817@xo-6d-61-c0.localdomain> <5092E361.7080901@genband.com>
 <20121102154833.GG3300@redhat.com> <alpine.LNX.2.00.1211040008280.24253@pobox.suse.cz> <87390ok0zy.fsf@xmission.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Nov 2012, Eric W. Biederman wrote:

> > Why is "when kernel has been securely booted, the in-kernel kexec 
> > mechanism has to verify the signature of the supplied image before 
> > kexecing it" not enough? (basically the same thing we are doing for signed 
> > modules already).
> 
> For modules the only untrusted part of their environment are the command
> line parameters, and several of those have already been noted for
> needing to be ignored in a non-trusted root scenario.
> 
> For kexec there is a bunch of glue code and data that takes care of
> transitioning from the environment provided by kexec and the environment
> that the linux kernel or memtest86 or whatever we are booting is
> expecting.
> 
> Figuring out what glue code and data we need and supplying that glue
> code and data is what kexec-tools does.  The situation is a bit like
> dealing with the modules before most of the work of insmod was moved
> into the kernel.
> 
> For kexec-tools it is desirable to have glue layers outside of the
> kernel because every boot system in existence has a different set of
> parameter passing rules.
> 
> So signing in the kernel gets us into how do we sign the glue code and
> how dow we verify the glue code will jump to our signed and verified
> kernel image.

Do I understand you correctly that by the 'glue' stuff you actually mean 
the division of the kexec image into segments?

Of course, when we are dividing the image into segments and then passing 
those individually (even more so if some transformations are performed on 
those segments, which I don't know whether that's the case or not), then 
we can't do any signature verification of the image any more.

But I still don't fully understand what is so magical about taking the 
kernel image as is, and passing the whole lot to the running kernel as-is, 
allowing for signature verification.

Yes, it couldn't be sys_kexec_load(), as that would be ABI breakage, so 
it'd mean sys_kexec_raw_load(), or whatever ... but I fail to see why that 
would be problem in principle.

If you can point me to the code where all the magic that prevents this 
easy handling is happening, I'd appreciate it.

Thanks,

-- 
Jiri Kosina
SUSE Labs
