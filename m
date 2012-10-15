Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623Ab2JOHsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 03:48:17 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:15643 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750744Ab2JOHsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 03:48:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvMoAGu+e1B5LH33/2dsb2JhbABFhSm0X4RnAoEEgQmCIAEBBTocIxAIAxUDLhQNGAM0h3IDDrMMDYlUFIpfZoFngTWDIQOUF4FUiySFDYMB
Date: Mon, 15 Oct 2012 18:48:11 +1100
From: Dave Chinner <david@fromorbit.com>
To: zwu.kernel@gmail.com
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk, dave@jikos.cz,
        tytso@mit.edu, cmm@us.ibm.com, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: Re: [RFC v3 11/13] vfs: add 3 new ioctl interfaces
Message-ID: <20121015074811.GY2739@dastard>
References: <1349863655-29320-1-git-send-email-zwu.kernel@gmail.com>
 <1349863655-29320-12-git-send-email-zwu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349863655-29320-12-git-send-email-zwu.kernel@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 06:07:33PM +0800, zwu.kernel@gmail.com wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
>   FS_IOC_GET_HEAT_INFO: return a struct containing the various
> metrics collected in btrfs_freq_data structs, and also return a
> calculated data temperature based on those metrics. Optionally, retrieve
> the temperature from the hot data hash list instead of recalculating it.
> 
>   FS_IOC_GET_HEAT_OPTS: return an integer representing the current
> state of hot data tracking and migration:
> 
> 0 = do nothing
> 1 = track frequency of access
> 
>   FS_IOC_SET_HEAT_OPTS: change the state of hot data tracking and
> migration, as described above.
.....
> +struct hot_heat_info {
> +	__u64 avg_delta_reads;
> +	__u64 avg_delta_writes;
> +	__u64 last_read_time;
> +	__u64 last_write_time;
> +	__u32 num_reads;
> +	__u32 num_writes;
> +	__u32 temperature;
> +	__u8 live;
> +	char filename[PATH_MAX];

Don't put the filename in the ioctl and open the file in the kernel.
Have userspace open the file directly and issue the ioctl on the fd
that is returned.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
