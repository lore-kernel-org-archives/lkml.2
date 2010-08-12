Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758874Ab0HLHK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 03:10:27 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:57096 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab0HLHKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 03:10:25 -0400
Date: Thu, 12 Aug 2010 09:10:23 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>
Subject: [PATCH 0/2] kconfig: fixes for savedefconfig
Message-ID: <20100812071023.GA11148@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While tranislating all remaining defconfigs in
the kernel to the minimal format I encountered
an issue where the resulting .config was not
equal to the original.

This was tracked down to missing info in the saved defconfig file.

Arve reported another problem with tristate choice that was
reproduceable with a small config sample.

The followng patches fixes both issues.
There is no outstanding issue with respect to savedefconfig.

	Sam

Sam Ravnborg (2):
      kconfig: fix savedefconfig for tristate choices
      kconfig: fix tristate choice with minimal config

 scripts/kconfig/confdata.c |  109 ++++++++++++++++++++++++++++----------------
 1 files changed, 70 insertions(+), 39 deletions(-)
