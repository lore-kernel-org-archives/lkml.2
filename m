Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209Ab1FILA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 07:00:26 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49485 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004Ab1FILAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 07:00:24 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DF0A7B8.6030102@jp.fujitsu.com>
Date: Thu, 09 Jun 2011 20:00:08 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: vgoyal@redhat.com
CC: kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
        xiyou.wangcong@gmail.com, ebiederm@xmission.com,
        linux-kernel@vger.kernel.org, jwilson@redhat.com, seiji.aguchi@hds.com
Subject: Re: [Patch] kexec: remove KMSG_DUMP_KEXEC (was Re: Query about kdump_msg
 hook into crash_kexec())
References: <20110203095837.93A2.A69D9226@jp.fujitsu.com> <20110203020703.GB21603@redhat.com> <20110203135324.93BC.A69D9226@jp.fujitsu.com> <20110526131028.7052a893.akpm@linux-foundation.org> <4DE3277D.8070109@jp.fujitsu.com> <20110531215126.GW16382@redhat.com>
In-Reply-To: <20110531215126.GW16382@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Sorry for the delay. I had got stuck LinuxCon Japan and piled up plenty
paper works.

>>> I think I can agree your proposal. But could you please explain why do 
>>> you think kmsg _before_ kdump and kmsg _in_ kdump are so different? 
>>> I think it is only C level difference. CPU don't care C function and 
>>> anyway the kernel call kmsg_dump() because invoke second kernel even 
>>> if you proposal applied. 
>>> It is only curious. I'm not against your proposal. 
>>> Thanks. 
> 
> Few reasons.
> 
> - There is no correlation between crash_kexec() and kdump_msg(). What
>   you are creating is equivalent of panic notifiers and calling those
>   notifiers before dump happened. So calling it inside of crash_kexec()
>   does not make much sense from code point of view.

Thank you for the replay. I got you _think_ no makes sense, but I haven't
explain what you talk about the code of "code point of view".
If you read the code, you can understand kdump_msg() and panic_notifiers
are not same point.


> - Why does somebody need to keep track of event KMSG_DUMP_KEXEC?

I believe I answered already at last thread.

http://groups.google.com/group/linux.kernel/browse_thread/thread/1084f406573d76ac/daa1a08804385089?q=kexec%3A+remove+KMSG_DUMP_KEXEC&lnk=ol&


> - There is one kernel CONFIG option introduce which looks completely
>   superfluous.

What you mean "superfluous"? We already have billion kernel CONFIG.
Is it also bad?

> My general take on the whole issue.
> 
> - In general I think exporting a hook to module so that they can do
>   anything before crash is a bad idea. Now this can be overloaded to
>   do things like sending crash notifications in clustered environement
>   where we recommend doing it in second kernel.

??
It's not my issue and I haven't talked about such thing. I guess you
confuse I and Aguch-san or someone else.

> 
> - Even if we really have to do it, there seemed to be two concern
>   areas.
> 
> 	- Reliability of kdump_msg() generic infrastructure and its
>   	  capability in terms of handling races with other cpus and
> 	  NMIs.
> 
> 	- Reliability of module which is getting the callback from
> 	  kdump_msg().

Indeed. I thought Aguch-san said he promised he work on improve them.
However it doesn't happen yet. Okay, I


>  I think in one of the mails I was discussing that common infrastructure
>  between kdump and kmsg_dump() can be put in a separate function, like
>  stopping all cpus etc to avoid races in generic infrastrucutre and
>  then first we can all kmsg_dump() and then crash_kexec().

Nice idea! Yes. I didn't think enterprise folks start to use this feature
and it now happen.
If nobody are working on this, I'll do it.


>  But this still does not provide us any protection against modules getting
>  control after crash and possiblly worsen the situation.

I think this doesn't big matter. If module author hope to get hook, they
can use kprobe in nowadays. I don't think we can make perfect kprobe protection.
I think I wrote this at last thread too.

Probably most reliability stupid module detect way is, watching lkml and revewing
kmsg_dump() user conteniously. However, if you strongly worry about this issue,
I can agree we make tiny foolish module protection. (but I don't have concrete
idea yet)



