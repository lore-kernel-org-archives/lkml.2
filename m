Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab1KUDJj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 22:09:39 -0500
Received: from 184-106-247-128.static.cloud-ips.com ([184.106.247.128]:51298
	"EHLO cloud01.chad-versace.us" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751294Ab1KUDJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 22:09:36 -0500
X-Spam-Flag: NO
X-Spam-Score: -1
Date: Sun, 20 Nov 2011 19:09:18 -0800
From: Ben Widawsky <ben@bwidawsk.net>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: intel-gfx <intel-gfx@lists.freedesktop.org>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 01/13] drm/i915: fall through
 pwrite_gtt_slow to the shmem slow path
Message-ID: <20111120190918.2b138476@bwidawsk.net>
In-Reply-To: <1320606840-21132-2-git-send-email-daniel.vetter@ffwll.ch>
References: <1320606840-21132-1-git-send-email-daniel.vetter@ffwll.ch>
	<1320606840-21132-2-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  6 Nov 2011 20:13:48 +0100
Daniel Vetter <daniel.vetter@ffwll.ch> wrote:

> The gtt_pwrite slowpath grabs the userspace memory with
> get_user_pages. This will not work for non-page backed memory, like a
> gtt mmapped gem object. Hence fall throuh to the shmem paths if we hit
> -EFAULT in the gtt paths.
> 
> Now the shmem paths have exactly the same problem, but this way we
> only need to rearrange the code in one write path.
> 
> v2: v1 accidentaly falls back to shmem pwrite for phys objects. Fixed.
> 
> Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>

It would be nice if there was some way to notify users that pwriting a
gtt mmapped address can be really damn slow. That's also the one
behavior change this patch introduces. It's possible that some SW was
expecting to get a, "fast path" and would deal with the -EFAULT if it
didn't get it.

Presumably subsequent patches in this series fix this up further, so
instead of figuring out all the failure conditions pwrite can cause,
let's just go with
Acked-by: Ben Widawsky <ben@bwidawsk.net>
