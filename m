Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab1JPWcW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 18:32:22 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:64542 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637Ab1JPWcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 18:32:21 -0400
Date: Mon, 17 Oct 2011 01:28:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, dmitry.torokhov@gmail.com,
        Haiyang Zhang <haiyangz@microsoft.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
        linux-input@vger.kernel.org, devel@linuxdriverproject.org
Subject: Re: [PATCH 1/1] Staging: hv: mousevsc: Move the mouse driver out of
 staging
Message-ID: <20111016222847.GM18470@longonot.mountain>
References: <1318658907-16698-1-git-send-email-kys@microsoft.com>
 <1318660596.6035.27.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318660596.6035.27.camel@Joe-Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4E9B5B4F.001B:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 11:36:36PM -0700, Joe Perches wrote:
> This do {} while (1); seems like it could be simpler,
> less indented and less confusing if it used continues
> or gotos like below (if I wrote it correctly...)
> 
> loop:
> 	ret = vmbus_bus_recvpacket_raw(device->channel, buffer,
> 				       bufferlen, &bytes_recvd, &req_id);
> 	switch (ret) {
> 	case -ENOBUFS:
> 		/* Handle large packet */
> 		bufferlen = bytes_recvd;
> 		buffer = kzalloc(bytes_recvd, GFP_ATOMIC);
> /*
> Why kzalloc and not kmalloc?
> The stack variable packet is not memset to 0,
> why should buffer be zeroed?
> */
> 		if (!buffer)
> 			return;
> 		goto loop;
> 	case 0:
> 		if (bytes_recvd <= 0)
> 			goto loop;

In the original we called break here (which is equivelent to a
return).  Btw setting a stack variable and then returning immediately
like the original code did is pointless.

regards,
dan carpenter
