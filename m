Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759986Ab1F1R0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 13:26:20 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:48696 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759755Ab1F1RXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 13:23:06 -0400
Message-ID: <4E0A0C90.2010305@gmail.com>
Date: Tue, 28 Jun 2011 19:17:04 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Sergiu Iordache <sergiu@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] char drivers: ramoops record_size module parameter
References: <1309224113-21818-1-git-send-email-sergiu@chromium.org>	<1309224113-21818-4-git-send-email-sergiu@chromium.org>	<BANLkTimhEE6TXqnS+eLx863+rjJxqzu19A@mail.gmail.com> <BANLkTiniM96M16TnPC9sXNg-rhDD1RT4KOcD1HJUH-Nu+7hY2Q@mail.gmail.com>
In-Reply-To: <BANLkTiniM96M16TnPC9sXNg-rhDD1RT4KOcD1HJUH-Nu+7hY2Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 28/06/2011 18:38, Sergiu Iordache ha scritto:
> On Mon, Jun 27, 2011 at 11:39 PM, Marco Stornelli
> <marco.stornelli@gmail.com>  wrote:
>> Hi,
>>
>> 2011/6/28 Sergiu Iordache<sergiu@chromium.org>:
>>> The size of the dump is currently set using the RECORD_SIZE macro which
>>> is set to a page size. This patch makes the record size a module
>>> parameter and allows it to be set through platform data as well to allow
>>> larger dumps if needed.
>>>
>>> Change-Id: Ie6bd28a898dab476abf34decb0eecc42122f17ce
>>> Signed-off-by: Sergiu Iordache<sergiu@chromium.org>
>>> ---
>>
>> the idea can be valid, but you have to add some check to set the
>> record size. It'd be better to add a lower and upper bound and to
>> check for it's power of two.
>
> That sounds like a good idea. Since the memory size gets rounded to a
> power of two it would probably be more consistent to round down the
> record size as well. This way you would be sure that mem_size is a
> multiple of record size as well. The upper bound would be the memory
> size, which is already checked. I'm not sure whether it would be a
> good idea to add lower bound different from record_size != 0 (I don't
> know why someone would need to dump 8 bytes for example but is there a
> reason to limit it?)
>
> Sergiu
>

I meant to use (as at the moment) min 4k for record size and so min 4k 
for mem_size.

Marco
