Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417Ab2KBPtS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 11:49:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595Ab2KBPtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 11:49:13 -0400
Date: Fri, 2 Nov 2012 11:48:33 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Chris Friesen <chris.friesen@genband.com>
Cc: Pavel Machek <pavel@ucw.cz>, Eric Paris <eparis@parisplace.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oneukum@suse.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Josh Boyer <jwboyer@gmail.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Message-ID: <20121102154833.GG3300@redhat.com>
References: <50919EED.3020601@genband.com>
 <36538307.gzWq1oO7Kg@linux-lqwf.site>
 <1351760905.2391.19.camel@dabdike.int.hansenpartnership.com>
 <alpine.LNX.2.00.1211011017230.6606@pobox.suse.cz>
 <1351762703.2391.31.camel@dabdike.int.hansenpartnership.com>
 <alpine.LNX.2.00.1211011044290.6606@pobox.suse.cz>
 <1351763954.2391.37.camel@dabdike.int.hansenpartnership.com>
 <CACLa4puzLR2om6SHw3wVnfZ1nezVsKOp8+705AdHZ4_=JamYfw@mail.gmail.com>
 <20121101202701.GB20817@xo-6d-61-c0.localdomain>
 <5092E361.7080901@genband.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5092E361.7080901@genband.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2012 at 03:02:25PM -0600, Chris Friesen wrote:
> On 11/01/2012 02:27 PM, Pavel Machek wrote:
> 
> >Could someone write down exact requirements for Linux kernel to be signed by Microsoft?
> >Because thats apparently what you want, and I don't think crippling kexec/suspend is
> >enough.
> 
> As I understand it, the kernel won't be signed by Microsoft.
> 
> Rather, the bootloader will be signed by Microsoft and the vendors
> will be the ones that refuse to sign a kernel unless it is
> reasonably assured that it won't be used as an attack vector.
> 
> If you want fully-open behaviour it's still possible, you just need
> to turn off secure boot.
> 
> With secure boot enabled, then the kernel should refuse to let an
> unsigned kexec load new images, and kexec itself should refuse to
> load unsigned images.

Yep, good in theory. Now that basically means reimplementing kexec-tools
in kernel. That also means creating a new system call. It also
also means cutting down on future flexibility (assuming new system
call interface will be able to support existing features provided by
kernel). And it is lot of code in user space which needs to be
reimplemented in kernel and bloat kernel.

Keeping most of the logic in kexec-tools provided flexibility and keeps
kernel small. So now re-architect kexec and reverse a good design completely
for secureboot. It is a huge pain.

Thanks
Vivek
