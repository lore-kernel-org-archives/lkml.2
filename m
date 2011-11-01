Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab1KAPgI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 11:36:08 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34644 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259Ab1KAPgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 11:36:06 -0400
MIME-Version: 1.0
In-Reply-To: <1319824589-18082-1-git-send-email-keithp@keithp.com>
References: <1319824589-18082-1-git-send-email-keithp@keithp.com>
Date: Tue, 1 Nov 2011 15:36:06 +0000
Message-ID: <CAPM=9txN-YspvSERzUDjkwdciB-TwOvgHEXiAnG53PKA1PGfgQ@mail.gmail.com>
Subject: Re: [PATCH] agp: iommu_gfx_mapped only available if
 CONFIG_INTEL_IOMMU is set
From: Dave Airlie <airlied@gmail.com>
To: Keith Packard <keithp@keithp.com>
Cc: Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        Ben Widawsky <ben@bwidawsk.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 6:56 PM, Keith Packard <keithp@keithp.com> wrote:
> Kernels with no iommu support cannot ever need the Ironlake
> work-around, so never enable it in that case.
>
> Might be better to completely remove the work-around from the kernel
> in this case?
>

While I'm not offended by this patch, I am offended by the

extern int intel_iommu_gfx_mapped;

introduced in the previous patches, I dislike having extern
declarations in a C file, a header file is the place for that sort of
thing.

Also have a look around some other places that do CONFIG_ stuff, I
think there may be examples of both in which case this approach is
fine, but I do remember there being a fair few,

#ifdef CONFIG_BLAH
function
#else
#define function do while(0)
#endif

Dave.
