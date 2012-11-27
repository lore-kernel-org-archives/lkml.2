Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab2K0Lry (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 06:47:54 -0500
Received: from ns.km20343-01.keymachine.de ([84.19.182.79]:49401 "EHLO
	km20343-01.keymachine.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754818Ab2K0Lrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 06:47:52 -0500
Message-ID: <1354016870.1479.41.camel@tellur>
Subject: Re: [RFC v2 8/8] drm: tegra: Add gr2d device
From: Lucas Stach <dev@lynxeye.de>
To: Terje =?ISO-8859-1?Q?Bergstr=F6m?= <tbergstrom@nvidia.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Dave Airlie <airlied@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Date: Tue, 27 Nov 2012 12:47:50 +0100
In-Reply-To: <50B4A483.8030305@nvidia.com>
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
	 <1353935954-13763-9-git-send-email-tbergstrom@nvidia.com>
	 <CAPM=9tzvt3J6D3zLPV97w629q62CNhAxX8V+_JZ6kmXxxz5fVg@mail.gmail.com>
	 <50B46336.8030605@nvidia.com>
	 <CAPM=9txCuPJcFAfD7Hu5o2BVFK=pVah7B8HhG0ctLCyFPwNEnA@mail.gmail.com>
	 <50B476E1.4070403@nvidia.com>
	 <CAPM=9tysiK6LgnQdAwGSYfxnQfgcfRm0+X2tPSAEDxUPt-QZGA@mail.gmail.com>
	 <50B47DA8.60609@nvidia.com> <1354011776.1479.31.camel@tellur>
	 <20121127103739.GA3329@avionic-0098.adnet.avionic-design.de>
	 <50B4A483.8030305@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 27.11.2012, 13:31 +0200 schrieb Terje Bergström:
> On 27.11.2012 12:37, Thierry Reding wrote:
> > But in that case it should be made mandatory at first until proper IOMMU
> > support is enabled on Tegra30. Then it can be checked at driver probe
> > time whether or not to enable the extra checks. That way we don't need a
> > special Kconfig option and we still get all the security that we need,
> > right?
> 
> I guess it depends on the level of security.
> 
> If we want to only protect kernel and user space memory, this would be
> sufficient and no firewall is needed if IOMMU is turned on.
> 
> If we want to protect 2D buffers from each other, this is not sufficient.
> 
I guess we could change IOMMU address spaces for the graphics units
depending on the active channel. This would still be a bit of a
performance hit, because of the necessary TLB flushing and so on, but
should be much better than checking the whole command stream. This way
you at least get security on a process level, as no process is able to
corrupt another processes graphics resources.

This is the same level of security as provided by the nouveau driver.
But to do so all memory management has to be done in kernel and from the
current submissions of the 2D infrastructure I fear that the current
architecture does too much of that in userspace, but I'll hold back with
any judgement until we actually get to see the userspace parts.

Also to implement this strategy you have to take ownership of the
graphics address space on a much lower level than the DMA API. This
might take some work together with the IOMMU guys.

Regards,
Lucas

