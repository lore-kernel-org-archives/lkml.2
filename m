Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab2CGGja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 01:39:30 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:42682 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750981Ab2CGGj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 01:39:29 -0500
X-IronPort-AV: E=Sophos;i="4.73,544,1325433600"; 
   d="scan'208";a="4478822"
Message-ID: <4F5703B7.50104@cn.fujitsu.com>
Date: Wed, 07 Mar 2012 14:44:07 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Lai Jiangshan <eag0628@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, fweisbec@gmail.com,
        patches@linaro.org
Subject: Re: [RFC PATCH 5/6] implement per-cpu&per-domain state machine call_srcu()
References: <1331023359-6987-1-git-send-email-laijs@cn.fujitsu.com>	 <1331027858-7648-1-git-send-email-laijs@cn.fujitsu.com>	 <1331027858-7648-5-git-send-email-laijs@cn.fujitsu.com>	 <1331034734.11248.287.camel@twins>	 <CACvQF52-kZze+SptSCJtsaj=d6b3vg=VgU+Wbqyz-ebYynnUwA@mail.gmail.com> <1331047932.11248.315.camel@twins>
In-Reply-To: <1331047932.11248.315.camel@twins>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-07 14:37:22,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-07 14:37:32,
	Serialize complete at 2012-03-07 14:37:32
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2012 11:32 PM, Peter Zijlstra wrote:
> On Tue, 2012-03-06 at 22:44 +0800, Lai Jiangshan wrote:
>> it is srcu_barrier(), it have to wait all callbacks complete for all
>> cpus since it is per-cpu
>> implementation.
>>
> If you enqueue each callback as a work, flush_workqueue() alone should
> do that. It'll wait for completion of all currently enqueued works but
> ignores new works.

Callbacks are not queued in the workqueue when call_srcu().
They are delivered(queued in the workqueue) after a grace period,
so we need to wait for all are delivered before flush_workqueue().

> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

