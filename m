Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab2LCJkO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 04:40:14 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:62348 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab2LCJkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 04:40:12 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <50BC7118.9060407@gmail.com>
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
	<1353935954-13763-9-git-send-email-tbergstrom@nvidia.com>
	<CAPM=9tzvt3J6D3zLPV97w629q62CNhAxX8V+_JZ6kmXxxz5fVg@mail.gmail.com>
	<50BC7118.9060407@gmail.com>
Date: Mon, 3 Dec 2012 10:40:10 +0100
X-Google-Sender-Auth: 70Dg8MHmOhjcTr4qRzdvx1NT8po
Message-ID: <CAKMK7uF-sQ-HzA2Zek4VzWky=69LA3JqJR_+kyRQEO-JgwPQXQ@mail.gmail.com>
Subject: Re: [RFC v2 8/8] drm: tegra: Add gr2d device
From: Daniel Vetter <daniel@ffwll.ch>
To: Mark Zhang <nvmarkzhang@gmail.com>
Cc: Dave Airlie <airlied@gmail.com>, Terje Bergstrom <tbergstrom@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 3, 2012 at 10:30 AM, Mark Zhang <nvmarkzhang@gmail.com> wrote:
> I'm new in kernel development. Could you tell me or give me some
> materials to read that why we need to align the size of IOCTL structures
> to 64bit? I can understand if we're working in a 64bit kernel but why we
> need to do this if we're in a 32bit arm kernel? Besides, why the
> pointers in IOCTL structure should be declared as u64?

Because in a few years/months you'll have arm64, but still the same
driver with the same ioctls ... and if the ioctls are not _exactly_
the same you get to write compat ioctl code which copies the old 32bit
struct into the 64bit struct the kernel understands. Hence your ioctl
must be laid out exactly the same for both 32bit and 64bit, which
happens if you naturally align/pad everything to 64bits and only use
fixed-sized integers and no pointers.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
