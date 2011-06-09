Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab1FITtm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 15:49:42 -0400
Received: from nbd.name ([46.4.11.11]:47706 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755043Ab1FITtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 15:49:39 -0400
Message-ID: <4DF123C6.4000008@openwrt.org>
Date: Thu, 09 Jun 2011 21:49:26 +0200
From: Felix Fietkau <nbd@openwrt.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Miklos Szeredi <miklos@szeredi.hu>, NeilBrown <neilb@suse.de>,
        viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        apw@canonical.com, hramrach@centrum.cz, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu>	<20110608153208.dc705cda.akpm@linux-foundation.org>	<20110609115934.3c53f78f@notabene.brown>	<20110608205233.ebfedc4d.akpm@linux-foundation.org>	<87wrgvb28a.fsf@tucsk.pomaz.szeredi.hu> <20110609123843.77153b27.akpm@linux-foundation.org>
In-Reply-To: <20110609123843.77153b27.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-06-09 9:38 PM, Andrew Morton wrote:
>>  >>  >  This sort of thing could be implemented in userspace and wired up via
>>  >>  >  fuse, I assume.  Has that been attempted and why is it inadequate?
>>
>>  Yes, unionfs-fuse and deltafs (written by me) are two examples.
>>
>>  One issue that a customer had with deltafs was lack of XIP support.  The
>>  other one (from the same customer) was the general yuck factor of
>>  userspace filesystems.
>>
>>  There are also performance and resource use issues associated with
>>  userspace filesystems.  These may or may not be problem depending on the
>>  actual use.  But it's a fact that out-of-kernel filesystems will never
>>  be as efficient as in-kernel ones.
>
> Yes, userspace filesystems have a good yuck factor.  In a way it's a
> sad commentary on the concept of FUSE, but I guess one could look at it
> another way: FUSE is good for prototypes and oddball small-volume stuff
> but once a FUSE-based setup has proven useful and people are getting
> benefit from it, it's time to look at an in-kernel implementation.
We're using overlayfs in OpenWrt for embedded systems with 4 MB flash 
and 16 MB RAM for using a jffs2 filesystem as an overlay to squashfs. 
FUSE would add quite a bit of unnecessary bloat to that.

overlayfs so far is the only overlay filesystem implementation that I've 
seen that works well for us with new kernels, and it has all the 
features that we need (which aren't that many).

- Felix
