Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab0FLJuk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 05:50:40 -0400
Received: from verein.lst.de ([213.95.11.210]:34153 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752321Ab0FLJui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 05:50:38 -0400
Date: Sat, 12 Jun 2010 11:49:37 +0200
From: Christoph Hellwig <hch@lst.de>
To: Takeo Tung <kernel@takeo.idv.tw>
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk, sfr@canb.auug.org.au
Subject: Re: linux-next-20100608 will /bin/sh: scripts/basic/fixdep: Permission denied
Message-ID: <20100612094937.GA12455@lst.de>
References: <10E8B8D94205471F942B06D2A007832D@TAKEOW7NB1> <4C129778.7040409@suse.cz> <F8C0125B8F424A279E9679EAC24AC983@TAKEOW7NB1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F8C0125B8F424A279E9679EAC24AC983@TAKEOW7NB1>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please try the patch below, looks like I did a horrible messup in the
last version of the patch:


Index: linux-2.6/fs/attr.c
===================================================================
--- linux-2.6.orig/fs/attr.c	2010-06-12 11:45:50.458003839 +0200
+++ linux-2.6/fs/attr.c	2010-06-12 11:45:59.103005305 +0200
@@ -34,7 +34,7 @@ int inode_change_ok(const struct inode *
 	 * First check size constraints.  These can't be overriden using
 	 * ATTR_FORCE.
 	 */
-	if (attr->ia_mode & ATTR_SIZE) {
+	if (ia_valid & ATTR_SIZE) {
 		int error = inode_newsize_ok(inode, attr->ia_size);
 		if (error)
 			return error;
