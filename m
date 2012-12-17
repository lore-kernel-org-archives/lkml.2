Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab2LQOPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 09:15:37 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:38664 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab2LQOPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 09:15:36 -0500
Date: Mon, 17 Dec 2012 17:13:45 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sebastian Wankerl <sisewank@cip.cs.fau.de>
Cc: linux-kernel@i4.informatik.uni-erlangen.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Sebastian Wankerl 
	<sisewank@faui49man10.informatik.uni-erlangen.de>,
        Sebastian Ehrenfels <qi50dube@cip.cs.fau.de>
Subject: Re: [PATCH 3/3] wlan-ng/prism2mgmt.c Replace printk(...) with
 netdev_warn, netdev_err
Message-ID: <20121217141345.GS5083@mwanda>
References: <1355751483-7059-1-git-send-email-sisewank@cip.cs.fau.de>
 <1355751483-7059-3-git-send-email-sisewank@cip.cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355751483-7059-3-git-send-email-sisewank@cip.cs.fau.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 02:38:03PM +0100, Sebastian Wankerl wrote:
> @@ -261,15 +265,17 @@ int prism2mgmt_scan(wlandevice_t *wlandev, void *msgp)
>  					HFA384x_RID_CREATEIBSS,
>  					HFA384x_CREATEIBSS_JOINCREATEIBSS);
>  		if (result) {
> -			printk(KERN_ERR "Failed to set CREATEIBSS.\n");
> +			netdev_err(wlandev->netdev,
> +				"Failed to set CREATEIBSS.\n");
>  			msg->resultcode.data =
>  			    P80211ENUM_resultcode_implementation_failure;
>  			goto exit;
>  		}
>  		result = hfa384x_drvr_enable(hw, 0);
>  		if (result) {
> -			printk(KERN_ERR "drvr_enable(0) failed. "
> -			       "result=%d\n", result);
> +			netdev_err(wlandev->netdev,
> +				"drvr_enable(0) failed. " "result=%d\n",
                                                        ^^^

Delete this.

regards,
dan carpenter
