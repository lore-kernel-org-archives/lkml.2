Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab2CNHmN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 03:42:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50481 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751758Ab2CNHmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 03:42:12 -0400
X-IronPort-AV: E=Sophos;i="4.73,582,1325433600"; 
   d="scan'208";a="4532031"
Message-ID: <4F604CFA.9010302@cn.fujitsu.com>
Date: Wed, 14 Mar 2012 15:47:06 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Lai Jiangshan <eag0628@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org
Subject: Re: [RFC PATCH 5/5 single-thread-version] implement per-domain single-thread
 state machine call_srcu()
References: <1331023359-6987-1-git-send-email-laijs@cn.fujitsu.com> <1331027858-7648-1-git-send-email-laijs@cn.fujitsu.com> <1331027858-7648-4-git-send-email-laijs@cn.fujitsu.com> <4F56DBDA.1020608@cn.fujitsu.com> <20120308203533.GN2348@linux.vnet.ibm.com> <CACvQF534RJcu8-yKcByqthifUHCLsggGXuRPAKqf7mZMXT3taA@mail.gmail.com> <20120312180321.GG2471@linux.vnet.ibm.com>
In-Reply-To: <20120312180321.GG2471@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-14 15:40:04,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-14 15:40:08,
	Serialize complete at 2012-03-14 15:40:08
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2012 02:03 AM, Paul E. McKenney wrote:

>>
>> In mb()-based srcu, synchronize_srcu() is very fast,
>> synchronize_srcu_expedited() makes less sense than before.
> 
> I am worried about expedited callbacks getting backed up behind
> non-expedited callbacks (especially given Peter's point about per-VMA
> SRCU callbacks) and behind other workqueue uses.
> 
>> But when wait_srcu_gp() is move back here, I will use
>> a bigger "trycount" for synchronize_srcu_expedited().
>>
>> And any problem for srcu_advance_batches()?
> 
> I prefer the use of "return" that you and Peter discussed later.
> 
> What sort of testing are you doing?
>

rcutorture in my box for several days on my daily used machine.

What would you prefer for next round of patches, single-thread or per-cpu?
I will send them soon.
(per-cpu approach will be also "batches, in-sleepable, reuse rcu_head"....)

I prefer the single-thread approach until high-callback-rate-per-domain-era
comes, but I don't know how long when it comes. Peter?

Thanks,
Lai
