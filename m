Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab0CSOL1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 10:11:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256Ab0CSOL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 10:11:26 -0400
Message-ID: <4BA385CB.9080706@redhat.com>
Date: Fri, 19 Mar 2010 10:10:19 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Roland McGrath <roland@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH -tip v5] tracepoint: Add signal coredump tracepoint
References: <20100319132346.31144.40337.stgit@localhost6.localdomain6> <20100319133352.GC19394@redhat.com>
In-Reply-To: <20100319133352.GC19394@redhat.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> (add Neil)
> 
> On 03/19, Masami Hiramatsu wrote:
>>
>>  void do_coredump(long signr, int exit_code, struct pt_regs *regs)
>>  {
>>  	struct core_state core_state;
>> -	char corename[CORENAME_MAX_SIZE + 1];
>> +	char corename[CORENAME_MAX_SIZE + 1] = "";
>>  	struct mm_struct *mm = current->mm;
>>  	struct linux_binfmt * binfmt;
>>  	struct inode * inode;
>> @@ -1802,6 +1803,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
>>  	static atomic_t core_dump_count = ATOMIC_INIT(0);
>>  	struct coredump_params cprm = {
>>  		.signr = signr,
>> +		.file = NULL,
>>  		.regs = regs,
>>  		.limit = rlimit(RLIMIT_CORE),
>>  		/*
>> @@ -1815,8 +1817,10 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
>>  	audit_core_dumps(signr);
>>
>>  	binfmt = mm->binfmt;
>> -	if (!binfmt || !binfmt->core_dump)
>> +	if (!binfmt || !binfmt->core_dump) {
>> +		retval = -ENOSYS;
>>  		goto fail;
>> +	}
> 
> Oh.
> 
> Masami, may I ask you to delay these changes a bit?
> 
> This patch conflicts very much with other changes (hopefully in -mm soon)
> we are doing.
> 
> If your patch comes first, we have to redo 12 patches. Besides, this patch
> complicates do_coredump() even more while it really needs the cleanups.

Ah, that's a big conflict :O
Yes, sure, I can wait for your commits. I'll update this patch on yours.

> Please see
> http://groups.google.com/group/fa.linux.kernel/browse_thread/thread/96f01d85034ca029/3b6bcb9b2d756dbc
> I can send you these patches privately if you wish.

OK, I can pick them up from the thread:)

Thank you!

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
