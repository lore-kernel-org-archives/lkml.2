Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758345Ab2K0IMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 03:12:53 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19910 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758252Ab2K0IMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 03:12:51 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 27 Nov 2012 00:12:43 -0800
Message-ID: <50B476E1.4070403@nvidia.com>
Date: Tue, 27 Nov 2012 10:16:33 +0200
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
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com> <1353935954-13763-9-git-send-email-tbergstrom@nvidia.com> <CAPM=9tzvt3J6D3zLPV97w629q62CNhAxX8V+_JZ6kmXxxz5fVg@mail.gmail.com> <50B46336.8030605@nvidia.com> <CAPM=9txCuPJcFAfD7Hu5o2BVFK=pVah7B8HhG0ctLCyFPwNEnA@mail.gmail.com>
In-Reply-To: <CAPM=9txCuPJcFAfD7Hu5o2BVFK=pVah7B8HhG0ctLCyFPwNEnA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.11.2012 09:33, Dave Airlie wrote:
>> Third would be having a firewall in 2D driver checking the stream and
>> ensuring all registers that accept addresses are written by values
>> derived from dmabufs. I haven't tried implementing this, but it'd
>> involve a lookup table in kernel and CPU reading through the command
>> stream. Offsets and sizes would also need to be validated. There would
>> be a performance hit.
> 
> This is the standard mechanism, and what exynos does as well.
> 
> The per process VM method is also used as an extension to this on some hw.

Hi,

Thanks for the pointer, I looked at exynos code. It indeed checks the
registers written to, but it doesn't prevent overrun by checking sizes
of buffers and compare against requests.

Based on my experience with Tegra graphics stack, going through command
streams in kernel is bad for performance. For 2D operations this is
probably ok as the command streams are pretty simple. Anything more
complex is going to cause severe degradation of performance, but it's
also outside the scope of this patch set.

If this is the way to go, I'll put the firewall behind a Kconfig flag so
that system integrator can decide if his system needs it.

Terje
