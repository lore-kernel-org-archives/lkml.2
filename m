Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab1JULVw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 07:21:52 -0400
Received: from mx2.parallels.com ([64.131.90.16]:39789 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751336Ab1JULVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 07:21:52 -0400
Message-ID: <4EA155A8.8010802@parallels.com>
Date: Fri, 21 Oct 2011 15:21:12 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Tejun Heo <tj@kernel.org>, <linux-kernel@vger.kernel.org>,
        Andrew Vagin <avagin@parallels.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [patch 5/5] elf: Add support for loading ET_CKPT files
References: <20111014110416.552685686@openvz.org> <20111014110511.670174429@openvz.org> <20111014171033.GC4294@google.com> <4EA15224.10102@parallels.com> <20111021112031.GO14464@moon>
In-Reply-To: <20111021112031.GO14464@moon>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2011 03:20 PM, Cyrill Gorcunov wrote:
> On Fri, Oct 21, 2011 at 03:06:12PM +0400, Glauber Costa wrote:
> ...
>> exec() is a fundamental interface to the kernel, and the change
>> proposed here is too disruptive. Not only that, it is rather
>> unannounced: since not always one knows kind of fmt file is being
>> exec'd, it gets hard to infer which behavior to expect.
>>
>
> This missed snipped in changelog indeed my very fault, sorry for that.
>
>> I am wondering, though: if exec is a problem, but the binary handler
>> is not, maybe we can exec a process using this handler, and then
>> have the handler itself to create the thread hierarchy. This way we
>> avoid changing exec() behavior at all, yet achieving the same
>> results.
>>
>> What do you think?
>>
>>
>
> Glauber, could you please elaborate, you mean to call for forks inside
> elf-chkpt handler, right? Or you mean something else?

not fork(), clone().

