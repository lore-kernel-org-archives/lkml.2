Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600Ab2HHXDo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 19:03:44 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47485 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758236Ab2HHXDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 19:03:43 -0400
Date: Wed, 08 Aug 2012 16:03:41 -0700 (PDT)
Message-Id: <20120808.160341.846489589039687208.davem@davemloft.net>
To: paolo.valente@unimore.it
Cc: shemminger@vyatta.com, jhs@mojatatu.com, fchecconi@gmail.com,
        rizzo@iet.unipi.it, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] sched: add missing group change to
 qfq_change_class
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120807172724.GA13729@paolo-ThinkPad-W520>
References: <20120807172724.GA13729@paolo-ThinkPad-W520>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paolo Valente <paolo.valente@unimore.it>
Date: Tue, 7 Aug 2012 19:27:25 +0200

> [Resending again, as the text was corrupted by the email client]
> 
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
> packet delay related to its old group, instead of the guarantees that
> it should receive according to its new weight and/or maximum packet
> length. This may also break service guarantees for other classes.
> This patch adds the missing operations.
> 
> Signed-off-by: Paolo Valente <paolo.valente@unimore.it>

Applied, thanks.
