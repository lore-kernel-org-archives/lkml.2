Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427Ab1DFVAn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 17:00:43 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33423 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab1DFVAl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 17:00:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=MXHGO75TWC4MHGmdDNELu80JjPI1SlM43thDlJ6Fq25oWU6DmCBxlI3M7lNx190Arn
         8H3Tn74tuxb9q2EPDjJrunDnjHLxwxv79vGCKM55kp9s5aY9pSjcdi2ZyLxXHueMs2v9
         NduEwnoGkn1r60m6uwNBy7f2UANlQt/5Bs8uw=
Date: Wed, 6 Apr 2011 23:00:21 +0200
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: Bruce Stenning <b.stenning@indigovision.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-ide@vger.kernel.org
Subject: Re: sata_mv port lockup on hotplug (kernel 2.6.38.2)
Message-ID: <20110406230021.2ab54966@varda>
In-Reply-To: <C1438B59050E1B4C9482FF3266AD6BA32C7493559F@gretna.indigovision.com>
References: <C1438B59050E1B4C9482FF3266AD6BA32C7493557A@gretna.indigovision.com>
	<C1438B59050E1B4C9482FF3266AD6BA32C7493559F@gretna.indigovision.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Wed, 6 Apr 2011 15:57:06 +0100
Bruce Stenning <b.stenning@indigovision.com> escribió:


 Just CCing linux-ide

> Please accept my most humble apologies for the lack of line breaks in
> my previous email.  Here it is again, this time in a more readable
> format:
> 
> Hello,
> 
> We have a bespoke platform utilising a Marvell MV88SX6041 SATA controller
> on which we have been running Linux 2.6.26 and using the sata_mv driver.
> 
> We have noticed problems with SATA ports occasionally locking up (on
> hotplug events) and remaining unresponsive.  The normal kernel logging
> that occurs on hotplug events is no longer emitted for the locked ports
> (but will be emitted for the other sata ports that have not exhibited
> the problem.)  The disks attached to the locked ports are completely
> unresponsive.  The condition can be cleared by removing the sata_mv
> kernel module from memory and reloading it, after which the kernel
> logging becomes active (and the disks are usable) for all ports.
> 
> The following changeset was seen as a strong candidate for addressing
> this problem:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=933cb8e5fcdebd4b666165e3f039f814d62b0e52
> 
> We are now in the process of upgrading to the stable 2.6.38.2 kernel
> release, but initial testing of this on our platform exhibits the same
> hotplug behaviour.  Hotplug is possible, but occasionally the ports
> will lock up and not be responsive until sata_mv is removed and
> reinstalled.  Other than this, the new kernel and driver seem to be
> operating normally.
> 
> Has this problem been observed elsewhere with kernels that include the
> above patch?  Please CC me in replies.
> 
> Kind Regards,
> 
> Bruce Stenning,
> IndigoVision,
> b <dot> stenning <at> indigovision <dot> com
> 
> 
> Latest News at: http://www.indigovision.com/news2011.php
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
