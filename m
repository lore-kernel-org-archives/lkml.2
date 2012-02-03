Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757020Ab2BCQpV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 11:45:21 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:34624 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756872Ab2BCQpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 11:45:20 -0500
Message-ID: <4F2C0F13.70709@parallels.com>
Date: Fri, 03 Feb 2012 20:45:07 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Andrew Vagin <avagin@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH] ptrace: add ability to get clear_tid_address
References: <1328267483-3225342-1-git-send-email-avagin@openvz.org> <20120203162519.GB805@google.com>
In-Reply-To: <20120203162519.GB805@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2012 08:25 PM, Tejun Heo wrote:
> On Fri, Feb 03, 2012 at 02:11:23PM +0300, Andrew Vagin wrote:
>> Zero is written at clear_tid_address, when the process exits.
>> This functionality is used by pthread_join().
>>
>> sys_set_tid_address() changes this address for current task.
>>
>> Before this patch clear_tid_address could not be got from user space.
>> I want to dump a full state of a task, so I need this address.
>> Also I think it may be useful for debugging a multithreading program.
>>
>> I am not sure that ptrace is suitable place. It may be added in prctl,
>> but I think it's a bit useless and strange. I can't image a real
>> situation (avoid checkpointing) when a thread will want to get own
>> clear_tid_address from itself, this address is used by parent ussually.
>>
>> Signed-off-by: Andrew Vagin <avagin@openvz.org>
> 
> Ummm... this really doesn't fit in ptrace.  Cyrill, why not put it
> together with other params you're exporting?

Because there's no need for current to get this value of himself, but can
be useful for e.g. gdb. But we don't insist. Prctl extension is just fine.

> Thanks.
> 

