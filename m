Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514Ab2KLJn6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 04:43:58 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:35023 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab2KLJn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 04:43:56 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20121112072410.GA925@avionic-0098.mockup.avionic-design.de>
References: <1352469579-3337-1-git-send-email-thierry.reding@avionic-design.de>
	<1352469579-3337-3-git-send-email-thierry.reding@avionic-design.de>
	<CACna6rycZ=TGHP7KpVa_r0JSpc6c=PB89pijR9E_4A=bQ=74Bw@mail.gmail.com>
	<509D28B6.3060207@vodafone.de>
	<20121110210118.GA26809@avionic-0098.mockup.avionic-design.de>
	<20121111144644.GK5854@phenom.ffwll.local>
	<20121112072410.GA925@avionic-0098.mockup.avionic-design.de>
Date: Mon, 12 Nov 2012 10:43:54 +0100
X-Google-Sender-Auth: QI2nVwEfM24b8_GPhRfYGACMjD4
Message-ID: <CAKMK7uHLrdJPX-Lq32mBpB2S5SmGw7N57N-Hk+a3aexUE87=wg@mail.gmail.com>
Subject: Re: [PATCH 2/2] drm: tegra: Add HDMI support
From: Daniel Vetter <daniel@ffwll.ch>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: =?ISO-8859-1?Q?Christian_K=F6nig?= <deathsimple@vodafone.de>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 8:24 AM, Thierry Reding
<thierry.reding@avionic-design.de> wrote:
> Actually what I had in mind was a packed binary representation of
> infoframes as specified by HDMI 1.3a (I don't have access to 1.4, but I
> would think it doesn't differ in this respect) in section 5.3 and 5.3.5
> more specifically. According to the specification, the ECC bytes only
> come into play at a later stage, when data is actually transmitted on
> the TMDS link (Section 5.2.3). Tegra, nouveau and radeon also seem to be
> doing the checksumming in hardware, so I guess we don't need to compute
> the ECC bytes in software at all (for now).
>
> Once we have this for the AVI infoframes I guess the same concept can be
> used for audio infoframes and for vendor-specific infoframes (for HDMI
> 1.4 3D).

Iirc there's more than one checksum: The ECC field at byte 3 and the
checksum field at byte 4. All intel hw computes the ECC itself, but
some want us to store the infoframe with an empty ECC byte as
placeholder, whereas others (sdvo encoders) insert that byte
themselves, i.e. the infoframe is actually one byte shorter. In any
case, that kind of mangling can be done in the driver with easy.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
