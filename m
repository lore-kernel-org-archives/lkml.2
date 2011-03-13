Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986Ab1CMGar (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 01:30:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56932 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880Ab1CMGap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 01:30:45 -0500
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] genksyms: Track changes to enum constant
Date: Sun, 13 Mar 2011 07:30:18 +0100
Message-Id: <1299997825-18977-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series makes genksyms remember the values of enum constants and use them
during symbol expansion. This makes sure that patches like

| enum e {
|  	E1,
| 	E2,
|+	E3,
| 	E_MAX
| };
|
| struct s {
| 	int a[E_MAX];
| }
|
| int f(struct s *s) { ... }
| EXPORT_SYMBOL(f)

change the checksum of the exported symbol. Previously, it would just use the
string "E_MAX" in the calculation and the change would go unnoticed. The main
part is in patches 6/7 and 7/7, the rest are cleanups and preparatory patches.

Michal
