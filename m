Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab0C1LZd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 07:25:33 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:48365 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab0C1LZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 07:25:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=K62xfTV8su6loCGF1AqExYquMcNO3GBod+OG6nCmqFIZNRJKZldr+Y1FwygnPTCXwN
         zqnS8T5/KbcV8PeEwAgRzXY1v0SxLUI1Ms3tTNqA75cSjLFwbVSvbtMtJzM08zOhHJwu
         GDrYDZk2SKVEDMK/f4XbKIREK87P0ozlmHVTg=
Date: Sun, 28 Mar 2010 14:25:22 +0300
From: Dan Carpenter <error27@gmail.com>
To: David Airlie <airlied@linux.ie>
Cc: Eric Anholt <eric@anholt.net>, Dave Airlie <airlied@redhat.com>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch] drm: fix check for end of loop
Message-ID: <20100328112522.GL5069@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	David Airlie <airlied@linux.ie>, Eric Anholt <eric@anholt.net>,
	Dave Airlie <airlied@redhat.com>, dri-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"agpmem" is never NULL here.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/gpu/drm/drm_memory.c b/drivers/gpu/drm/drm_memory.c
index e4865f9..7732268 100644
--- a/drivers/gpu/drm/drm_memory.c
+++ b/drivers/gpu/drm/drm_memory.c
@@ -77,7 +77,7 @@ static void *agp_remap(unsigned long offset, unsigned long size,
 		    && (agpmem->bound + (agpmem->pages << PAGE_SHIFT)) >=
 		    (offset + size))
 			break;
-	if (!agpmem)
+	if (&agpmem->head == &dev->agp->memory)
 		return NULL;
 
 	/*
