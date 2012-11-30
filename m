Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab2K3HxK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 02:53:10 -0500
Received: from ns.km20343-01.keymachine.de ([84.19.182.79]:40897 "EHLO
	km20343-01.keymachine.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752129Ab2K3HxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 02:53:08 -0500
Message-ID: <1354261985.1479.179.camel@tellur>
Subject: Re: [RFC v2 8/8] drm: tegra: Add gr2d device
From: Lucas Stach <dev@lynxeye.de>
To: Terje =?ISO-8859-1?Q?Bergstr=F6m?= <tbergstrom@nvidia.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Dave Airlie <airlied@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Date: Fri, 30 Nov 2012 08:53:05 +0100
In-Reply-To: <50B863E4.50700@nvidia.com>
References: <50B60EFF.1050703@nvidia.com> <1354109602.1479.66.camel@tellur>
	 <50B61845.6060102@nvidia.com> <1354111565.1479.73.camel@tellur>
	 <50B6237B.8010808@nvidia.com> <1354115609.1479.91.camel@tellur>
	 <50B63A70.8020107@nvidia.com> <1354128408.1479.137.camel@tellur>
	 <50B71A28.5060807@nvidia.com> <1354180153.1479.162.camel@tellur>
	 <20121129121430.GA3846@avionic-0098.adnet.avionic-design.de>
	 <50B863E4.50700@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 30.11.2012, 09:44 +0200 schrieb Terje Bergström:
> On 29.11.2012 14:14, Thierry Reding wrote:
> > On Thu, Nov 29, 2012 at 10:09:13AM +0100, Lucas Stach wrote:
> >> This way you would also be able to construct different handles (like GEM
> >> obj or V4L2 buffers) from the same backing nvhost object. Note that I'm
> >> not sure how useful this would be, but it seems like a reasonable design
> >> to me being able to do so.
> > 
> > Wouldn't that be useful for sharing buffers between DRM and V4L2 using
> > dma-buf? I'm not very familiar with how exactly importing and exporting
> > work with dma-buf, so maybe I need to read up some more.
> 
> I would still preserve the dma-buf support, for exactly this purpose.
> 
dma-buf is useful and should be preserved, as some userspace like
gstreamer might rely on us being able to import/export dma-buf handles
at some time. At the very latest we'll need it if someone wants to run a
UDL device to scanout a buffer rendered to by the internal GPU.

What I'm saying is just that with a common allocator we could cut down a
lot on the usage of dma-buf, where not really necessary. Also you might
be able to do some optimisations based on the fact that a dma-buf handle
exported for some V4L2 buffer, which gets imported into DRM to construct
a GEM object, is the very same nvhost object in the end.

Regards,
Lucas

