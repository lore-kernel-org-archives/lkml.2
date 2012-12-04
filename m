Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730Ab2LDBtw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 20:49:52 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40817 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab2LDBtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 20:49:51 -0500
Message-ID: <50BD56B5.701@gmail.com>
Date: Tue, 04 Dec 2012 09:49:41 +0800
From: Mark Zhang <nvmarkzhang@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Daniel Vetter <daniel@ffwll.ch>
CC: Dave Airlie <airlied@gmail.com>, Terje Bergstrom <tbergstrom@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: Re: [RFC v2 8/8] drm: tegra: Add gr2d device
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com> <1353935954-13763-9-git-send-email-tbergstrom@nvidia.com> <CAPM=9tzvt3J6D3zLPV97w629q62CNhAxX8V+_JZ6kmXxxz5fVg@mail.gmail.com> <50BC7118.9060407@gmail.com> <CAKMK7uF-sQ-HzA2Zek4VzWky=69LA3JqJR_+kyRQEO-JgwPQXQ@mail.gmail.com>
In-Reply-To: <CAKMK7uF-sQ-HzA2Zek4VzWky=69LA3JqJR_+kyRQEO-JgwPQXQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2012 05:40 PM, Daniel Vetter wrote:
> On Mon, Dec 3, 2012 at 10:30 AM, Mark Zhang <nvmarkzhang@gmail.com> wrote:
>> I'm new in kernel development. Could you tell me or give me some
>> materials to read that why we need to align the size of IOCTL structures
>> to 64bit? I can understand if we're working in a 64bit kernel but why we
>> need to do this if we're in a 32bit arm kernel? Besides, why the
>> pointers in IOCTL structure should be declared as u64?
> 
> Because in a few years/months you'll have arm64, but still the same
> driver with the same ioctls ... and if the ioctls are not _exactly_
> the same you get to write compat ioctl code which copies the old 32bit
> struct into the 64bit struct the kernel understands. Hence your ioctl
> must be laid out exactly the same for both 32bit and 64bit, which
> happens if you naturally align/pad everything to 64bits and only use
> fixed-sized integers and no pointers.

Ah, I see. Thanks. Yes, u64 still works as 32 bit pointer.

Mark
> -Daniel
> 
