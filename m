Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab1K2SCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 13:02:13 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:57333 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754941Ab1K2SCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 13:02:10 -0500
Date: Tue, 29 Nov 2011 20:02:03 +0200 (EET)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] slab fixes for 3.2-rc4
Message-ID: <alpine.LFD.2.02.1111292001420.4019@tux.localdomain>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's few important fixes to SLUB issues introduced in the merge window.

The most important ones are from Christoph Lameter and Eric Dumazet that fix
stability issues on non-x86 architectures. The patches from Shaohua Li fix a
performance regression in SLUB that was also introduced in the merge window.

 			Pekka

The following changes since commit 883381d9f1c5a6329bbb796e23ae52c939940310:

   Merge branch 'dev' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4 (2011-11-29 08:59:12 -0800)

are available in the git repository at:

   git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git slab/urgent

Christoph Lameter (1):
       slub: use irqsafe_cpu_cmpxchg for put_cpu_partial

Eric Dumazet (1):
       slub: avoid potential NULL dereference or corruption

Shaohua Li (2):
       slub: use correct parameter to add a page to partial list tail
       slub: move discard_slab out of node lock

  mm/slub.c |   42 ++++++++++++++++++++++++++----------------
  1 files changed, 26 insertions(+), 16 deletions(-)
