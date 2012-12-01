Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab2LARIX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 12:08:23 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3250 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab2LARIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 12:08:22 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sat, 01 Dec 2012 09:07:57 -0800
Message-ID: <50BA397C.7050707@nvidia.com>
Date: Sat, 1 Dec 2012 19:08:12 +0200
From: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2 0/8] Support for Tegra 2D hardware
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com> <20121201144512.GA18209@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20121201144512.GA18209@avionic-0098.adnet.avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.12.2012 16:45, Thierry Reding wrote:
> I did some prototyping on how a libdrm API could look like a few weeks
> back. I should clean the patches up some and push them to a public
> repository or to the mailing lists for review.

Ok. Sorry about the delay - I recently learned I need separate
permission for user space contribution, so I'm pushing to get that
permission.

> There isn't actually much more than a bit of framework along with two
> IOCTLs that allow creating and looking up a Tegra-specific GEM. The
> related kernel patches aren't available anywhere since I didn't deem
> them ready yet. At that time I wasn't even sure if we'd need special
> allocations other than what the dumb BO infrastructure provides. They
> implement some parts of what you've implemented in this series as well,
> with some slight differences.

Ok, the BO infra is still under flux as we're designing the best place
and work split.

> Currently these still use the CMA-backed GEM objects but it should be
> easy to switch to something backed by the host1x infrastructure once
> that's in good shape.

Sounds good.

> While I can't find the quote right now, I seem to remember that you said
> at some point that you were planning on adding some 2D acceleration bits
> to libdrm. I don't think that's the right place. That code should rather
> go into the DDX. libdrm should instead provide a thin layer on top of
> the DRM IOCTLs to manage buffers and submit command streams. I hope I
> can finish the cleanup of my libdrm patches over the weekend and push
> them out so this may become clearer. Maybe I can even get the
> corresponding kernel patches pushed out.

Yep, that's exactly what I actually posed as a question in one of the
earlier mails. We also agree that 2D bits should not stay in libdrm.
That's why we've kept the 2D bits design-wise separate from the host1x
stream generation.

We don't yet have any other place to put 2D functions in, so we'll
probably post them as part of patch series to libdrm. We'll just add a
disclaimer that the 2D code won't remain in libdrm, and wanted to get
the code out to review as a code example. We can put the 2D code either
to a separate library or to DDX, whichever is preferred.

The host1x command stream generation would still remain in libdrm. That
seems to be the pattern with other hardware.

Best regards,
Terje
