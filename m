Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab1C3Pyh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 11:54:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754659Ab1C3Pyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 11:54:36 -0400
Date: Wed, 30 Mar 2011 11:54:09 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Lina Lu <lulina_nuaa@foxmail.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: cfq-iosched.c:Use cfqq->nr_sectors in charge the vdisktime
Message-ID: <20110330155409.GE1291@redhat.com>
References: <201103302323256090890@foxmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103302323256090890@foxmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 11:23:30PM +0800, Lina Lu wrote:
> Hi Vivek,
>       I find the weight policy can be more accuracy with cfqq->nr_sectors instead
> of cfqq->slice_dispatch. 
>       Today, I try to modify cfq_group_served(), and use "charge = cfqq->nr_sectors; "
> instead of "charge = cfqq->slice_dispatch; " . The test result seens more accuracy.
> Why you choose slice_dispatch here? Is the nr_sectors will lower the total performance?

Lina,

CFQ fundamentally allocates time slices hence accounting is done in time
and not in terms of sectors. The other reason is that accounting in
terms of time can be more accurate where some process is seeking all
over the disk and doing little IO. If we account in terms of sectors
then such seeky process will get much more share.

>       And in iops mod, if I try to apply weight policy on two IO processes with different 
> avgrq-sz, the test results will not exact match the weight value.

IOPS mode kicks in when slice_idle=0. I suspect that group does not drive
enough IO to remain on service tree hence gets deleted and hence loses
share.

Can you run a 20 sec backtrace and upload it somewhere.

Thanks
Vivek
