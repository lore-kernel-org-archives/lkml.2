Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab2JDUem (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 16:34:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37069 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751640Ab2JDUek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 16:34:40 -0400
Date: Thu, 4 Oct 2012 21:34:36 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        James Bottomley <JBottomley@Parallels.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-ID: <20121004203436.GD13292@decadent.org.uk>
References: <6a854f579a99b4fe2efaca1057e8ae22@local>
 <20121001225201.376690206@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121001225201.376690206@1wt.eu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [ 089/180] SCSI: fix scsi_wait_scan
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 12:53:26AM +0200, Willy Tarreau wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: James Bottomley <jbottomley@parallels.com>
> 
> commit 1ff2f40305772b159a91c19590ee159d3a504afc upstream.
> 
> Commit  c751085943362143f84346d274e0011419c84202
> Author: Rafael J. Wysocki <rjw@sisk.pl>
> Date:   Sun Apr 12 20:06:56 2009 +0200
> 
>     PM/Hibernate: Wait for SCSI devices scan to complete during resume
> 
> Broke the scsi_wait_scan module in 2.6.30.  Apparently debian still uses it so
> fix it and backport to stable before removing it in 3.6.
[...]
> --- a/drivers/scsi/scsi_wait_scan.c
> +++ b/drivers/scsi/scsi_wait_scan.c
> @@ -13,6 +13,7 @@
>  #include <linux/module.h>
>  #include <linux/device.h>
>  #include <scsi/scsi_scan.h>
> +#include "scsi_priv.h"
>  
>  static int __init wait_scan_init(void)
>  {

This backported version is a no-op.  I think we need to do:

-#include <scsi/scsi_scan.h>
+
+extern int scsi_complete_async_scans(void);

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
