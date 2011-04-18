Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab1DRXFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 19:05:43 -0400
Received: from mail.perches.com ([173.55.12.10]:4817 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893Ab1DRXFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 19:05:41 -0400
Subject: Re: [PATCH 1/2] drm: Create and use drm_err
From: Joe Perches <joe@perches.com>
To: Ian Romanick <idr@freedesktop.org>
Cc: David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
In-Reply-To: <4DACC1B1.8090808@freedesktop.org>
References: <cover.1303097621.git.joe@perches.com>
	 <d70d2c8ad548f99e8d028a2fbd4c5b35609f8917.1303097621.git.joe@perches.com>
	 <4DACC1B1.8090808@freedesktop.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Apr 2011 16:05:39 -0700
Message-ID: <1303167939.31723.47.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-18 at 15:56 -0700, Ian Romanick wrote:
> I believe that DRM_NAME is a define, and drm_stub.c is in common code.
> As a result, won't this change cause something different to get logged?

Nope.  DRM_NAME is #defined only once.

include/drm/drm.h:#define DRM_NAME	"drm"	

The only real reason to do this is the "*ERROR*"
used in:

> > -#define DRM_ERROR(fmt, arg...) \
> > -	printk(KERN_ERR "[" DRM_NAME ":%s] *ERROR* " fmt , __func__ , ##arg)

It'd be more or less similar to use:

#define DRM_ERROR(fmt, ...)	\
	pr_err("%s: " fmt, __func__, ##__VA_ARGS__)

or just convert DRM_ERROR to pr_err and DRM_INFO to pr_info.


