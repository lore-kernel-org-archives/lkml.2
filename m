Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128Ab1HWX2c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 19:28:32 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:53787 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753515Ab1HWX14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 19:27:56 -0400
X-Sasl-enc: dNFJcn7AH4kbOxFM9jspkG336rhQRrGH4w7QDVYnw6dC 1314142075
Date: Tue, 23 Aug 2011 15:49:32 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 019/117] Staging: hv: vmbus: Cleanup vmbus_uevent() code
Message-ID: <20110823224932.GF9641@kroah.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-19-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310752065-27895-19-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 10:46:07AM -0700, K. Y. Srinivasan wrote:
> Now generate appropriate uevent based on the modalias string. As part of this,
> cleanup the existing uevent code.

Note, you just change the user api here, did you have tools that relied
on the old format?  If so, they just broke :(

> +	for (i = 0; i < (sizeof(struct hv_vmbus_device_id) * 2); i += 2)
> +		sprintf(&alias_name[i], "%02x", dev->dev_type.b[i/2]);

Don't we have a type for printing out a uuid already?

And what's with the jumping by 2 yet dividing?  What am I missing here?

greg k-h
