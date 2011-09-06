Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab1IFOri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 10:47:38 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:50438 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322Ab1IFOrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 10:47:32 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
Subject: Re: [PATCHv2] ISP:BUILD:FIX: Move media_entity_init() and
Date: Tue, 6 Sep 2011 16:47:31 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.3-gentoo; KDE/4.7.0; x86_64; ; )
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        "Ravi, Deepthy" <deepthy.ravi@ti.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
References: <1313761725-6614-1-git-send-email-deepthy.ravi@ti.com> <201109051449.50744.laurent.pinchart@ideasonboard.com> <19F8576C6E063C45BE387C64729E739404EC6BEE0C@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E739404EC6BEE0C@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109061647.31861.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vaibhav,

On Tuesday 06 September 2011 16:12:35 Hiremath, Vaibhav wrote:
> On Monday, September 05, 2011 6:20 PM Laurent Pinchart wrote:
> > On Sunday 04 September 2011 15:32:28 Mauro Carvalho Chehab wrote:
> 
> <snip>
> 
> > I don't mind splitting the config option. An alternative would be to
> > compile media_entity_init() and media_entity_cleanup() based on
> > CONFIG_MEDIA_SUPPORT instead of CONFIG_MEDIA_CONTROLLER, but that looks a
> > bit hackish to me.
> > 
> > > Also, I don't like the idea of increasing drivers complexity for the
> > > existing drivers that work properly without MC. All those core
> > > conversions that were done in the last two years caused already too much
> > > instability to them.
> > > 
> > > We should really avoid touching on them again for something that won't
> > > be adding any new feature nor fixing any known bug.
> > 
> > We don't have to convert them all in one go right now, we can implement
> > pad-level operations support selectively when a subdev driver becomes used
> > by an MC-enabled host/bridge driver.
> 
> I completely agree that we should not be duplicating the code just for sake
> of it.
> 
> Isn't the wrapper approach seems feasible here?

As explained in a previous e-mail, a wrapper sounds like a good approach to 
me, to emulate video::* operations based on pad::* operations. We want to move 
to pad::* operations, so we should not perform emulation the other way around.

-- 
Regards,

Laurent Pinchart
