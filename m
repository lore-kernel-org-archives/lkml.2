Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab0HBBvK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 21:51:10 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:41090 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab0HBBvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 21:51:08 -0400
X-AuditID: b753bd60-a96c2ba000005a63-66-4c5624870a24
Message-ID: <4C562485.6030309@hitachi.com>
Date: Mon, 02 Aug 2010 10:51:01 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCHv10 2.6.35-rc6-tip 11/14]  perf: perf interface for uprobes
References: <20100727110855.24690.26901.sendpatchset@localhost6.localdomain6> <20100727111105.24690.48335.sendpatchset@localhost6.localdomain6> <20100730191903.GD12166@ghostprotocols.net> <20100731025748.GA22812@linux.vnet.ibm.com> <20100731193019.GE12166@ghostprotocols.net>
In-Reply-To: <20100731193019.GE12166@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo Carvalho de Melo wrote:
> Em Sat, Jul 31, 2010 at 08:27:48AM +0530, Srikar Dronamraju escreveu:
>>>> @@ -1598,15 +1812,19 @@ struct __event_package {
>>>>  int add_perf_probe_events(struct perf_probe_event *pevs, int npevs,
>>>>  			  bool force_add, int max_tevs)
>>>>  {
>>>> -	int i, j, ret;
>>>> +	int i, j, ret = 0;
>>>>  	struct __event_package *pkgs;
>>>>  
>>>>  	pkgs = zalloc(sizeof(struct __event_package) * npevs);
>>>>  	if (pkgs == NULL)
>>>>  		return -ENOMEM;
>>>>  
>>>> -	/* Init vmlinux path */
>>>> -	ret = init_vmlinux();
>>>> +	if (!pevs->upid)
>>>> +		/* Init vmlinux path */
>>>> +		ret = init_vmlinux();
>>>> +	else
>>>> +		ret = init_perf_uprobes();
>>>> +
>>>>  	if (ret < 0)
>>> pkgs leaks here.
>> Right, but I dont think this leak was introduced by my patch(s). I
>> guess its better fixed by a different patch. 
> 
> Sorry, will fix that then on a separate patch.

Yes, sorry, that was introduced by me...

Thanks for pointing it out.

-- 
Masami HIRAMATSU
2nd Research Dept.
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
