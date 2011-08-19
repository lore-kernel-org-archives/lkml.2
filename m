Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749Ab1HSVa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 17:30:26 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:11568 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab1HSVaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 17:30:24 -0400
Date: Fri, 19 Aug 2011 23:30:57 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: linux-ntfs-dev@lists.sourceforge.net,
        Anton Altaparmakov <anton@tuxera.com>
Subject: [PATCH 0/3] make ntfs_free() NULL safe
Message-ID: <alpine.LNX.2.00.1108192321130.31857@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Here's a small series of patches that make it safe to call ntfs_free() 
with a NULL pointer and reaps some bennefits from that.

The first patch in the series simply makes ntfs_free() safe to call with a 
NULL pointer. This fits with many other kernel freeing functions, that are 
generally safe to call with NULL pointers.

The second patch adds some documentation to ntfs_free() similar to what's 
already provided for the allocation functions.  ntfs_free() is fairly 
simple so you could argue that such documentation is not really needed, 
but I say it's still nice to have if for no other reason than 
completeness.

The third patch removes a number of tests for NULL pointers before calls 
to ntfs_free() that patch 1 make redundant.

This whole things came about because Coverity Prevent spotted that in 
fs/ntfs/runlist.c on line 967 we call ntfs_runlists_merge() which frees 
its second argument and we then explicitly free that argument via 
ntfs_free() again on line 970. This patch series also makes that a non 
issue.


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

