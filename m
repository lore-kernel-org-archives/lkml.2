Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab2KLNO5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 08:14:57 -0500
Received: from plane.gmane.org ([80.91.229.3]:46450 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751715Ab2KLNO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 08:14:56 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Peter Turczak <peter@turczak.de>
Subject: Re: [PATCH for 3.7] mtd: nand: fix Samsung SLC NAND identification regression
Date: Mon, 12 Nov 2012 12:53:44 +0000 (UTC)
Message-ID: <loom.20121112T134210-779@post.gmane.org>
References: <1349850366-4731-1-git-send-email-computersforpeace@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 93.198.136.66 (Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/534.57.2 (KHTML, like Gecko) Version/5.1.7 Safari/534.57.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Brian,

> This patch re-introduces a distinction between these old and new Samsung
> NAND by checking that the 6th byte is non-zero, allowing both old and
> new Samsung NAND to be detected properly.
Currently we're observing the same problem with our Samsung K9F2G08U0D nand 
device, but the patch provided does not resolve the issue.

Ours read back {0xec, 0xdc, 0x10, 0x95, 0x54, 0xec, 0xec, 0xdc}. The Samsung 
datasheet 
seems to be consistent with the routine called when neither Samsung or Hynix 
6 byte IDs are detected. 


>From your patch I deduce, maybe one could also check for 0xEC at the 6th byte
in order to find an old ID format?
Or maybe it might help to analyze the 2nd byte, as it is intended to be a
evice code. 
(   0xDC for K9F4G08U0D, 
    0xD3 for K9K8G08U0D,  
    0xDC for K9K8G08U1D 
and 0xD3 for K9WAG08U1D)
Anyway, it leads to a more convoluted code...

I would be very grateful to be hearing from you in this regard.

Best regards,
  Peter


