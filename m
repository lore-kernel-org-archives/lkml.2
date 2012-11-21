Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743Ab2KUTMv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 14:12:51 -0500
Received: from gmmr5.centrum.cz ([46.255.225.250]:59156 "EHLO gmmr5.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755720Ab2KUTMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 14:12:50 -0500
X-Greylist: delayed 640 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Nov 2012 14:12:50 EST
To: <linux-kernel@vger.kernel.org>
Subject: =?utf-8?q?memory=2Dcgroup_bug?=
Date: Wed, 21 Nov 2012 20:02:07 +0100
From: "azurIt" <azurit@pobox.sk>
X-Mailer: Centrum Email 5.3
X-Priority: 3
X-Original-From: azurit@pobox.sk
MIME-Version: 1.0
Message-Id: <20121121200207.01068046@pobox.sk>
X-Maser: oho
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

i'm using memory cgroup for limiting our users and having a really strange problem when a cgroup gets out of its memory limit. It's very strange because it happens only sometimes (about once per week on random user), out of memory is usually handled ok. This happens when problem occures:
 - no new processes can be started for this cgroup
 - current processes are freezed and taking 100% of CPU
 - when i try to 'strace' any of current processes, the whole strace freezes until process is killed (strace cannot be terminated by CTRL-c)
 - problem can be resolved by raising memory limit for cgroup or killing of few processes inside cgroup so some memory is freed

I also garbbed the content of /proc/<pid>/stack of freezed process:
[<ffffffff8110a9c1>] mem_cgroup_handle_oom+0x241/0x3b0
[<ffffffff8110b5ab>] T.1146+0x5ab/0x5c0
[<ffffffff8110ba56>] mem_cgroup_charge_common+0x56/0xa0
[<ffffffff8110bae5>] mem_cgroup_newpage_charge+0x45/0x50
[<ffffffff810ec54e>] do_wp_page+0x14e/0x800
[<ffffffff810eda34>] handle_pte_fault+0x264/0x940
[<ffffffff810ee248>] handle_mm_fault+0x138/0x260
[<ffffffff810270ed>] do_page_fault+0x13d/0x460
[<ffffffff815b53ff>] page_fault+0x1f/0x30
[<ffffffffffffffff>] 0xffffffffffffffff

I'm currently using kernel 3.2.34 but i'm having this problem since 2.6.32.

Any ideas? Thnx.

azurIt
