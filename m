Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab2AHWBv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 17:01:51 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62113 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650Ab2AHWBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 17:01:50 -0500
MIME-Version: 1.0
Date: Mon, 9 Jan 2012 09:01:48 +1100
X-Google-Sender-Auth: BCBBkCvUeu9yewtAIywuTQJ-EIA
Message-ID: <CABqErrHxt_315Fv3jpqZRjNWtwAUb=USv_DGSmingUO90i3LSA@mail.gmail.com>
Subject: BFS v0.416 CPU scheduler for 3.2
From: Con Kolivas <kernel@kolivas.org>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is to announce a resync of the BFS CPU scheduler for the current
mainline linux kernel version 3.2:

http://ck.kolivas.org/patches/bfs/3.2.0/3.2-sched-bfs-416.patch

Most of the changes since the last version are trivial only.


Of related interest is an excellent thesis by Joseph T. Meehean
entitled "Towards Transparent CPU Scheduling". Of particular note is
the virtually deterministic nature of BFS, especially in fairness and
latency. While this of course interests me greatly because of
extensive testing of the BFS CPU scheduler, there are many aspects of
both the current CFS CPU scheduler and the older O(1) CPU scheduler
that are discussed that anyone working on issues to do with
predictability, scalability, fairness and latency should read.

http://research.cs.wisc.edu/wind/Publications/meehean-thesis11.html

---
Abstract:

In this thesis we propose using the scientific method to develop a
deeper understanding of CPU schedulers; we use this approach to
explain and understand the sometimes erratic behavior of CPU
schedulers. This approach begins with introducing controlled workloads
into commodity operating systems and observing the CPU scheduler's
behavior. From these observations we are able to infer the underlying
CPU scheduling policy and create models that predict scheduling
behavior.

We have made two advances in the area of applying scientific analysis
to CPU schedulers. The first, CPU Futures, is a combination of
predictive scheduling models embedded into the CPU scheduler and
user-space controller that steers applications using feedback from
these models. We have developed these predictive models for two
different Linux schedulers (CFS and O(1)), based on two different
scheduling paradigms (timesharing and proportional-share). Using three
different case studies, we demonstrate that applications can use our
predictive models to reduce interference from low-importance
applications by over 70%, reduce web server starvation by an order of
magnitude, and enforce scheduling policies that contradict the CPU
scheduler's.

Harmony, our second contribution, is a framework and set of
experiments for extracting multiprocessor scheduling policy from
commodity operating systems. We used this tool to extract and analyze
the policies of three Linux schedulers: O(1), CFS, and BFS. These
schedulers often implement strikingly different policies. At the high
level, the O(1) scheduler carefully selects processes for migration
and strongly values processor affinity. In contrast, CFS continuously
searches for a better balance and, as a result, selects processes for
migration at random. BFS strongly values fairness and often disregards
processor affinity.

---

-ck
