Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682Ab2KESWy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 13:22:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52576 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531Ab2KESWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 13:22:52 -0500
Date: Mon, 5 Nov 2012 13:22:24 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Chris Friesen <chris.friesen@genband.com>
Cc: Jiri Kosina <jkosina@suse.cz>, "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Machek <pavel@ucw.cz>, Eric Paris <eparis@parisplace.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Oliver Neukum <oneukum@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Josh Boyer <jwboyer@gmail.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
Message-ID: <20121105182224.GE28720@redhat.com>
References: <1351763954.2391.37.camel@dabdike.int.hansenpartnership.com>
 <CACLa4puzLR2om6SHw3wVnfZ1nezVsKOp8+705AdHZ4_=JamYfw@mail.gmail.com>
 <20121101202701.GB20817@xo-6d-61-c0.localdomain>
 <5092E361.7080901@genband.com>
 <20121102154833.GG3300@redhat.com>
 <alpine.LNX.2.00.1211040008280.24253@pobox.suse.cz>
 <87390ok0zy.fsf@xmission.com>
 <alpine.LNX.2.00.1211051535060.24253@pobox.suse.cz>
 <alpine.LNX.2.00.1211051628380.24253@pobox.suse.cz>
 <5097DD2E.9040909@genband.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5097DD2E.9040909@genband.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2012 at 09:37:18AM -0600, Chris Friesen wrote:
> On 11/05/2012 09:31 AM, Jiri Kosina wrote:
> 
> >I had a naive idea of just putting in-kernel verification of a complete
> >ELF binary passed to kernel by userspace, and if the signature matches,
> >jumping to it.
> >Would work for elf-x86_64 nicely I guess, but we'd lose a lot of other
> >functionality currently being provided by kexec-tools.
> >
> >Bah. This is a real pandora's box.
> 
> Would it be so bad to statically link kexec?

statically linking and signing /sbin/kexec is sounding most reasonable so
far, to me. Even if we do that, there are few more issues queries though.

- Do we still need a new system call?

- Who does the kernel signature verification. Is it /sbin/kexec or kernel
  should do that.

- If kernel is supposed to do kernel signature verification, how the
  signed bzImage is passed to kernel with existing system call.
  Are certificates passed in separate segments. How does kernel
  differentiate between segmets etc.

- Does signed /sbin/kexec means that it can load any other segments
  like elf header, boot_params and no signature verifiation is needed.


If we move all the kernel signatuer verification part into /sbin/kexec,
then we should possibly be able to use existing system call. But I don't
know what kind of crypto support we shall have to build into kexec-tools
statically and how much help we can get from static libraries and how
much work it is.

Thanks
Vivek
