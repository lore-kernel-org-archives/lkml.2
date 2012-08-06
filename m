Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab2HFUbH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 16:31:07 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38950 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756141Ab2HFUbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 16:31:04 -0400
Date: Mon, 06 Aug 2012 13:31:03 -0700 (PDT)
Message-Id: <20120806.133103.173950447984896787.davem@davemloft.net>
To: paolo.valente@unimore.it
Cc: shemminger@vyatta.com, jhs@mojatatu.com, fchecconi@gmail.com,
        rizzo@iet.unipi.it, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Subject: [PATCH] sched: add missing group change to
 qfq_change_class
From: David Miller <davem@davemloft.net>
In-Reply-To: <501ECD61.5090209@unimore.it>
References: <501ECD61.5090209@unimore.it>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paolo Valente <paolo.valente@unimore.it>
Date: Sun, 05 Aug 2012 21:45:37 +0200

> To speed up operations, QFQ internally divides classes into
> groups. Which group a class belongs to depends on the ratio between
> the maximum packet length and the weight of the class. Unfortunately
> the function qfq_change_class lacks the steps for changing the group
> of a class when the ratio max_pkt_len/weight of the class changes.
> 
> For example, when the last of the following three commands is
> executed, the group of class 1:1 is not correctly changed:
> 
> tc disc add dev XXX root handle 1: qfq
> tc class add dev XXX parent 1: qfq classid 1:1 weight 1
> tc class change dev XXX parent 1: classid 1:1 qfq weight 4
> 
> Not changing the group of a class does not affect the long-term
> bandwidth guaranteed to the class, as the latter is independent of the
> maximum packet length, and correctly changes (only) if the weight of
> the class changes. In contrast, if the group of the class is not
> updated, the class is still guaranteed the short-term bandwidth and
> packet delay related to its old group, and not the guarantees that it
> should receive according to its new weight and/or maximum packet
> length. This may also break service guarantees for other classes.
> This patch adds the missing operations.
> 
> Signed-off-by: Paolo Valente <paolo.valente@unimore.it>

Please provide clean Subject lines with patch submissions.

Also, this patch doesn't apply cleanly at all.  Email the patch
to yourself, and verify that you can in fact apply it to the
current networking GIT tree just as I will have to.
