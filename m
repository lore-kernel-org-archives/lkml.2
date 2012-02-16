Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab2BPEYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 23:24:12 -0500
Received: from ozlabs.org ([203.10.76.45]:41376 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752810Ab2BPEYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 23:24:11 -0500
From: David Gibson <david@gibson.dropbear.id.au>
To: akpm@linux-foundation.org, abarry@cray.com
Cc: hughd@google.com, mgorman@suse.de, minchan.kim@gmail.com, paulus@samba.org,
        linux-kernel@vger.kernel.org
Subject: Hugepage cleanup and bugfix
Date: Thu, 16 Feb 2012 15:23:58 +1100
Message-Id: <1329366240-11663-1-git-send-email-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, this is a revised version of Andrew Barry's fix for the hugepage
race between unmount and quota update.  In fact it's not just that
race which is a problem, it's a more general use-after-free problem on
fs inodes from the hugepage code.

Despite all the abstract talk in the patch comments about layering
violations, this fixes a real, exploitable, crash bug which has been
in the kernel for a very long time now.

Andrew, please apply.

