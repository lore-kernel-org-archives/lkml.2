Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab2JDKOV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 06:14:21 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:54117 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715Ab2JDKOU convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Thu, 4 Oct 2012 06:14:20 -0400
Message-Id: <506D7D9A020000780009F9C8@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 04 Oct 2012 11:14:18 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "David Vrabel" <david.vrabel@citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 2/6] xen-blkfront: handle backend
 CLOSED without CLOSING
References: <1348243464-15903-1-git-send-email-david.vrabel@citrix.com>
 <1348243464-15903-3-git-send-email-david.vrabel@citrix.com>
 <5061EFB2.1080407@citrix.com>
In-Reply-To: <5061EFB2.1080407@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 25.09.12 at 19:53, David Vrabel <david.vrabel@citrix.com> wrote:
> @@ -1167,7 +1168,8 @@ blkfront_closing(struct blkfront_info *info)
>  
>  	mutex_lock(&bdev->bd_mutex);
>  
> -	if (bdev->bd_openers) {
> +	/* If the backend is already CLOSED, close now. */
> +	if (bdev->bd_openers && backend_state != XenbusStateClosed) {
>  		xenbus_dev_error(xbdev, -EBUSY,
>  				 "Device in use; refusing to close");
>  		xenbus_switch_state(xbdev, XenbusStateClosing);

This looks wrong to me on a second glance: As long as there
are users of the device, I don't think we want to go into Closed
ourselves, irrespective of the backend state.

Jan

