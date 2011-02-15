Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039Ab1BOXCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 18:02:17 -0500
Received: from smtp-relay2.palm.com ([64.28.152.243]:47057 "EHLO
	smtp-relay2.palm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab1BOXCQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 18:02:16 -0500
X-Greylist: delayed 583 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Feb 2011 18:02:16 EST
X-IronPort-AV: E=Sophos;i="4.60,476,1291622400"; 
   d="scan'208";a="1445659"
From: "Kenneth Albanowski (Palm GBU)" <Kenneth.Albanowski@palm.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Jakub Jelinek <jakub@redhat.com>,
        Andreas Schwab <schwab@linux-m68k.org>
Date: Tue, 15 Feb 2011 14:51:28 -0800
Subject: RE: Question about clearing of tsk->robust_list in clone
Thread-Topic: Question about clearing of tsk->robust_list in clone
Thread-Index: AcvNEsmqryGBmZ4CT+uo6CJqpyKVoQANCtNQ
Message-ID: <23C1F4DA0B73684F85AD25A73E4BB50315252C50@ushqwmb09>
References: <23C1F4DA0B73684F85AD25A73E4BB50315252BD7@ushqwmb09>
 <alpine.LFD.2.00.1102151233330.26192@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1102151233330.26192@localhost6.localdomain6>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Feb 2011, Thomas Gleixner wrote:

> The sanity checks in exit_robust_list will catch that mutex_1
> owner is not matching, but that makes it not more correct.

Yes, that's my remaining question: whether the intention was that the
owner filter would often be preventing erroneous unlocks, or whether
there should never be an inappropriate list in normal usage. The owner
check does seem sufficient to prevent mayhem if the list pointer is
copied to the child.

On Tue, 15 Feb 2011, Peter Zijlstra wrote:

> Realistically libpthread should register an on_fork() callback to 
> ensure the state is properly propagated.

Agreed, that seems reasonable, with only the minor impact of an
additional set_robust_list call. That resolves this as a libc issue,
not a kernel issue.

- Kenneth

