Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab1I0XGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 19:06:44 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45493 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab1I0XGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 19:06:43 -0400
MIME-Version: 1.0
Date: Wed, 28 Sep 2011 01:06:42 +0200
Message-ID: <CAOVSwNFp=p3TmkfvB=BKq8b_jJVTywRspJSE3fhyKQaCfnzUvg@mail.gmail.com>
Subject: [Priority Inheritance] SCHED_FIFO or SCHED_RR?
From: "Tadeus (Eus) Prastowo" <0x657573@googlemail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

When a SCHED_RR task with RT priority X blocks on a
priority-inheriting mutex held by a SCHED_NORMAL task with nice value
Y, RT-Mutex code will change the SCHED_NORMAL task priority to that of
the SCHED_RR task and based on the new priority, will change the
scheduling class too. But, each task retains its own scheduling
policy.

This means that the task inheriting the SCHED_RR priority will be
scheduled using SCHED_FIFO policy because task_tick_rt does not
enforce the SCHED_RR time slice when the task policy is not SCHED_RR.

Why should a SCHED_NORMAL task inheriting the priority of a SCHED_RR
task get the privilege of SCHED_FIFO task for running as long as it
wishes even when the task giving the inheritance does not have such
privilege?

Thank you very much.

Please kindly put me in the CC since I am not subscribed to the list.

--
Eus
