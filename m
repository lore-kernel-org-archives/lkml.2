Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038Ab0FVMZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 08:25:44 -0400
Received: from smtp.nokia.com ([192.100.122.233]:47718 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768Ab0FVMZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 08:25:41 -0400
Message-ID: <4C20ABC0.5050908@nokia.com>
Date: Tue, 22 Jun 2010 15:25:36 +0300
From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: ext Kees Cook <kees.cook@canonical.com>
CC: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] security: Yama LSM
References: <20100621213424.GG24749@outflux.net> <201006220028.o5M0Sbx7062650@www262.sakura.ne.jp> <20100622011452.GN24749@outflux.net>
In-Reply-To: <20100622011452.GN24749@outflux.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Jun 2010 12:25:26.0243 (UTC) FILETIME=[FE661330:01CB1205]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

What is YAMA?
Where is the tree?

Thanks,
Dmitry


On 22/06/10 04:14, ext Kees Cook wrote:
> Hi Tetsuo,
>
> On Tue, Jun 22, 2010 at 09:28:37AM +0900, Tetsuo Handa wrote:
>   
>> Kees Cook wrote:
>>     
>>> +       /* require ptrace target be a child of ptracer on attach */
>>> +       if (mode == PTRACE_MODE_ATTACH && ptrace_scope &&
>>> +           !capable(CAP_SYS_PTRACE)) {
>>> +               struct task_struct *walker = child;
>>> +
>>> +               read_lock(&tasklist_lock);
>>>       
>> Holding tasklist_lock does not imply rcu protection.
>> Don't you need rcu_read_lock() like setpriority() and getppid()?
>>     
> You're totally right, thanks for the catch!  Looks like setpriority() does
> a similar kind of thing, so I've wrapped the whole thing in rcu_ now:
>
> ...
> +               rcu_read_lock();
>                 read_lock(&tasklist_lock);
>                 while (walker->pid > 0) {
> ...
>                         rc = -EPERM;
>                 read_unlock(&tasklist_lock);
> +               rcu_read_unlock();
> ...
>
>
> -Kees
>
>   
