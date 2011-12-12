Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab1LLUR1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 15:17:27 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45228 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998Ab1LLURV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 15:17:21 -0500
Message-Id: <20111212200642.836001668@openvz.org>
User-Agent: quilt/0.48-1
Date: Tue, 13 Dec 2011 00:06:42 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Kees Cook <keescook@chromium.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [patch 0/3] Patches in a sake of checkpoint/restore, procfs and prctls
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

while /proc/pid/children patch is still under review/rework other
patches were fixed and I hope in good shape. The first one introduces
CONFIG_CHECKPOINT_RESTORE Kconfig symbol which should be a lever to
turn on/off all c/r related features for those who not need it. In
particular new prctl codes are covered by.

Eric pointed that /proc/<pid>/stat enhancement might be a dangerous
one from user-space point of view, so while I've successfuly tested
it, it doesn't mean I've covered every single user-space utility which
might use this file, and if it's still considered to be pretty harmful
change -- I'll hapily move to /proc/pid/statm or whatever. The only
reason it was introduced in "stat" -- we already have mm->start_code
and etc there, so I wanted to have them in one place, not sprinkled
over several files.

Any complains are welcome as usual.

Cyrill
