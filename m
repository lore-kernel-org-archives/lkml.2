Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719Ab2K0XA5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 18:00:57 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:55148 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159Ab2K0XAz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 18:00:55 -0500
MIME-Version: 1.0
In-Reply-To: <50B4A483.8030305@nvidia.com>
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
	<1353935954-13763-9-git-send-email-tbergstrom@nvidia.com>
	<CAPM=9tzvt3J6D3zLPV97w629q62CNhAxX8V+_JZ6kmXxxz5fVg@mail.gmail.com>
	<50B46336.8030605@nvidia.com>
	<CAPM=9txCuPJcFAfD7Hu5o2BVFK=pVah7B8HhG0ctLCyFPwNEnA@mail.gmail.com>
	<50B476E1.4070403@nvidia.com>
	<CAPM=9tysiK6LgnQdAwGSYfxnQfgcfRm0+X2tPSAEDxUPt-QZGA@mail.gmail.com>
	<50B47DA8.60609@nvidia.com>
	<1354011776.1479.31.camel@tellur>
	<20121127103739.GA3329@avionic-0098.adnet.avionic-design.de>
	<50B4A483.8030305@nvidia.com>
Date: Wed, 28 Nov 2012 09:00:54 +1000
Message-ID: <CAPM=9tz=_0Drx3=Me3EQdPgBvYVGzs6Gnqaw6RBaTLsCG24RAg@mail.gmail.com>
Subject: Re: [RFC v2 8/8] drm: tegra: Add gr2d device
From: Dave Airlie <airlied@gmail.com>
To: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Lucas Stach <dev@lynxeye.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 9:31 PM, Terje Bergström <tbergstrom@nvidia.com> wrote:
> On 27.11.2012 12:37, Thierry Reding wrote:
>> But in that case it should be made mandatory at first until proper IOMMU
>> support is enabled on Tegra30. Then it can be checked at driver probe
>> time whether or not to enable the extra checks. That way we don't need a
>> special Kconfig option and we still get all the security that we need,
>> right?
>
> I guess it depends on the level of security.
>
> If we want to only protect kernel and user space memory, this would be
> sufficient and no firewall is needed if IOMMU is turned on.
>
> If we want to protect 2D buffers from each other, this is not sufficient.

We  generally aim for the first, to stop the gpu from reading/writing
any memory it hasn't been granted access to,
the second is nice to have though, but really requires a GPU with VM
to implement properly.

Dave.
