Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759322Ab2CFOrm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 09:47:42 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:59566 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759273Ab2CFOrl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 09:47:41 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of eag0628@gmail.com designates 10.229.137.144 as permitted sender) smtp.mail=eag0628@gmail.com; dkim=pass header.i=eag0628@gmail.com
MIME-Version: 1.0
In-Reply-To: <1331034734.11248.287.camel@twins>
References: <1331023359-6987-1-git-send-email-laijs@cn.fujitsu.com>
	<1331027858-7648-1-git-send-email-laijs@cn.fujitsu.com>
	<1331027858-7648-5-git-send-email-laijs@cn.fujitsu.com>
	<1331034734.11248.287.camel@twins>
Date: Tue, 6 Mar 2012 22:47:40 +0800
Message-ID: <CACvQF52cmm5-tEuQaTDFAsavTECzFWyNTOhrquXP+QBGWK2P2w@mail.gmail.com>
Subject: Re: [RFC PATCH 5/6] implement per-cpu&per-domain state machine call_srcu()
From: Lai Jiangshan <eag0628@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, fweisbec@gmail.com,
        patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
>> +               }
>> +       }
>> +       spin_unlock_irq(&sp->gp_lock);
>> +
>> +       flush_workqueue(srcu_callback_wq);
>
> Since you already waited for the completions one by one, what's the
> purpose of this?

srcu callbacks are preemptible/sleepable here, so they may not
complete in order,
some may not finish here. so srcu_barrier() needs to wait them.


>
>> +}
>> +EXPORT_SYMBOL_GPL(srcu_barrier);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
