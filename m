Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab2EHGxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 02:53:38 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64708 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862Ab2EHGxh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 02:53:37 -0400
MIME-Version: 1.0
In-Reply-To: <1336432421-17972-1-git-send-email-marcheu@chromium.org>
References: <1336432421-17972-1-git-send-email-marcheu@chromium.org>
Date: Tue, 8 May 2012 07:53:36 +0100
Message-ID: <CAPM=9txbqEsejvtQJ9XfRcuU-vwJUkASTW6cxEhbwf0tUTSTow@mail.gmail.com>
Subject: Re: [PATCH] mm: Work around Intel SNB GTT bug with some physical pages.
From: Dave Airlie <airlied@gmail.com>
To: =?ISO-8859-1?Q?St=E9phane_Marchesin?= <marcheu@chromium.org>
Cc: linux-kernel@vger.kernel.org, keithp@keithp.com,
        torvalds@linux-foundation.org, seanpaul@chromium.org,
        olofj@chromium.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 8, 2012 at 12:13 AM, Stéphane Marchesin
<marcheu@chromium.org> wrote:
> While investing some Sandy Bridge rendering corruption, I found out
> that all physical memory pages below 1MiB were returning garbage when
> read through the GTT. This has been causing graphics corruption (when
> it's used for textures, render targets and pixmaps) and GPU hangups
> (when it's used for GPU batch buffers).
>
> I talked with some people at Intel and they confirmed my findings,
> and said that a couple of other random pages were also affected.
>
> We could fix this problem by adding an e820 region preventing the
> memory below 1 MiB to be used, but that prevents at least my machine
> from booting. One could think that we should be able to fix it in
> i915, but since the allocation is done by the backing shmem this is
> not possible.
>
> In the end, I came up with the ugly workaround of just leaking the
> offending pages in shmem.c. I do realize it's truly ugly, but I'm
> looking for a fix to the existing code, and am wondering if people on
> this list have a better idea, short of rewriting i915_gem.c to
> allocate its own pages directly.

Ouch, can Intel get some details on why these pages are "special" and
if they are special across chipsets, Ironlake? Ivybridge?

Like I can handle the < 1MB but the other selected pages look pretty
random or misc, (2005, 2011, 2013? years?, 40004000, some shout out to
the 4004?

Dave.
