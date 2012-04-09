Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab2DIQdx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 12:33:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083Ab2DIQdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 12:33:51 -0400
Message-ID: <4F830F64.8000703@redhat.com>
Date: Mon, 09 Apr 2012 12:33:40 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Sven Joachim <svenjoac@gmx.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
Subject: Re: v3.4-rc2 out-of-memory problems (was Re: 3.4-rc1 sticks-and-crashs)
References: <CA+55aFwTFXtMLhXo7g9F7uyHc3W8SCw7z1gTm9jbWXM3Nqc_ZA@mail.gmail.com> <20120408195044.13ea6c8e.akpm@linux-foundation.org> <CA+55aFw7GsiZbNW84WVMUMT6C0Sw82jxaYxeaaB8qq=41Ep5Wg@mail.gmail.com> <8762d9v10x.fsf@turtle.gmx.de> <4F8306ED.7080405@redhat.com> <87398cev3j.fsf@turtle.gmx.de>
In-Reply-To: <87398cev3j.fsf@turtle.gmx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2012 12:19 PM, Sven Joachim wrote:
> On 2012-04-09 17:57 +0200, Rik van Riel wrote:
>
>> On 04/09/2012 03:04 AM, Sven Joachim wrote:
>>
>>> While I did not experience any crashes or instabilities (yet?), I'm also
>>> seeing memory leaks.  On a system started this morning, with hardly
>>> anything running:
>>
>>> where I would expect no more than 50 MB used, 400 MB are actually in use:
>>>
>>> ,----
>>> | $ free
>>> |              total       used       free     shared    buffers     cached
>>> | Mem:       3348400    1849712    1498688          0     328960    1119180
>>> | -/+ buffers/cache:     401572    2946828
>>> | Swap:      3719040          0    3719040
>>> `----
>>
>> Do you see any big memory users in /proc/meminfo or in
>> /proc/slabinfo?
>
> Attaching these files, since I can't really make anything out of the
> latter.  Note that I started a few memory hogs (X, Firefox, Emacs with
> Gnus), so overall memory footprint has grown to 768 MB.

Looks like the "missing" 400MB is all in filesystem caches,
specifically the dentry cache, the ext4 inode cache and
buffer heads.

That is perfectly fine, since those caches will be shrunk
when the system needs memory.

-- 
All rights reversed
