Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab1HFOrC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 10:47:02 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:50453 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab1HFOrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 10:47:00 -0400
Date: Sat, 6 Aug 2011 10:46:52 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Dan Carpenter <error27@gmail.com>, joe.jin@oracle.com
Cc: Laszlo Ersek <lersek@redhat.com>, Joe Jin <joe.jin@oracle.com>,
        open list <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] xen-blkback: add missing return on error in
 xen_update_blkif_status()
Message-ID: <20110806144652.GB29514@dumpdata.com>
References: <20110805141821.GK7659@shale.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110805141821.GK7659@shale.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4E3D53E2.005E:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 05, 2011 at 05:18:21PM +0300, Dan Carpenter wrote:
> We should return here after reporting the error.  Otherwise we'd hit
> a NULL deref of blkif->xenblkd on the next line.

Whao, yeah, I dropped that whole patchset. Will introduce it back
in when I get a better patchset from Joe.

Joe,
Can you add this fix in your patchqueue please?

> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
> index 32d4c3c..b750299 100644
> --- a/drivers/block/xen-blkback/xenbus.c
> +++ b/drivers/block/xen-blkback/xenbus.c
> @@ -107,6 +107,7 @@ static void xen_update_blkif_status(struct xen_blkif *blkif)
>  		err = PTR_ERR(blkif->xenblkd);
>  		blkif->xenblkd = NULL;
>  		xenbus_dev_error(blkif->be->dev, err, "start xenblkd");
> +		return;
>  	}
>  
>  	blkif->be->kthread_pid = blkif->xenblkd->pid;
