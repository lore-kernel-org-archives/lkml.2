Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab0KFLDy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 07:03:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:53207 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754679Ab0KFLDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 07:03:54 -0400
Message-ID: <4CD5360E.7060902@kernel.org>
Date: Sat, 06 Nov 2010 12:03:42 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Matt Helsley <matthltc@us.ibm.com>
CC: Oren Laadan <orenl@cs.columbia.edu>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu> <4CD08419.5050803@kernel.org> <4CD23087.30900@cs.columbia.edu> <4CD28033.1000700@kernel.org> <20101106101209.GD11535@count0.beaverton.ibm.com>
In-Reply-To: <20101106101209.GD11535@count0.beaverton.ibm.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 06 Nov 2010 11:03:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 11/06/2010 11:12 AM, Matt Helsley wrote:
> If you think specialized hardware acceleration is necessary for
> containers then perhaps you have a poor understanding of what a container
> is. Chances are if you're running a container with namespaces configured
> then you're already paying the performance costs of running in a
> container. If you've compared the performance of that kernel to your
> virtualization hardware then you already know how they compare.

I was talking about virtualization when referring to hardware support.

> So please stop asserting that a purported lack of hardware support
> is significant. Also please remember that we're not implementing containers
> in this patch set -- they're already in.

Sure, that was my point.  So, let's drop the handwaving about being
transparent.

> Incidentally, 20k lines of code is less than many pieces of the kernel.
> It's less than many:
> 
> Filesystems (I've selected ones designed for rotating media or networks usually..)
> 	ext4, nfs, ocfs2, xfs, reiserfs, ntfs, gfs2, jfs, cifs, ubifs, nilfs2, btrfs
> 
> Non-filesystem file-system support code:
> 	nfsd, nls
> 
> It's less than one of the simpler DRM graphics drivers -- i915:
> 	$ cd drivers/gpu/drm/i915
> 	$ wc -l *.[ch]
> 	...
> 	41481 total
>
> It's less than any one of the lpfc, bfa, aic7xxx, qla2xxx, and mpt2sas
> drivers I see under scsi. Perhaps a more fair comparison might be to compare
> a single driver to a single checkpointable kernel interface but it's
> a more-fair comparison that skews even more in our favor.

Yeah, and imagine what people would say if ext4, or heaven forbid,
aic7xxx code was scattered all over the kernel.

> Yes, when you *add it all up* it's more than half the size of the kernel/
> directory. Bear in mind that the portions we add to kernel/checkpoint though
> are only 4603 lines long -- about the same size as many kernel/*.c files.
> The rest is for each kernel interface that adds/manipulates state we need to
> be able to checkpoint. Or arch code.. etc.
> 
> So please don't base your assessment of our code on your apparently
> flawed notion of containers nor on the summary line of a diffstat
> you saw.

I don't believe my notion of containers was or is flawed and already
said that the diffstat per-se didn't look too bad.  With enough
benefits, I wouldn't be opposed against the rather invasive changes.
It's just that the whole thing is conceived backwards and there are
already working alternatives which may be somewhat messy now but
nevertheless achieve about the same effect without the craziness of
serializing in-kernel data structures which are already mostly visible
to userland to begin with.

Thanks.

-- 
tejun
