Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398Ab0LMF5y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 00:57:54 -0500
Received: from mail-ww0-f66.google.com ([74.125.82.66]:48422 "EHLO
	mail-ww0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab0LMF5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 00:57:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        b=WGsNkrIQglFIZs8O1J1Ur2YOaDTDQs8Ps+7dulY4tozSV/kQr8Ap650jhX8QXMNdY+
         odOD5c1Nar4KcIv7kioB0FMpZO2hizUHN63Y+ui7GdosqJi3VQRspfj1Y9++P1tbgoF5
         qZscagmadhAqS1glK1Yz6rwS4d6blLViKer8Q=
Date: Mon, 13 Dec 2010 08:56:37 +0300
From: Dan Carpenter <error27@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: =?iso-8859-1?Q?L=2E_Alberto_Gim=E9nez?= <agimenez@sysvalve.es>,
        devel@linuxdriverproject.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Staging: rt2860: include KERN_* in printk
Message-ID: <20101213055637.GA1620@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Joe Perches <joe@perches.com>,
	=?iso-8859-1?Q?L=2E_Alberto_Gim=E9nez?= <agimenez@sysvalve.es>,
	devel@linuxdriverproject.org, Greg Kroah-Hartman <gregkh@suse.de>,
	linux-kernel@vger.kernel.org
References: <1292176591-26081-1-git-send-email-agimenez@sysvalve.es>
 <1292176591-26081-4-git-send-email-agimenez@sysvalve.es>
 <1292180668.18202.43.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1292180668.18202.43.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 12, 2010 at 11:04:28AM -0800, Joe Perches wrote:
> On Sun, 2010-12-12 at 18:56 +0100, L. Alberto Giménez wrote:
> > Fix checkpatch complains
> > diff --git a/drivers/staging/rt2860/common/ee_efuse.c b/drivers/staging/rt2860/common/ee_efuse.c
> []
> > @@ -281,8 +281,8 @@ int set_eFusedump_Proc(struct rt_rtmp_adapter *pAd, char *arg)
> >  
> >  		eFuseReadPhysical(pAd, &InBuf[0], 4, &InBuf[2], 2);
> >  		if (i % 4 == 0)
> > -			printk("\nBlock %x:", i / 8);
> > -		printk("%04x ", InBuf[2]);
> > +			printk(KERN_DEBUG "\nBlock %x:", i / 8);
> > +		printk(KERN_DEBUG "%04x ", InBuf[2]);
> >  	}
> >  	return TRUE;
> >  }
> 
> Not quite.  Use:
> 
> (before the for)
> 	printk(KERN_DEBUG "Block 0: ");
> 
> for(...)
> []
> 		if (i && i % 4 == 0) {
> 			printk(KERN_CONT "\n");
> 			printk(KERN_DEBUG "Block %x: ", i / 8);
> 		}
> 		printk(KERN_CONT " %04x", InBuf[2]);
> 	}
> 	printk(KERN_CONT "\n");
> 

This is dead code anyway.  Just remove the whole set_eFusedump_Proc()
function.

regards,
dan carpenter
