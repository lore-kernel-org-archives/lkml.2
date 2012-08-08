Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030384Ab2HHP7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 11:59:46 -0400
Received: from 209.248.170.90.nw.nuvox.net ([209.248.170.90]:19008 "EHLO
	GVL-MAIL.koe-americas.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030197Ab2HHP7p convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 11:59:45 -0400
From: David Cullen <David.Cullen@koe-americas.com>
To: Michal Marek <mmarek@suse.cz>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] ARM Fix /usr/bin/xargs: etags: Argument list too
 long
Thread-Topic: [RFC PATCH] ARM Fix /usr/bin/xargs: etags: Argument list too
 long
Thread-Index: AQHNdXKwUdMPlyBDmEORxEZhcXYKA5dQQA4AgAAVwIA=
Date: Wed, 8 Aug 2012 15:59:43 +0000
Message-ID: <50228CEF.2050208@koe-americas.com>
References: <50227893.7070600@koe-americas.com> <50227AB0.6010301@suse.cz>
In-Reply-To: <50227AB0.6010301@suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713
 Thunderbird/14.0
x-originating-ip: [10.1.5.28]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <8697430D761F9B42B6A72DFAB08755D6@koe-americas.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/8/2012 10:41 AM, Michal Marek wrote:
> Dne 8.8.2012 16:32, David Cullen napsal(a):
>> Patch applies to
>>
>>     commit 42a579a0f960081cd16fc945036e4780c3ad3202
>>
>> When running "make ARCH=arm TAGS" in a chroot using qemu-arm-static,
>> the following message is emitted:
>>
>>     [user@host:/home/work/linux]: make ARCH=arm TAGS
>>       GEN     TAGS
>>     /usr/bin/xargs: etags: Argument list too long
>>
>> This can be fixed by by passing "-L 1024" to xargs in scripts/tags.sh.
>>
>> The "1024" was a guess. A value of "3862" changes the message to
>>
>>     /usr/bin/xargs: argument list too long
>>
>> Using "2048" also fixes the problem. However, I don't know how much
>> headroom that leaves
>>
>> Does anyone know why the argument lists must be shorter for ARM? All
>> of the documentation I have available says that 4096 should be the
>> limit.
> 
> This looks like a bug in xargs, it should make sure that the commandline
> fits into ARG_MAX.

Actually, it appears to be caused by the combination of
qemu-arm-static and xargs. When I run "make ARCH=arm TAGS" on an ARM
target, I do not see the problem.

> BTW, a better workaround would be to use the -s option, which
> limits the size of the argument list.

That works.

I'll submit another RFC patch.

-- 
Thank you,
David Cullen