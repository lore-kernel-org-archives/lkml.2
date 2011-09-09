Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758497Ab1IIGWf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 02:22:35 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38536 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758485Ab1IIGWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 02:22:33 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 0/2] Fixes and cleanups in PTRACE_SETOPTIONS
Date: Fri, 9 Sep 2011 08:22:30 +0200
User-Agent: KMail/1.8.2
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        dvlasenk@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201109090822.30063.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset has two changes.

First patch makes ptrace(PTRACE_SETOPTIONS, pid, 0, <bogus value>)
to error out *without* changing any task->ptrace bits.

Second patch is a cleanup: PTRACE_SETOPTIONS code
clears all option bits in task->ptrace, then sets bits one-by-one.
This is butt-ugly.

-- 
vda
