Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555Ab2IRHnP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 03:43:15 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:39478 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932520Ab2IRHnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 03:43:10 -0400
Date: Tue, 18 Sep 2012 10:42:39 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: navin patidar <navinp@cdac.in>
Cc: gregkh@linuxfoundation.org, mfm@muteddisk.com, devel@driverdev.osuosl.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: usbip: vhci_hcd: Fixed oops during removal of
 vhci_hcd
Message-ID: <20120918074239.GM4587@mwanda>
References: <1347943616-5955-1-git-send-email-navinp@cdac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347943616-5955-1-git-send-email-navinp@cdac.in>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 10:16:56AM +0530, navin patidar wrote:
> In response to "usbip detach -p [port_number]" user command,vhci_shoutdown_connection gets
> executed which kills tcp_tx,tcp_rx kernel threads and then vhci_device_reset resets
> all usb_device struct variables except kernel thread pointers.
> 
> so, at the time of vhci_hcd removal vhci_shoutdown_connection tries to kill kernel threads
> which are already killed.
> 

Obviously, the same question would apply here.  Why don't you do
this in the shutdown function?

regards,
dan carpenter

