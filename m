Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760128Ab0GWONS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 10:13:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9766 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752776Ab0GWONQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 10:13:16 -0400
Date: Fri, 23 Jul 2010 10:13:03 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Heinz Diehl <htd@fancy-poultry.org>
Cc: linux-kernel@vger.kernel.org, jaxboe@fusionio.com, nauman@google.com,
        dpshah@google.com, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
        czoccolo@gmail.com
Subject: Re: [RFC PATCH] cfq-iosched: IOPS mode for group scheduling and new
 group_idle tunable
Message-ID: <20100723141303.GB13104@redhat.com>
References: <1279834172-4227-1-git-send-email-vgoyal@redhat.com>
 <20100723140343.GA8478@fancy-poultry.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100723140343.GA8478@fancy-poultry.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 23, 2010 at 04:03:43PM +0200, Heinz Diehl wrote:
> On 23.07.2010, Vivek Goyal wrote: 
> 
> > This is V4 of the patchset which implements a new tunable group_idle and also
> > implements IOPS mode for group fairness. Following are changes since V3.
> [....]
> 
> Just for information: this patchset, applied to 2.6.35-rc6, gives about
> 20-25% increase in speed/throughput on my desktop system 
> (Phenom 2.5GHz Quadcore, 3 disks) with the tunables set according 
> to what you've used/reported here (the setup with slice_idle set to 0),
> and it's measurable with fs_mark, too.
> 
> After 2 hours of hard testing, the machine remains stable and responsive.

Thanks for some testing Heinz. I am assuming you are not using cgroups
and blkio controller.

In that case, you are seeing improvements probably due to first patch
where we don't idle on service tree if slice_idle=0. Hence we cut down on
overall idling and can see throughput incrase.

What kind of configuration these 3 disks are on your system? Some Hardare
RAID or software RAID ?

Thanks
Vivek
