Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab1KPHKP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 02:10:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51955 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536Ab1KPHKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 02:10:14 -0500
Message-ID: <4EC361C0.7040309@redhat.com>
Date: Wed, 16 Nov 2011 15:09:52 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110928 Fedora/3.1.15-1.fc14 Thunderbird/3.1.15
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        kay.sievers@vrfy.org
Subject: Re: [Patch] tmpfs: add fallocate support
References: <1321346525-10187-1-git-send-email-amwang@redhat.com> <CAOJsxLEXbWbEhqX2YfzcQhyLJrY0H2ifCJCvGkoFHZsYAZEMPA@mail.gmail.com>
In-Reply-To: <CAOJsxLEXbWbEhqX2YfzcQhyLJrY0H2ifCJCvGkoFHZsYAZEMPA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年11月15日 19:23, Pekka Enberg 写道:
> Hello,
>
> On Tue, Nov 15, 2011 at 10:42 AM, Amerigo Wang<amwang@redhat.com>  wrote:
>> This patch adds fallocate support to tmpfs. I tested this patch
>> with the following test case,
>>
>>         % sudo mount -t tmpfs -o size=100 tmpfs /mnt
>>         % touch /mnt/foobar
>>         % echo hi>  /mnt/foobar
>>         % fallocate -o 3 -l 5000 /mnt/foobar
>>         fallocate: /mnt/foobar: fallocate failed: No space left on device
>>         % fallocate -o 3 -l 3000 /mnt/foobar
>>         % ls -l /mnt/foobar
>>         -rw-rw-r-- 1 wangcong wangcong 3003 Nov 15 16:10 /mnt/foobar
>>         % dd if=/dev/zero of=/mnt/foobar seek=3 bs=1 count=3000
>>         3000+0 records in
>>         3000+0 records out
>>         3000 bytes (3.0 kB) copied, 0.0153224 s, 196 kB/s
>>         % hexdump -C /mnt/foobar
>>         00000000  68 69 0a 00 00 00 00 00  00 00 00 00 00 00 00 00  |hi..............|
>>         00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
>>         *
>>         00000bb0  00 00 00 00 00 00 00 00  00 00 00                 |...........|
>>         00000bbb
>>         % cat /mnt/foobar
>>         hi
>>
>> Signed-off-by: WANG Cong<amwang@redhat.com>
>
> What's the use case for this?
>

Hi, Pekka,

Systemd needs it, see http://lkml.org/lkml/2011/10/20/275.
I am adding Kay into Cc.

Thanks.
