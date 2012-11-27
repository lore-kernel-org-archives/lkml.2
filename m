Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933490Ab2K0KXB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 05:23:01 -0500
Received: from ns.km20343-01.keymachine.de ([84.19.182.79]:55529 "EHLO
	km20343-01.keymachine.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933309Ab2K0KW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 05:22:59 -0500
Message-ID: <1354011776.1479.31.camel@tellur>
Subject: Re: [RFC v2 8/8] drm: tegra: Add gr2d device
From: Lucas Stach <dev@lynxeye.de>
To: Terje =?ISO-8859-1?Q?Bergstr=F6m?= <tbergstrom@nvidia.com>
Cc: Dave Airlie <airlied@gmail.com>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Date: Tue, 27 Nov 2012 11:22:56 +0100
In-Reply-To: <50B47DA8.60609@nvidia.com>
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
	 <1353935954-13763-9-git-send-email-tbergstrom@nvidia.com>
	 <CAPM=9tzvt3J6D3zLPV97w629q62CNhAxX8V+_JZ6kmXxxz5fVg@mail.gmail.com>
	 <50B46336.8030605@nvidia.com>
	 <CAPM=9txCuPJcFAfD7Hu5o2BVFK=pVah7B8HhG0ctLCyFPwNEnA@mail.gmail.com>
	 <50B476E1.4070403@nvidia.com>
	 <CAPM=9tysiK6LgnQdAwGSYfxnQfgcfRm0+X2tPSAEDxUPt-QZGA@mail.gmail.com>
	 <50B47DA8.60609@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 27.11.2012, 10:45 +0200 schrieb Terje Bergström:
> On 27.11.2012 10:32, Dave Airlie wrote:
> > On Tue, Nov 27, 2012 at 8:16 AM, Terje Bergström <tbergstrom@nvidia.com> wrote:
> >> Thanks for the pointer, I looked at exynos code. It indeed checks the
> >> registers written to, but it doesn't prevent overrun by checking sizes
> >> of buffers and compare against requests.
> > They probably need to add that, its not as important as the base
> > addresses, unless it takes negative strides, generally base addresses
> > means you can target current->uid quite easily!
> 
> Ok. We'll implement the firewall, unless we come up with even a better
> choice.
> 
> >> If this is the way to go, I'll put the firewall behind a Kconfig flag so
> >> that system integrator can decide if his system needs it.
> > We don't generally make security like this optional :-)
> > 
> > If you do that you should restrict the drm device to root users only,
> > and never let a user with a browser anywhere near it.
> 
Personally I would never trust any binary, but that's just my personal
opinion.

But I'm in favour of having the command stream checking optional, simply
backed by the fact that we are likely to use the same 2D driver
infrastructure for Tegra 2 and 3. On Tegra 3 we can most likely go
without in-depth command stream checking as the graphics core there sits
behind the IOMMU, which can provide an appropriate level of security.

Regards,
Lucas


