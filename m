Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542Ab2EGVlx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 17:41:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43982 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab2EGVlw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 17:41:52 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1205071514040.6029@router.home>
References: <CAP145pjtv-S2oHhn8_QfLKF8APtut4B9qPXK5QM8nQbxzPd2gw@mail.gmail.com>
	<alpine.DEB.2.00.1205071514040.6029@router.home>
Date: Mon, 7 May 2012 23:41:51 +0200
Message-ID: <CAP145piK2kW4F94pNdKpo_sGg8OD914exOtwCx2o+83jx5Toog@mail.gmail.com>
Subject: Re: mmap/clone returns ENOMEM with lots of free memory
From: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
To: Christoph Lameter <cl@linux.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 7, 2012 at 10:15 PM, Christoph Lameter <cl@linux.com> wrote:
> On Mon, 7 May 2012, Robert Święcki wrote:
>
>> root@ise-test:~/kern-fuz# ./cont.sh
>> su: Cannot fork user shell
>> su: Cannot fork user shell
>> su: Cannot fork user shell
>>
>> root@ise-test:~/kern-fuz# strace -e mmap,clone su test -c 'kill -CONT
>> -1' 2>&1 | grep "= \-1"
>> clone(child_stack=0,
>> flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD,
>> child_tidptr=0x7fadf334f9f0) = -1 ENOMEM (Cannot allocate memory)
>> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
>> 0) = -1 ENOMEM (Cannot allocate memory)
>
> Hmmm... That looks like some maximum virtual memory limit was violated.
>
> Check ulimit and the overcommit settings (see /proc/meminfo's commitlimit
> etc)

Yup (btw: I attached dump of some proc files and some debug commands
in the original e-mail - can be found here
http://marc.info/?l=linux-kernel&m=133640623421007&w=2 in case some
MTA removed them)

CommitLimit:     1981528 kB
Committed_AS:    1916788 kB

just not sure if Committed_AS should present this kind of value. Did I
just hit a legitimate condition, or may it suggest a bug? I'm a bit
puzzled cause

root@ise-test:/proc# grep Mem /proc/meminfo
MemTotal:        3963060 kB
MemFree:         3098324 kB

Also, some sysctl values:
vm.overcommit_memory = 2
vm.overcommit_ratio = 50

-- 
Robert Święcki
