Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935281Ab2JXRTo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 13:19:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756966Ab2JXRTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 13:19:42 -0400
Date: Wed, 24 Oct 2012 13:19:26 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Matthew Garrett <mjg@redhat.com>, Khalid Aziz <khalid@gonehiking.org>,
        kexec@lists.infradead.org, horms@verge.net.au,
        Dave Young <dyoung@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: Re: [RFC] Kdump with signed images
Message-ID: <20121024171926.GD1821@redhat.com>
References: <20121018193831.GD18147@redhat.com>
 <874nlrv2ni.fsf@xmission.com>
 <20121019020630.GA27052@redhat.com>
 <877gqnnnf0.fsf@xmission.com>
 <20121019143112.GB27052@redhat.com>
 <871ugqb4gj.fsf@xmission.com>
 <20121023131854.GA16496@redhat.com>
 <20121023145920.GD16496@redhat.com>
 <20121023154123.GA30730@srcf.ucam.org>
 <87d309xhmc.fsf_-_@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d309xhmc.fsf_-_@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 09:44:59AM -0700, Eric W. Biederman wrote:
> Matthew Garrett <mjg@redhat.com> writes:
> 
> > On Tue, Oct 23, 2012 at 10:59:20AM -0400, Vivek Goyal wrote:
> >
> >> But what about creation of a new program which can call kexec_load()
> >> and execute an unsigned kernel. Doesn't look like that will be
> >> prevented using IMA.
> >
> > Right. Trusting userspace would require a new system call that passes in 
> > a signature of the userspace binary, and the kernel would then have to 
> > verify the ELF object in memory in order to ensure that it 
> > matches the signature. Verifying that the copy on the filesystem is 
> > unmodified isn't adequate - an attacker could simply have paused the 
> > process and injected code. 
> 
> Verifying the copy on the filesystem at exec time is perfectly adequate
> for gating extra permissions.  Certainly that is the model everywhere
> else in the signed key chain.
> 
> Where IMA falls short is there is no offline signing capability in IMA
> itself.  I think EVM may fix that.

[ CCing lkml. I think it is a good idea to open discussion to wider
audience. Also CCing IMA/EVM folks ]

Based on reading following wiki page, looks like EVM also does not allow
offline signing capability. And EVM is protecting IMA data to protect
against offline attack. If we can assume that unisgned kernels can't be
booted on the platform, then EVM might not be a strict requirement in
this case.

So as you said, one of the main problem with IMA use to verify /sbin/kexec
is that IMA does not provide offline signing capability.

> 
> > Realistically, the only solution here is for 
> > the kernel to verify that the kernel it's about to boot is signed and 
> > for it not to take any untrusted executable code from userspace.
> 
> Hogwash.  The kernel verifing a signature of /sbin/kexec at exec time is
> perfectly reasonable, and realistic.  In fact finding a way to trust
> small bits of userspace even if root is compromised seems a far superior
> model to simply solving the signing problem for /sbin/kexec.
> 
> Although I do admit some part of the kexec process will need to verify
> keys on the images we decide to boot.

It should be an option, isn't it? Either /sbin/kexec can try to verify the
integrity of kernel or we extend try to extend kexec() system call to also
pass the signature of kernel and let kernel verify it (as you mentioned
previously).

Thanks
Vivek
