Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889Ab1AMOEB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 09:04:01 -0500
Received: from mtoichi12.ns.itscom.net ([219.110.2.182]:54430 "EHLO
	mtoichi12.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756804Ab1AMOEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 09:04:00 -0500
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: Nick Piggin <npiggin@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: vfs-scale, d_revalidate from nfsd
Date: Thu, 13 Jan 2011 23:03:56 +0900
Message-ID: <8855.1294927436@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


NFSD calls filesystem's ->d_revalidate() with the parameter nd == NULL.
So every
	if (nd->flags & LOOKUP_RCU)
		return -ECHILD;
code which was added to ->d_revalidate() of FS which supports NFS
exporting will crash.

If we rewrite it as
	if (nd && (nd->flags & LOOKUP_RCU))
		return -ECHILD;
the problem may not occur.
But I am not sure whether lookup_one_len() call in NFSD support rcu-walk.


J. R. Okajima
