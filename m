Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab1FHVvk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 17:51:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:30899 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753269Ab1FHVvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 17:51:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,340,1304319600"; 
   d="scan'208";a="11396493"
Message-ID: <4DEFEEE7.1030703@linux.intel.com>
Date: Wed, 08 Jun 2011 14:51:35 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, Yinghai Lu <yinghai@kernel.org>,
        Jim Bos <jim876@xs4all.nl>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.39.1 immediately reboots/resets on EFI system
References: <20110608193833.GA29855@srcf.ucam.org> <4DEFD220.5040507@kernel.org> <20110608195250.GB30256@srcf.ucam.org> <4DEFD58D.5060402@kernel.org> <20110608200903.GA30694@srcf.ucam.org> <4DEFDA4A.9080500@kernel.org> <20110608203037.GA31052@srcf.ucam.org> <4DEFDD69.7010000@kernel.org> <20110608204244.GA31484@srcf.ucam.org> <BANLkTikfbSsgGgNEQ3GVD=HOPn1Dz_xh+g@mail.gmail.com> <20110608212813.GB32056@srcf.ucam.org> <BANLkTikbx6xm+NY34ATN7YkJyjPp9CSXTw@mail.gmail.com>
In-Reply-To: <BANLkTikbx6xm+NY34ATN7YkJyjPp9CSXTw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2011 02:31 PM, Linus Torvalds wrote:
> On Wed, Jun 8, 2011 at 2:28 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>>
>> Boot services data includes everything that was allocated by the EFI
>> memory allocator. Depending on what the system decided to do before
>> deigning to run our code, that might be a meg - or it might be several
>> hundred. And in the process it's probably fragmented RAM into god knows
>> how many small chunks.
> 
> In reality?
> 
> Whatever. I really think our EFI support is just fundamnetally broken.
> We should do *everything* in the bootloader, and nothing at all in the
> kernel. IOW, I think doing the whole "SetVirtualAddrMap()" (or
> whatever) in the boot loader too, and just promise to neve rever call
> any EFI routines from the kernel.
> 
> IOW, a sane EFI boot loader should just make things look like a
> regular BIOS, and not bother the kernel with the EFI crap.
> 
> EFI was misdesigned. That doesn't mean that _we_ should then
> mis-design our support for it.
> 

No argument that our EFI support is misdesigned.

However, I suspect that what we *should* do is carry an kernel EFI stub
to go along with the BIOS stub... otherwise we're forever at mercy of
getting all the boot loader authors to change in lockstep, and there are
specific ones which are notoriously hard to work with.

The "kernel carries its own stub" approach been very successful in
dealing with BIOS, and would make a lot of sense to me for EFI as well.

	-hpa
