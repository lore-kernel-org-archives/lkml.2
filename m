Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab0KDSiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 14:38:20 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:49762 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab0KDSiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 14:38:18 -0400
Date: Thu, 4 Nov 2010 11:37:57 -0700
From: Mike Anderson <andmike@linux.vnet.ibm.com>
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: Tejun Heo <tj@kernel.org>, axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, kay.sievers@vrfy.org, jack@suse.cz,
        James.Bottomley@HansenPartnership.com
Subject: Re: [PATCHSET RFC] block/SCSI: implement in-kernel disk event
 handling
Message-ID: <20101104183757.GA3883@linux.vnet.ibm.com>
References: <1288637081-5183-1-git-send-email-tj@kernel.org>
 <4CD2E83A.9020309@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CD2E83A.9020309@interlog.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Douglas Gilbert <dgilbert@interlog.com> wrote:
<snip>
> Ideally I would like to see a way from the user space
> to uncouple a unit from the sd (or sr) driver, in a
> similar way to how an LLD can use
> scsi_device::no_uld_attach . That would restrict user
> space access to the bsg or sg driver. 

I am not sure if this is exactly what you want but you can unbind a
device from the sd driver today.

E.x.

# cd /sys/bus/scsi/drivers/sd
# ls
0:0:0:0  4:0:0:0  4:0:1:0  5:0:0:0  5:0:1:0  bind  unbind
# sg_map
/dev/sg0  /dev/sda
/dev/sg1  /dev/sdb
/dev/sg2  /dev/sdc
/dev/sg3  /dev/sdd
/dev/sg4  /dev/sde
# echo "5:0:1:0" > unbind
# ls
0:0:0:0  4:0:0:0  4:0:1:0  5:0:0:0  bind  unbind
# sg_map
/dev/sg0  /dev/sda
/dev/sg1  /dev/sdb
/dev/sg2  /dev/sdc
/dev/sg3  /dev/sdd
/dev/sg4

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
