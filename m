Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634Ab2KTGT1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 01:19:27 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:52054 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab2KTGT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 01:19:26 -0500
MIME-Version: 1.0
In-Reply-To: <1352201511-6383-4-git-send-email-thellstrom@vmware.com>
References: <1352201511-6383-1-git-send-email-thellstrom@vmware.com>
	<1352201511-6383-4-git-send-email-thellstrom@vmware.com>
Date: Tue, 20 Nov 2012 16:19:25 +1000
Message-ID: <CAPM=9txb2aQ6zXYKdxDiuL0jOBA9epM_kBT8zeOOcUDN42gQ_w@mail.gmail.com>
Subject: Re: [PATCH 3/4] drm/ttm, drm/vmwgfx: Use RCU locking for object
 lookups v3
From: Dave Airlie <airlied@gmail.com>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: airlied@redhat.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 6, 2012 at 9:31 PM, Thomas Hellstrom <thellstrom@vmware.com> wrote:
> The mostly used lookup+get put+potential_destroy path of TTM objects
> is converted to use RCU locks. This will substantially decrease the amount
> of locked bus cycles during normal operation.
> Since we use kfree_rcu to free the objects, no rcu synchronization is needed
> at module unload time.

As this is the first use of RCU in a drm driver from what I can see,
let me remind that the
RCU patent agreement AFAIK only covers GPL works.

So non-GPL or other OSes porting this code should take not of this.

Dave.
