Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab1GPKfg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 06:35:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48136 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997Ab1GPKff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 06:35:35 -0400
Date: Sat, 16 Jul 2011 13:33:42 +0300
From: Dan Carpenter <error27@gmail.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 088/117] Staging: hv: netvsc: Inline the code for
 free_net_device()
Message-ID: <20110716103342.GJ18655@shale.localdomain>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-88-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310752065-27895-88-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 10:47:16AM -0700, K. Y. Srinivasan wrote:
> -static void free_net_device(struct netvsc_device *device)
> -{
> -	WARN_ON(atomic_read(&device->refcnt) != 0);
> -	device->dev->ext = NULL;

device->dev->ext points to device.  We set it NULL here to prevent
a use after free bug.  What prevents that in the new code?

> -	kfree(device);
> -}

regards,
dan carpenter


