Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab1HJUtn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 16:49:43 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:55798 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754022Ab1HJUtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 16:49:42 -0400
Message-ID: <4E42EEE3.9050608@free.fr>
Date: Wed, 10 Aug 2011 22:49:39 +0200
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        LXC Development <Lxc-devel@lists.sourceforge.net>,
        containers@lists.linux-foundation.org
Subject: Re: [RFC] catching sys_reboot syscall
References: <4E4051A0.8030009@free.fr> <20110810221028.2e0c8590@neptune.home>
In-Reply-To: <20110810221028.2e0c8590@neptune.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2011 10:10 PM, Bruno Prémont wrote:
> Hi Daniel,
>
> [I'm adding containers ml as we had a discussion there some time ago
>  for this feature]

[ ... ]

>> +    if (cmd == LINUX_REBOOT_CMD_RESTART2)
>> +        if (strncpy_from_user(&buffer[0], arg, sizeof(buffer) - 1) < 0)
>> +            return -EFAULT;
>> +
>> +    /* If we are not in the initial pid namespace, we send a signal
>> +     * to the parent of this init pid namespace, notifying a shutdown
>> +     * occured */
>> +    if (pid_ns != &init_pid_ns)
>> +        pid_namespace_reboot(pid_ns, cmd, buffer);
> Should there be a return here?
> Or does pid_namespace_reboot() never return by submitting signal to
> parent?

Yes, it does not return a value, like 'do_notify_parent_cldstop'

Thanks
   -- Daniel
