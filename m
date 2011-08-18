Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab1HRXql (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 19:46:41 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:44677 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399Ab1HRXqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 19:46:40 -0400
Message-ID: <4E4DA461.8030006@free.fr>
Date: Fri, 19 Aug 2011 01:46:41 +0200
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: "Serge E. Hallyn" <serge@hallyn.com>, akpm@linux-foundation.org,
        bonbons@linux-vserver.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Send a SIGCHLD to the init's pid namespace parent
 when reboot
References: <1313094241-3674-1-git-send-email-daniel.lezcano@free.fr> <20110814161707.GB30846@redhat.com> <20110814213642.GB13799@hallyn.com> <20110815144744.GA9660@redhat.com>
In-Reply-To: <20110815144744.GA9660@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2011 04:47 PM, Oleg Nesterov wrote:
> On 08/14, Serge E. Hallyn wrote:
>> Quoting Oleg Nesterov (oleg@redhat.com):
>>> On 08/11, Daniel Lezcano wrote:
>>>> In the case of a VPS, when we shutdown/halt/reboot the container, the
>>>> reboot utility will invoke the sys_reboot syscall which has the bad
>>>> effect to reboot the host.
>>> Stupid question. Can't sys_reboot() simply kill init (and thus the whole
>>> pid_ns) in this case?
>> The goal is to be able to distinguish a request for reboot from shutdown.
>> If we just kill the init, then the parent of init (the container monitor)
>> cannot restart the container to emulate reboot.
> OK, thanks.
>
> What if init reports the reason it was killed?
>
> Ignoring LINUX_REBOOT_CMD_CAD_/etc, I mean, roughly,
>
> 	- add "int reboot_cmd" into struct pid_namespace
>
> 	- sys_reboot(cmd) does
>
> 		if (!global_namespace) {
> 			task_active_pid_ns(current)->reboot_cmd = cmd;
> 			sigkill_my_init();
> 		}

Hi Oleg,

what would be your advice to get rid of from_ancestor_ns which prevent
the signal to be delivered to the init process ?

Thanks
  -- Daniel
