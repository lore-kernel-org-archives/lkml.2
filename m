Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602Ab1BGSbm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 13:31:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25620 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754463Ab1BGSbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 13:31:40 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: alan@lxorguk.ukuu.org.uk, gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] tty,vcs: vcs_seek fix + removing con_buf_mtx
Date: Mon,  7 Feb 2011 19:31:23 +0100
Message-Id: <1297103485-8319-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

the vcs lseek method might race with VC removal and cause panic.

Also it seems the vcs is the only one using con_buf and con_buf_mtx,
which does not seem necessary any longer.

attached patches:
1/2 - lseek/VC-release race fix
2/2 - removing con_buf and con_buf_mtx

wbr,
jirka
---
 drivers/tty/vt/vc_screen.c |  110 +++++++++++++++++++++++++++-----------------
 drivers/tty/vt/vt.c        |   12 -----
 include/linux/vt_kern.h    |    8 ---
 3 files changed, 67 insertions(+), 63 deletions(-)
