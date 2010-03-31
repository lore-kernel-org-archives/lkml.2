Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab0CaCmG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 22:42:06 -0400
Received: from ozlabs.org ([203.10.76.45]:38479 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756064Ab0CaCmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 22:42:01 -0400
From: Michael Neuling <mikey@neuling.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
cc: miltonm@bga.com, linux-kernel@vger.kernel.org, ego@in.ibm.com
X-GPG-Fingerprint: 9B25 DC2A C58D 2C8D 47C2  457E 0887 E86F 32E6 BE16
MIME-Version: 1.0
Subject: sched: question on group_capacity when SMT > 2
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Wed, 31 Mar 2010 13:42:00 +1100
Message-ID: <22074.1270003320@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter & Ingo,

At the end of update_sg_lb_stats() we have this calculation:

  sgs->group_capacity =
		DIV_ROUND_CLOSEST(group->cpu_power, SCHED_LOAD_SCALE);

At the sibling level when we have SMT2, cpu_power will be 1178/2
(provided we are not scaling power with freq say) and SCHED_LOAD_SCALE
will be 1024, resulting in group_capacity being 1.

If we have SMT4, cpu_power will be 1178/4, hence group_capacity will end
up as 0.  Shouldn't group capacity always be >= 1?  Do we need to round
this up instead or make sure group_capacity is minimum of 1?  Or do we
need to change the way we calculate cpu_power in the SMT > 2 case? 

A similar problem could occur in SMT2 mode if cpu_power was scaled down
to less than 1024.

(FWIW the undocumented sprinkling of DIV_ROUND_blah in kernel/sched* is
somewhat disconcerting)

Regards,
Mikey
