Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932993Ab2K0H4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 02:56:53 -0500
Received: from relay.parallels.com ([195.214.232.42]:55509 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757618Ab2K0H4v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 02:56:51 -0500
Message-ID: <50B47243.9080706@parallels.com>
Date: Tue, 27 Nov 2012 11:56:51 +0400
From: "Maxim V. Patlasov" <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Feng Shuo <steve.shuo.feng@gmail.com>
CC: <miklos@szeredi.hu>, <dev@parallels.com>,
        "fuse-devel@lists.sourceforge.net" <fuse-devel@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>, <jbottomley@parallels.com>,
        <viro@zeniv.linux.org.uk>, <linux-fsdevel@vger.kernel.org>,
        <xemul@openvz.org>
Subject: Re: [PATCH v2 00/14] fuse: An attempt to implement a write-back cache
 policy
References: <20121116170123.3196.93431.stgit@maximpc.sw.ru> <CALmpHyb5wpn-dABuEwpypUggRY=1aULvJW0z17HpH50pr1=HKg@mail.gmail.com>
In-Reply-To: <CALmpHyb5wpn-dABuEwpypUggRY=1aULvJW0z17HpH50pr1=HKg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.30.17.2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Feng,

11/27/2012 05:04 AM, Feng Shuo пишет:
> Hi Maxim,
>
> I'm new to fuse but have some experience with NFS. From my
> understanding after reviewing your patchset, it seems only work with
> local file system or a distributed file system whose file is never
> modified (could be grown but no or very few modified) because it
> doesn't exam the pre/post status of the writing object (e.g. a file).
> So if a file is modified outside, fuse might not get any chance to
> handle it...... Correct me if I got wrong since I'm really new to
> fuse. :-)

This topic was discussed when Pavel sent initial version of patches (you 
can find it in fuse-devel archives). Brian asked:

> Would this pose a problem for a filesystem in which the size of the
> inode can change remotely (i.e., not visible to the local instance of
> fuse)? I haven't tested this, but it seems like it could be an issue
> based on the implementation.

And Pavel replied:

> Yes, it will. The model of i_size management I implemented here is based
> on an assumption that the userspace is just a storage for data and should
> catch up with the kernel i_size value. In order to make it possible for user
> space to update i_size in kernel we'd have to implement some (probably)
> tricky algorithm, I haven't yet thought about it.

The patch-set follows the model "trust kernel i_size only". This works 
fine at least in case of userspace fuse wtih exclusive write semantics. 
In case of mutual concurrent internal/external read/write access, sysad 
should not turn the feature on (it's turned off by default). I wouldn't 
like to complicate the patch-set further adding bits for that case. This 
area is opened for future enhancements :)

Thanks,
Maxim
