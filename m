Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758321Ab2K0Ick (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 03:32:40 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:60469 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313Ab2K0Ici convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 03:32:38 -0500
MIME-Version: 1.0
In-Reply-To: <50B476E1.4070403@nvidia.com>
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
	<1353935954-13763-9-git-send-email-tbergstrom@nvidia.com>
	<CAPM=9tzvt3J6D3zLPV97w629q62CNhAxX8V+_JZ6kmXxxz5fVg@mail.gmail.com>
	<50B46336.8030605@nvidia.com>
	<CAPM=9txCuPJcFAfD7Hu5o2BVFK=pVah7B8HhG0ctLCyFPwNEnA@mail.gmail.com>
	<50B476E1.4070403@nvidia.com>
Date: Tue, 27 Nov 2012 08:32:38 +0000
Message-ID: <CAPM=9tysiK6LgnQdAwGSYfxnQfgcfRm0+X2tPSAEDxUPt-QZGA@mail.gmail.com>
Subject: Re: [RFC v2 8/8] drm: tegra: Add gr2d device
From: Dave Airlie <airlied@gmail.com>
To: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
Cc: "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 8:16 AM, Terje Bergström <tbergstrom@nvidia.com> wrote:
> On 27.11.2012 09:33, Dave Airlie wrote:
>>> Third would be having a firewall in 2D driver checking the stream and
>>> ensuring all registers that accept addresses are written by values
>>> derived from dmabufs. I haven't tried implementing this, but it'd
>>> involve a lookup table in kernel and CPU reading through the command
>>> stream. Offsets and sizes would also need to be validated. There would
>>> be a performance hit.
>>
>> This is the standard mechanism, and what exynos does as well.
>>
>> The per process VM method is also used as an extension to this on some hw.
>
> Hi,
>
> Thanks for the pointer, I looked at exynos code. It indeed checks the
> registers written to, but it doesn't prevent overrun by checking sizes
> of buffers and compare against requests.

They probably need to add that, its not as important as the base
addresses, unless it takes negative strides, generally base addresses
means you can target current->uid quite easily!

> Based on my experience with Tegra graphics stack, going through command
> streams in kernel is bad for performance. For 2D operations this is
> probably ok as the command streams are pretty simple. Anything more
> complex is going to cause severe degradation of performance, but it's
> also outside the scope of this patch set.
>
> If this is the way to go, I'll put the firewall behind a Kconfig flag so
> that system integrator can decide if his system needs it.

We don't generally make security like this optional :-)

If you do that you should restrict the drm device to root users only,
and never let a user with a browser anywhere near it.

Like I know what you guys get away with in closed source world, but
here we don't write root holes into our driver deliberately.

Dave.
