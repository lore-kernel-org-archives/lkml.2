Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854Ab1HLUm7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 16:42:59 -0400
Received: from smtp2-g21.free.fr ([212.27.42.2]:59767 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319Ab1HLUm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 16:42:58 -0400
Message-ID: <4E45904F.60904@free.fr>
Date: Fri, 12 Aug 2011 22:42:55 +0200
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: Serge Hallyn <serge.hallyn@canonical.com>
CC: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
        bonbons@linux-vserver.org, oleg@tv-sign.ru,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Notify container-init parent a 'reboot' occured
References: <1313094241-3674-1-git-send-email-daniel.lezcano@free.fr> <1313094241-3674-3-git-send-email-daniel.lezcano@free.fr> <20110811210951.GA17349@peqn> <4E444A04.3070403@free.fr> <20110812162908.GA9304@peqn>
In-Reply-To: <20110812162908.GA9304@peqn>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2011 06:29 PM, Serge Hallyn wrote:
> Quoting Daniel Lezcano (daniel.lezcano@free.fr):
> ...
>>> Doesn't this mean that an unprivileged task in a container can shut
>>> down the container?
>> Ha ha ! Right, good catch :)
>>
>> Yes, rethinking about it, we can do what initially proposed Bruno by
>> just preventing to reboot when we are not in the init_pid_ns. Actually, 
>> the sys_reboot occurs after the services shutdown and "kill -1 SIGTERM"
>> and "kill -1 SIGKILL", and would not make sense to do that in a child
>> pid namespace, except if we are in a container where we don't want to
>> reboot :)
>>
>> So IMO, it is safe to do:
>>
>> 	if (!ns_capable(current_pid_ns()->user_ns, CAP_SYS_BOOT))
>>  		return -EPERM;
>> 	
>> 	if (pid_ns != &init_pid_ns)
>> 		return pid_namespace_reboot(pid_ns, cmd, buffer);
> So I don't know if you want to prepend
> http://kernel.ubuntu.com/git?p=serge/linux-syslogns.git;a=commit;h=63556e9a39bcd75ec4a88333425800905013c73e
> to your patchset, or just check nsown_capable(CAP_SYS_BOOT) for now,
> but as soon as you resend with that I'll happily, nay,
> ecstatically ack.

Ok, in order to not mix the functionnalities, I will send in a separate
patch the nsown_capable change.

