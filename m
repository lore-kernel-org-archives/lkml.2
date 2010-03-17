Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751203Ab0CQC64 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 22:58:56 -0400
Received: from mail.windriver.com ([147.11.1.11]:47852 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab0CQC6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 22:58:55 -0400
From: Yong Zhang <yong.zhang@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: [PATCH 0/3] ratelimit: patchset focus on return value of __ratelimit()
Date: Wed, 17 Mar 2010 10:58:41 +0800
Message-Id: <1268794724-8665-1-git-send-email-yong.zhang@windriver.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 17 Mar 2010 02:58:46.0271 (UTC) FILETIME=[C2C450F0:01CAC57D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When try to use the new API pr_*_ratelimited(), I got the opposite outcome.
After some checking, I find print_ratelimited() misunderstand the return
value of __ratelimit(). So I fix it in this patchset and also annotate
__ratelimit() for later user.

I mark patch 3 with RFC because I'm afraid I misunderstand the intention,
Ingo, can you please take a look at it? You know that change is introduced
by edaac8e3167501cda336231d00611bf59c164346.

Yong Zhang (3):
      ratelimit: annotate ___ratelimit()
      kernel.h: fix wrong usage of __ratelimit()
      ratelimit: Fix return value when fail to get lock

 include/linux/kernel.h |    2 +-
 lib/ratelimit.c        |   11 ++++++++---
 2 files changed, 9 insertions(+), 4 deletions(-)
