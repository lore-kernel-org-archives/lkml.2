Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab1HVPcY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 11:32:24 -0400
Received: from mail1.vodafone.ie ([213.233.128.43]:19242 "EHLO
	mail1.vodafone.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab1HVPcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 11:32:22 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: An4CAMx1Uk5tTHJJ/2dsb2JhbAAMNYRLl1GOJgEBBSMPAUYQCw0BCgICBRYLAgIJAwIBAgEPNgYNAQUCAQGHcaQhkQOBLIQMgRAEmD6ETIcC
Message-ID: <4E527684.3020206@draigBrady.com>
Date: Mon, 22 Aug 2011 16:32:20 +0100
From: =?UTF-8?B?UMOhZHJhaWcgQnJhZHk=?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Neil Horman <nhorman@tuxdriver.com>
CC: Oleg Nesterov <oleg@redhat.com>, bookjovi@gmail.com, dhowells@redhat.com,
        roland@redhat.com, viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] coredump: fix pipe coredump when core limit is 0
References: <48dnn9u5x3e4qoh8meht42xk.1313966177259@email.android.com>
In-Reply-To: <48dnn9u5x3e4qoh8meht42xk.1313966177259@email.android.com>
X-Enigmail-Version: 1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2011 11:36 PM, Neil Horman wrote:
> Concur.  The comment should be changed
> Neil
> 
> Oleg Nesterov <oleg@redhat.com> wrote:
> 
>> On 08/21, Oleg Nesterov wrote:
>>>
>>> On 08/21, bookjovi@gmail.com wrote:
>>>>
>>>> For non-pipe case, limit 0 also means drop the coredump, so just put
>>>> the zero limit check at do_coredump function begining.
>>>
>>> Neil, what do you think? Should we change the code or the comment?
>>
>> Personally I think we should fix the comment. I think RLIMIT_CORE
>> doesn't apply in this case, limit == 1 check is very special. And
>> this is what linux always did, except between 725eae32 and 898b374a.

Sorry for jumping in late here.
I would really like `ulimit -c 0` to completely disable core dumps,
including not running core_pattern, as I also mentioned here:
https://bugs.launchpad.net/ubuntu/+source/apport/+bug/62511
I noticed this in a script where ctrl-\ was taking a long
time to be registered as the core_pattern was run unconditionally.

Testing on 2.6.38.8-34.fc15.x86_64 here shows the IMHO problematic behavior:

# echo "|/bin/true" > /proc/sys/kernel/core_pattern
# ulimit -c 0
# cat
^\Quit (core dumped)

cheers,
Pádraig.
