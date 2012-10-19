Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758755Ab2JSXGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 19:06:39 -0400
Received: from mail-wi0-f194.google.com ([209.85.212.194]:59013 "EHLO
	mail-wi0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755395Ab2JSXGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 19:06:36 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3 v3] kconfig: get the CONFIG_ prefix from the environment
Date: Sat, 20 Oct 2012 01:06:22 +0200
Message-Id: <1350687985-21053-1-git-send-email-yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All!

This little patch series allows one to override the CONFIG_ prefix at 
runtime, without the need to rebuild the frontends.

This will be useful to have, to share the same kconfig frontends between
different projects that may use different prefix. For example:
  - busybox and uClibc use the standard 'CONFIG_'
  - crosstool-NG uses 'CT_'
  - PTXdist uses 'PTXCONF_'
  - buildroot does not use a prefix at all
  - and so on...

    [PATCH 1/3] kconfig: remove CONFIG_ from string constants
    [PATCH 2/3] kconfig: add a function to get the CONFIG_ prefix
    [PATCH 3/3] kconfig: get CONFIG_ prefix from environment

This is part of my efforts to get a generic package that encapsulates the
kconfig frontends and parser into a standalone package, to make it easy
for third-party projects to easily sync (and ultimately share) their
kconfig infrastructure:
    kconfig-frontends
    http://ymorin.is-a-geek.org/projects/kconfig-frontends

Changes in v3:
  - simplify the CONFIG_prefix() function (Michal)
  - rebase on-top master to date
Changes in v2:
  - call getenv() only once
  - don't touch code when not strictly neeeded (don't fold not-so-long lines)
  - rebase on-top 3.7-rc1

Regards,
Yann E. MORIN.

