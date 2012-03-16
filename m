Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945925Ab2CPQRM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 12:17:12 -0400
Received: from mail1.windriver.com ([147.11.146.13]:61368 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031340Ab2CPQRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 12:17:10 -0400
Message-ID: <4F63677B.4040400@windriver.com>
Date: Fri, 16 Mar 2012 11:16:59 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kgdb-bugreport@lists.sourceforge.net" 
	<kgdb-bugreport@lists.sourceforge.net>
Subject: Re: [PATCH 3/4] kgdb: Respect that flush op is optional
References: <cover.1331900215.git.jan.kiszka@siemens.com> <08ddbfb8fbca5fef8adfce3449b5744b0db7b45f.1331900215.git.jan.kiszka@siemens.com> <4F63362E.1090701@windriver.com> <4F6337AE.9000009@siemens.com>
In-Reply-To: <4F6337AE.9000009@siemens.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2012 07:53 AM, Jan Kiszka wrote:
> On 2012-03-16 13:46, Jason Wessel wrote:
>> On 03/16/2012 07:17 AM, Jan Kiszka wrote:
>>> Not all kgdb I/O drivers implement a flush operation. Adjust
>>> gdbstub_exit accordingly.
>> The flush is certainly optional.  The reason we never saw this bug is because it was only used by some code not in the mainline, where it is in fact patched.  The out of tree patch hooked into the reboot notifier.
>>
>> It makes me wonder if using the reboot notifier is enough vs the call backs you placed in the critical power off points in your patch [4/4].   I'll respond separately to that thread because there are other folks in the CC line.
> I looked at other (granted: not kgdb-) archs and found them hooking
> their machine_xxx handlers. Also, do we trigger the notifier on all
> reboot/shutdown types?

>From what I can tell, all the safe shutdown types go through notifier, however if you do something like:

echo o > /proc/sysrq-trigger

This will avoid the reboot notifier hook.  It is a question of how aggressively you want to catch all these cases or patch the kernel such that these holes provide notifications.

>> If we decide to roll with this series, I will definitely merge this patch, else I will remove the code since it is not used except for out of tree patches.
> Even with a reboot notifier, you still need the logic of gdbstub_exit.
> So I doubt it makes sense to be removed, rather start to be used - finally.

You are correct about that, and it is actually used in the reboot notifier version.

Jason.
