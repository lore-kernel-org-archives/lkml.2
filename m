Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab0CQTP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 15:15:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59589 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753361Ab0CQTPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 15:15:25 -0400
Message-ID: <4BA12A23.4030109@redhat.com>
Date: Wed, 17 Mar 2010 15:14:43 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: Mark Wielaard <mjw@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH -tip 10/10] perf probe: Accessing members in data structures
References: <20100316220515.32050.82185.stgit@localhost6.localdomain6>	 <20100316220626.32050.57552.stgit@localhost6.localdomain6> <1268821537.6022.12.camel@springer.wildebeest.org>
In-Reply-To: <1268821537.6022.12.camel@springer.wildebeest.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Wielaard wrote:
> On Tue, 2010-03-16 at 18:06 -0400, Masami Hiramatsu wrote:
>> Support accessing members in the data structures. With this,
>> perf-probe accepts data-structure members(IOW, it now accepts
>> dot '.' and arrow '->' operators) as probe arguemnts.
>>
>> e.g.
>>
>>  ./perf probe --add 'schedule:44 rq->curr'
>>
>>  ./perf probe --add 'vfs_read file->f_op->read file->f_path.dentry'
>>
>> Note that '>' can be interpreted as redirection in command-line.
> 
> If you find that a problem then you can do like SystemTap does and allow
> '.' in place of '->'. In the code you already use the
> perf_probe_arg_field ref flag only to check that the DIE gives you the
> same information. So you could just drop that and use any separator.
> Then you decide based on whether you see a DW_TAG_pointer_type. This
> gives the user some extra flexibility by letting them not having to care
> about specifying extra type information already available elsewhere.

Thanks, when designing this feature, I considered it too.

Since perf probe already support displaying source code by --line option,
users will read the probed code itself and try to probe it. In that case,
I think they naturally use '.' and '->' as they read (they might try to
copy & paste it).

So, I think that it would be good to support both of '.' and '->' as
they are used in the code, because it will not confuse users.

Thank you,

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
