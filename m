Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab0HRBNx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 21:13:53 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:53717 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab0HRBNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 21:13:48 -0400
Message-Id: <201008180113.o7I1DXg6077317@www262.sakura.ne.jp>
Subject: Re: [2.6.36-rc1] List corruption when using initrd.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: hughd@google.com
Cc: tim.c.chen@linux.intel.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Wed, 18 Aug 2010 10:13:33 +0900
References: <201008170517.o7H5HbCT002910@www262.sakura.ne.jp> <201008170751.o7H7pmAl038739@www262.sakura.ne.jp> <alpine.LSU.2.00.1008171523270.2106@sister.anvils>
In-Reply-To: <alpine.LSU.2.00.1008171523270.2106@sister.anvils>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 17082010 #3880867, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> Thanks for reporting and bisecting.  Certainly there's a bug in shmem
> (that we ought to have caught long before it reached 36-rc1: sorry),
> and it is probably the cause of your crashes; but it's possible there's
> a similar bug elsewhere too, something else messing up the percpu_counters
> list - so please check if the patch below really does fix it for you.

This patch solved the list_add() corruption messages and
"[2.6.36-rc1] Bugs in __free_pipe_info()".

> I notice your dmesg also showed fs/inode.c:692 unlock_new_inode()
> warnings from get_cramfs_inode(): those would be unrelated, and
> probably from Al Viro's recent changes in cramfs/inode.c - Cc'ed.
unlock_new_inode() warnings remain after applying this patch.

Thank you.
