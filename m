Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab2K1NOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 08:14:12 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16599 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284Ab2K1NOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 08:14:11 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 28 Nov 2012 05:13:55 -0800
Message-ID: <50B60EFF.1050703@nvidia.com>
Date: Wed, 28 Nov 2012 15:17:51 +0200
From: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        Lucas Stach <dev@lynxeye.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: Re: [RFC v2 8/8] drm: tegra: Add gr2d device
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com> <1353935954-13763-9-git-send-email-tbergstrom@nvidia.com> <CAPM=9tzvt3J6D3zLPV97w629q62CNhAxX8V+_JZ6kmXxxz5fVg@mail.gmail.com> <50B46336.8030605@nvidia.com> <CAPM=9txCuPJcFAfD7Hu5o2BVFK=pVah7B8HhG0ctLCyFPwNEnA@mail.gmail.com> <50B476E1.4070403@nvidia.com> <CAPM=9tysiK6LgnQdAwGSYfxnQfgcfRm0+X2tPSAEDxUPt-QZGA@mail.gmail.com> <50B47DA8.60609@nvidia.com>	<1354011776.1479.31.camel@tellur> <20121127103739.GA3329@avionic-0098.adnet.avionic-design.de> <50B4A483.8030305@nvidia.com> <CAPM=9tz=_0Drx3=Me3EQdPgBvYVGzs6Gnqaw6RBaTLsCG24RAg@mail.gmail.com>
In-Reply-To: <CAPM=9tz=_0Drx3=Me3EQdPgBvYVGzs6Gnqaw6RBaTLsCG24RAg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.11.2012 01:00, Dave Airlie wrote:
> We  generally aim for the first, to stop the gpu from reading/writing
> any memory it hasn't been granted access to,
> the second is nice to have though, but really requires a GPU with VM
> to implement properly.

I wonder if we should aim at root only access on Tegra20, and force
IOMMU on Tegra30 and fix the remaining issues we have with IOMMU. The
firewall turns out to be more complicated than I wished.

Biggest problem is that we aim at zero-copy for everything possible,
including command streams. Kernel gets a handle to a command stream, but
the command stream is allocated by the user space process. So the user
space can tamper with the stream once it's been written to the host1x 2D
channel.

Copying with firewall is one option, but that would again kill the
performance. One option would be user space unmapping the command buffer
when it's sent to kernel, and kernel checking that it's unmapped before
it agrees to send the stream to hardware.

On Tegra30 with IOMMU turned on things are ok without any checks,
because all access would go via MMU, which makes kernel memory inaccessible.

Of course, better ideas are welcome.

Terje
