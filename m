Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab2KPRDz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 12:03:55 -0500
Received: from mail-ea0-f202.google.com ([209.85.215.202]:45613 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab2KPRDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 12:03:54 -0500
From: Greg Thelen <gthelen@google.com>
To: glommer@parallels.com
Subject: kmem accounting netperf data
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Fri, 16 Nov 2012 09:03:52 -0800
Message-ID: <xr937gplwkcn.fsf@gthelen.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We ran some netperf comparisons measuring the overhead of enabling
CONFIG_MEMCG_KMEM with a kmem limit.  Short answer: no regression seen.

This is a multiple machine (client,server) netperf test.  Both client
and server machines were running the same kernel with the same
configuration.

A baseline run (with CONFIG_MEMCG_KMEM unset) was compared with a full
featured run (CONFIG_MEMCG_KMEM=y and a kmem limit large enough not to
put additional pressure on the workload).  We saw no noticeable
regression running:
- TCP_CRR efficiency, latency
- TCP_RR latency, rate
- TCP_STREAM efficiency, throughput
- UDP_RR efficiency, latency
The tests were run with a varying number of concurrent connections
(between 1 and 200).

The source came from one of Glauber's branches
(git://git.kernel.org/pub/scm/linux/kernel/git/glommer/memcg
kmemcg-slab):
  commit 70506dcf756aaafd92f4a34752d6b8d8ff4ed360
  Author: Glauber Costa <glommer@parallels.com>
  Date:   Thu Aug 16 17:16:21 2012 +0400

      Add slab-specific documentation about the kmem controller

It's not the latest source, but I figured the data might still be
useful.
