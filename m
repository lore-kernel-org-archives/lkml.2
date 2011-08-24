Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab1HXL3e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 07:29:34 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:54455 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057Ab1HXL3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 07:29:32 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Ravi, Deepthy" <deepthy.ravi@ti.com>
Subject: Re: [PATCHv2] ISP:BUILD:FIX: Move media_entity_init() and
Date: Wed, 24 Aug 2011 13:29:47 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37-gentoo-r3; KDE/4.6.5; x86_64; ; )
Cc: "mchehab@infradead.org" <mchehab@infradead.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Hiremath, Vaibhav" <hvaibhav@ti.com>
References: <1313761725-6614-1-git-send-email-deepthy.ravi@ti.com> <201108241217.11430.laurent.pinchart@ideasonboard.com> <ADF30F4D7BDE934D9B632CE7D5C7ACA4047C4D0907F6@dbde03.ent.ti.com>
In-Reply-To: <ADF30F4D7BDE934D9B632CE7D5C7ACA4047C4D0907F6@dbde03.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108241329.48147.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday 24 August 2011 13:21:27 Ravi, Deepthy wrote:
> On Wed, Aug 24, 2011 at 4:47 PM, Laurent Pinchart wrote:
> > On Friday 19 August 2011 15:48:45 Deepthy Ravi wrote:
> >> From: Vaibhav Hiremath <hvaibhav@ti.com>
> >> 
> >> Fix the build break caused when CONFIG_MEDIA_CONTROLLER
> >> option is disabled and if any sensor driver has to be used
> >> between MC and non MC framework compatible devices.
> >> 
> >> For example,if tvp514x video decoder driver migrated to
> >> MC framework is being built without CONFIG_MEDIA_CONTROLLER
> >> option enabled, the following error messages will result.
> >> drivers/built-in.o: In function `tvp514x_remove':
> >> drivers/media/video/tvp514x.c:1285: undefined reference to
> >> `media_entity_cleanup'
> >> drivers/built-in.o: In function `tvp514x_probe':
> >> drivers/media/video/tvp514x.c:1237: undefined reference to
> >> `media_entity_init'
> > 
> > If the tvp514x is migrated to the MC framework, its Kconfig option should
> > depend on MEDIA_CONTROLLER.
>
> The same TVP514x driver is being used for both MC and non MC compatible
> devices, for example OMAP3 and AM35x. So if it is made dependent on MEDIA
> CONTROLLER, we cannot enable the driver for MC independent devices.

Then you should use conditional compilation in the tvp514x driver itself. Or 
better, port the AM35x driver to the MC API.

-- 
Regards,

Laurent Pinchart
