Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485Ab1AFUpb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 15:45:31 -0500
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:47203 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753209Ab1AFUp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 15:45:27 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: JESTZy0VM1mJZtWZ6bV6fkOZUZdIgVpPiLz7M05QMffOPB0
 KLPhAx4ObSjEa0zCni9hqcuzYMUCy.6F_qSInk7eEdzFhBZmL7VvBvJ80.lQ
 xVFvMt3wp2oN_4Xr_RaItRxaWHIHdt4A0NECDgV.eYqyFt5kyDBoEhxeUOfP
 JNnFo8htU3tMD4pWuDcjZI3IpUJiYHMjCCWzB9ahqWGaq.KBl1FEGYvAvIRj
 QgqExUJB5.xKOKICfa592p7xmFxJGVfCusMXrGpZVKJX48YNqO0tBjmrypaE
 FLbZ95348yvcfBlv7sMCjQbsglkm83T7FXiCDY_jeKgQAHIA-
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110106204513.669098445@linux.com>
User-Agent: quilt/0.48-1
Date: Thu, 06 Jan 2011 14:45:13 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [cpuops cmpxchg double V2 0/4] this_cpu_cmpxchg_double support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series introduces this_cpu_cmpxchg_double().

x86 cpus support cmpxchg16b and cmpxchg8b instuction which are capable of
switching two words instead of one during a cmpxchg.
Two words allow to swap more state in an atomic instruction.

this_cpu_cmpxchg_double() is used in the slub allocator to avoid
interrupt disable/enable in both alloc and free fastpath.
this_cpu_cmpxchg_double() works nicely with the per cpu data of the
allocator. Using the new operation significantly speeds up the fastpaths.

V1->V2
	- Change parameter convention for this_cpu_cmpxchg_double. Specify both
	  percpu variables in same way as the two old and new values.
	- Do not require a per cpu pointer but a variable to conform to the
	  convention used in other this_cpu_ops.


