Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582Ab2HGXYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 19:24:16 -0400
Received: from imp02.mtu.ru ([62.5.255.19]:40916 "EHLO imp02.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757275Ab2HGXYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 19:24:12 -0400
X-Spam-Flag: NO
Message-ID: <5021A372.8030409@pavlinux.ru>
Date: Wed, 08 Aug 2012 03:23:30 +0400
From: Pavel Vasilyev <pavel@pavlinux.ru>
Reply-To: pavel@pavlinux.ru
Organization: Pavlinux. Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.6esrpre) Gecko/20120713 Thunderbird/10.0.6
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Pavel Machek <pavel@ucw.cz>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: Re: [linux-pm] [PATCH] ACPI: replace strlen("string") with sizeof("string")
 -1
References: <Pine.LNX.4.44L0.1208071322070.2400-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1208071322070.2400-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

07.08.2012 21:24, Alan Stern пишет:
> On Tue, 7 Aug 2012, Pavel Vasilyev wrote:
>
>> 06.08.2012 23:59, Alan Stern пишет:
>>> On Mon, 6 Aug 2012, Pavel Vasilyev wrote:
>>>
>>>>>> http://www.gossamer-threads.com/lists/engine?do=post_attachment;postatt_id=41157;list=linux
>>>>>
>>>>> Interestingly, many (all?) of the changes in that patch are wrong
>>>>> because they don't try to match the terminating '\0'.  As a result,
>>>>> they will match against extensions of the target string as well as the
>>>>> target string itself.
>>>>>
>>>>
>>>> strNcmp compare N bytes - http://lxr.linux.no/#linux+v3.5/lib/string.c#L270
>>>> memcmp compare N bytes  - http://lxr.linux.no/#linux+v3.5/lib/string.c#L651
>>>
>>> Yes.  So if s contains "abcde" then
>>>
>>> 	memcmp(s, "abc", 3) and strncmp(s, "abc", 3) will both return 0, and
>>> 	memcmp(s, "abc", 4) and strncmp(s, "abc", 4) will both return 1.
>>
>> No matter what is contained in *s, "abcde" or "abcxxx",
>> are important first N bytes. The second example, you see,
>> a little bit stupid, and devoid of logic. :)
>
> Maybe yes, maybe no.  It all depends on what you want.
>
> For example, if you're looking for "on" or "off", what should you do
> when the user writes "onoff"?  You could accept it as meaning the same
> as "on", but if you were being careful then you would want to reject it
> as a meaningless value.


The users should't be allowed to think!
There is "on" - the size of 2 bytes, or "off" - 3 bytes,
other variations - user error.

We do not create a kernel with artificial intelligence? ;)

-- 
                                                          Pavel.
