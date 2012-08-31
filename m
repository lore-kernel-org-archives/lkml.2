Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108Ab2HaVvH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 17:51:07 -0400
Received: from [66.192.166.38] ([66.192.166.38]:44826 "EHLO
	hancock.steeleye.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755060Ab2HaVvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 17:51:05 -0400
Date: Fri, 31 Aug 2012 17:51:03 -0400
From: paul.clements@steeleye.com
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] nbd: fix dangling requests bug
Message-ID: <504131c7.p28zUs/mwtoKlH34%paul.clements@steeleye.com>
User-Agent: nail 11.25 7/29/05
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a serious, but uncommon bug in nbd. This should probably
be considered for backport to one or more stable branches.

The bug occurs when there is heavy I/O going to the nbd device while, at the
same time, a failure (server, network) or manual disconnect of the nbd
connection occurs.

There is a small window between the time that the nbd_thread is stopped and the
socket is shutdown where requests can continue to be queued to nbd's
internal waiting_queue. When this happens, those requests are never completed
or freed.

The fix is to clear the waiting_queue on shutdown of the nbd device, in
the same way that the nbd request queue (queue_head) is already being cleared.

--
Paul
