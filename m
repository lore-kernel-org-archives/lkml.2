Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab1HYQ5B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:57:01 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:56603 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab1HYQ47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:56:59 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 2/2] V4L: mx3-camera: prepare to support multi-size buffers
Date: Thu, 25 Aug 2011 18:57:16 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37-gentoo-r3; KDE/4.6.5; x86_64; ; )
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, Pawel Osciak <pawel@osciak.com>,
        Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sascha Hauer <kernel@pengutronix.de>
References: <1314211292-10414-1-git-send-email-g.liakhovetski@gmx.de> <Pine.LNX.4.64.1108251838090.17190@axis700.grange> <Pine.LNX.4.64.1108251843350.17190@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1108251843350.17190@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108251857.16865.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guennadi,

On Thursday 25 August 2011 18:46:03 Guennadi Liakhovetski wrote:
> Prepare the mx3_camera friver to support the new VIDIOC_CREATE_BUFS and
> VIDIOC_PREPARE_BUF ioctl()s. The .queue_setup() vb2 operation must be
> able to handle buffer sizes, provided by the caller, and the
> .buf_prepare() operation must not use the currently configured frame
> format for its operation, which makes it superfluous for this driver.
> Its functionality is moved into .buf_queue().

You're moving the ichan->dma_chan.device->device_prep_slave_sg() call from 
.buf_prepare() to .buf_queue(). Is that call cheap ? Otherwise it would be 
better to keep the .buf_prepare() callback.

-- 
Regards,

Laurent Pinchart
