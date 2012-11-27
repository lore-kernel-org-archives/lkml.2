Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933046Ab2K0Ilw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 03:41:52 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2788 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758356Ab2K0Ils convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 03:41:48 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 27 Nov 2012 00:41:38 -0800
Message-ID: <50B47DA8.60609@nvidia.com>
Date: Tue, 27 Nov 2012 10:45:28 +0200
From: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: Re: [RFC v2 8/8] drm: tegra: Add gr2d device
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com> <1353935954-13763-9-git-send-email-tbergstrom@nvidia.com> <CAPM=9tzvt3J6D3zLPV97w629q62CNhAxX8V+_JZ6kmXxxz5fVg@mail.gmail.com> <50B46336.8030605@nvidia.com> <CAPM=9txCuPJcFAfD7Hu5o2BVFK=pVah7B8HhG0ctLCyFPwNEnA@mail.gmail.com> <50B476E1.4070403@nvidia.com> <CAPM=9tysiK6LgnQdAwGSYfxnQfgcfRm0+X2tPSAEDxUPt-QZGA@mail.gmail.com>
In-Reply-To: <CAPM=9tysiK6LgnQdAwGSYfxnQfgcfRm0+X2tPSAEDxUPt-QZGA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.11.2012 10:32, Dave Airlie wrote:
> On Tue, Nov 27, 2012 at 8:16 AM, Terje Bergström <tbergstrom@nvidia.com> wrote:
>> Thanks for the pointer, I looked at exynos code. It indeed checks the
>> registers written to, but it doesn't prevent overrun by checking sizes
>> of buffers and compare against requests.
> They probably need to add that, its not as important as the base
> addresses, unless it takes negative strides, generally base addresses
> means you can target current->uid quite easily!

Ok. We'll implement the firewall, unless we come up with even a better
choice.

>> If this is the way to go, I'll put the firewall behind a Kconfig flag so
>> that system integrator can decide if his system needs it.
> We don't generally make security like this optional :-)
> 
> If you do that you should restrict the drm device to root users only,
> and never let a user with a browser anywhere near it.

My thinking was that the system integrator can decide how much he trusts
the binaries (incl. browser plugins) in the system. If he trusts the
binaries, the firewall can be turned off.

> Like I know what you guys get away with in closed source world, but
> here we don't write root holes into our driver deliberately.

Duly noted. :-)

Terje
