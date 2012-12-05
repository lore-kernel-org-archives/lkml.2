Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633Ab2LEEs2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 23:48:28 -0500
Received: from [65.55.88.11] ([65.55.88.11]:5096 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753507Ab2LEEs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 23:48:26 -0500
X-Forefront-Antispam-Report: CIP:160.33.194.228;KIP:(null);UIP:(null);IPV:NLI;H:usculsndmail01v.am.sony.com;RD:mail.sonyusa.com;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1de0h1202h1d1ah1d2ahzzz2fh2a8h668h839h947hd25hf0ah10d2h1288h12a5h12a9h12bdh137ah13b6h1441h1537h153bh162dh1631h1155h)
Message-ID: <50BED1DA.7070907@am.sony.com>
Date: Tue, 4 Dec 2012 20:47:22 -0800
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>, <linux-rt-users@vger.kernel.org>,
        <tglx@linutronix.de>, <paulmck@linux.vnet.ibm.com>,
        <dipankar@in.ibm.com>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH RT 0/2][RFC] fix RCU stall warning on ARM
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The RCU stall warning functions call trigger_all_cpu_backtrace()
to print a backtrace on each cpu.  This function is only
implemented for x86.  Add a version for ARM.

With CONFIG_PREEMPT_RT_FULL enabled, flushing the output from
printk() is inhibited in some contexts to avoid increasing
real time latencies.  The RCU stall warnings are inhibited
on ARM due to this feature.  (I have not tested whether this
is also the case on other architectures.)  Add back the
oops_in_progress flag to allow the RCU stall warnings to
print immediately.

A third patch contains test scaffolding to force the stall
warnings to occur so that the other patches can be tested.
The third patch should __not__ added to the mainline
RT PREEMPT patch tree.

These patches apply to 3.6.7-rt18.  They do not apply
cleanly to 3.0.xx.

