Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166Ab2DIXZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 19:25:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41504 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757434Ab2DIXZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 19:25:11 -0400
Message-ID: <4F836F3E.9090207@zytor.com>
Date: Mon, 09 Apr 2012 16:22:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Valdis.Kletnieks@vt.edu,
        Michal Marek <mmarek@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: + syscalls-x86-add-__nr_kcmp-syscall-v8.patch added to -mm tree
References: <20120215143606.GA14037@redhat.com> <20120215160652.GA17680@redhat.com> <20120215162752.GF4533@moon> <20120409151027.7f3e0fa5.akpm@linux-foundation.org> <20120409222443.GW1625@moon>
In-Reply-To: <20120409222443.GW1625@moon>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2012 03:24 PM, Cyrill Gorcunov wrote:
>>
>> Having re-read most of the (enormous) email discussion on the kcmp()
>> syscall patch, I'm thinking:
>>
>> - Nobody seems to understand the obfuscation logic.  Jon sounded
>>   confused, Oleg sounds confused and it's rather unclear what it does,
>>   how it does it and why it does it.
> 
> The obfuscation logic was done with great help from hpa@. And the main
> idea was to have ordered results after obfuscation. Per-type noise increase
> randomization of results. So Andrew, I actually dont know what to add
> here. We don't want to provide kernel order back to user-space in
> naked manner.
> 

The obfuscation logic is to provide a 1:1 mapping but which doesn't
preserve ordering, thereby avoid leaking information of kernel pointers
to user space.

	-hpa

