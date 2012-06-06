Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759212Ab2FFW7h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 18:59:37 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:38797 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923Ab2FFW7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 18:59:36 -0400
MIME-Version: 1.0
X-Originating-IP: [197.179.0.64]
In-Reply-To: <CAHVUoiQywo=iHKsXQbsVE7coc1FL9A9qy_a71SK94MKNV0GrKA@mail.gmail.com>
References: <CAHVUoiQywo=iHKsXQbsVE7coc1FL9A9qy_a71SK94MKNV0GrKA@mail.gmail.com>
From: Brian Gitonga Marete <marete@toshnix.com>
Date: Thu, 7 Jun 2012 01:59:15 +0300
Message-ID: <CAHVUoiTZmzT3vquaDC65AJfCFZX-qS5GjgjP2-+=0R7skurW5g@mail.gmail.com>
Subject: Re: [Regression] [Radeon] Stream command failures and render problems
 in Evergreen (Radeon HD 5600) in kernel 3.4
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <jglisse@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 3, 2012 at 8:26 PM, Brian Gitonga Marete <marete@toshnix.com> wrote:
> Hello,
>
> 3.4 breaks rendering on my Radeon evergreen card. Immediately after
> logging in into the desktop, I get the following errors in the kernel
> log:
>
> radeon 0000:01:00.0: evergreen_cs_track_validate_cb:439 cb[0] bo too
> small (layer size 147456, offset 0, max layer 1, bo size 143360, slice
> 575)
> radeon 0000:01:00.0: evergreen_cs_track_validate_cb:443 problematic
> surf: (192 192) (0 4 1 0 0 0 0)
> radeon 0000:01:00.0: evergreen_packet3_check:2055 invalid cmd stream 461
> [drm:radeon_cs_ib_chunk] *ERROR* Invalid command stream !
> radeon 0000:01:00.0: evergreen_cs_track_validate_cb:439 cb[0] bo too
> small (layer size 147456, offset 0, max layer 1, bo size 143360, slice
> 575)
> radeon 0000:01:00.0: evergreen_cs_track_validate_cb:443 problematic
> surf: (192 192) (0 4 1 0 0 0 0)
> radeon 0000:01:00.0: evergreen_packet3_check:2055 invalid cmd stream 461
> [drm:radeon_cs_ib_chunk] *ERROR* Invalid command stream !
> radeon 0000:01:00.0: evergreen_cs_track_validate_cb:439 cb[0] bo too
> small (layer size 798720, offset 0, max layer 1, bo size 794624, slice
> 3119)
> radeon 0000:01:00.0: evergreen_cs_track_validate_cb:443 problematic
> surf: (384 520) (0 4 1 0 0 0 0)
> radeon 0000:01:00.0: evergreen_packet3_check:2055 invalid cmd stream 461
> [drm:radeon_cs_ib_chunk] *ERROR* Invalid command stream !
> radeon 0000:01:00.0: evergreen_cs_track_validate_cb:439 cb[0] bo too
> small (layer size 458752, offset 0, max layer 1, bo size 446464, slice
> 1791)
> radeon 0000:01:00.0: evergreen_cs_track_validate_cb:443 problematic
> surf: (512 224) (0 4 1 0 0 0 0)
> radeon 0000:01:00.0: evergreen_packet3_check:2055 invalid cmd stream 7170
> [drm:radeon_cs_ib_chunk] *ERROR* Invalid command stream !
> radeon 0000:01:00.0: evergreen_cs_track_validate_cb:439 cb[0] bo too
> small (layer size 798720, offset 0, max layer 1, bo size 790528, slice
> 3119)
> radeon 0000:01:00.0: evergreen_cs_track_validate_cb:443 problematic
> surf: (384 520) (0 4 1 0 0 0 0)
> radeon 0000:01:00.0: evergreen_packet3_check:2055 invalid cmd stream 461
> [drm:radeon_cs_ib_chunk] *ERROR* Invalid command stream !
>
> Meanwhile, windows on the desktop are rendered incorrectly (with
> certain regions covered by strange patterns or smudged) or not at all.
> This makes the desktop unusable.
>
> I can always reproduce this problem on 3.4
>
> Kernels prior to 3.4 work fine.
>
> I will try and find the time to bisect this issue but meanwhile here
> are some further details:
>

I have git-bisected this to find that the first bad commit is:
285484e2d55 - drm/radeon: add support for evergreen/ni tiling
informations v11.

So I have also added Jerome to the CC list. Please see the attached
bisect.log for the git-bisect log.

Once again, my card is:

01:00.0 VGA compatible controller: ATI Technologies Inc Redwood
[Radeon HD 5600 Series] (prog-if 00 [VGA controller])
        Subsystem: Dell Device 0447
        Flags: bus master, fast devsel, latency 0, IRQ 47
        Memory at c0000000 (64-bit, prefetchable) [size=256M]
        Memory at fbe20000 (64-bit, non-prefetchable) [size=128K]
        I/O ports at e000 [size=256]
        Expansion ROM at fbe00000 [disabled] [size=128K]
        Capabilities: <access denied>
        Kernel driver in use: radeon
        Kernel modules: radeon

To reproduce, simply:

1. Install Ubuntu 11.04 on a system with the above Radeon card (In
order to get the version of Xorg and DRM libs that I have)
2. Boot and login.

The problem manifests upon login, presumably on that start of Compiz
but I am not sure.

-- 
Brian Gitonga Marete
Toshnix Systems - http://toshnix.com
