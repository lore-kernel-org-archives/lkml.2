Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761694Ab2COLo3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 07:44:29 -0400
Received: from www.linutronix.de ([62.245.132.108]:39735 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685Ab2COLoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 07:44:24 -0400
Message-Id: <20120314170736.617746873@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 15 Mar 2012 11:44:22 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@osdl.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Nick Piggin <npiggin@kernel.dk>
Subject: [patch 0/5] seqlock consolidation
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series consists of two parts:

     1) Consolidate seqlocks and seqcount instead of having two
     	implementations for the counter functionality

     2) Extend seqlocks API and convert the open coded seqlocks
     	in fs_struct and dentry to that.

The main motivation of this change is to get rid of open coded
seqlocks as they are difficult to handle in the real time patch,
because the retry loops can cause live locks there, when the writer
side gets preempted. RT needs to take the lock so the writer gets
boosted and out of the way. With open coded seqlocks consisting of a
spinlock and a seqcount we have no idea which lock to acquire.

Aside of that replacing open coded constructs with proper functions is
a worthwhile cleanup by itself.

Thanks,

	tglx

