Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422640Ab2KUU5C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 15:57:02 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41576 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S964798Ab2KUU5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 15:57:00 -0500
Date: Wed, 21 Nov 2012 22:56:55 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Prabhakar Lad <prabhakar.lad@ti.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v2 00/12] Media Controller capture driver for DM365
Message-ID: <20121121205655.GA31442@valkosipuli.retiisi.org.uk>
References: <1353077114-19296-1-git-send-email-prabhakar.lad@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353077114-19296-1-git-send-email-prabhakar.lad@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

On Fri, Nov 16, 2012 at 08:15:02PM +0530, Prabhakar Lad wrote:
> From: Manjunath Hadli <manjunath.hadli@ti.com>
> 
> This patch set adds media controller based capture driver for
> DM365.
> 
> This driver bases its design on Laurent Pinchart's Media Controller Design
> whose patches for Media Controller and subdev enhancements form the base.
> The driver also takes copious elements taken from Laurent Pinchart and
> others' OMAP ISP driver based on Media Controller. So thank you all the
> people who are responsible for the Media Controller and the OMAP ISP driver.
> 
> Also, the core functionality of the driver comes from the arago vpfe capture
> driver of which the isif capture was based on V4L2, with other drivers like
> ipipe, ipipeif and Resizer.
> 
> Changes for v2:
> 1: Migrated the driver for videobuf2 usage pointed Hans.
> 2: Changed the design as pointed by Laurent, Exposed one more subdevs
>    ipipeif and split the resizer subdev into three subdevs.
> 3: Rearrganed the patch sequence and changed the commit messages.
> 4: Changed the file architecture as pointed by Laurent.
> 
> Manjunath Hadli (12):
>   davinci: vpfe: add v4l2 capture driver with media interface
>   davinci: vpfe: add v4l2 video driver support
>   davinci: vpfe: dm365: add IPIPEIF driver based on media framework
>   davinci: vpfe: dm365: add ISIF driver based on media framework
>   davinci: vpfe: dm365: add IPIPE support for media controller driver
>   davinci: vpfe: dm365: add IPIPE hardware layer support
>   davinci: vpfe: dm365: resizer driver based on media framework
>   davinci: vpss: dm365: enable ISP registers
>   davinci: vpss: dm365: set vpss clk ctrl
>   davinci: vpss: dm365: add vpss helper functions to be used in the
>     main driver for setting hardware parameters
>   davinci: vpfe: dm365: add build infrastructure for capture driver
>   davinci: vpfe: Add documentation

Many thanks for taking the driver this far!

However, I feel that there's still some work to do, especially in the user
space API. Some things could be implemented using the generic API but
currently use davinci-specific API; private IOCTL is being used where
controls would do, and resizing is enabled or disable explicitly in ipipeif
configuration. Also, there are things such as internal clock frequencies
visible in the API.

I can go to more details soon after taking a closer look at the patches.

If you wish to get this to mainline kernel fast, a viable option IMO would
be the staging tree.

What do you think?

Cc Hans and Laurent.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
