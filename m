Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab1KGWPT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 17:15:19 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58624 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab1KGWPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 17:15:17 -0500
Message-ID: <4EB8586B.5060804@jp.fujitsu.com>
Date: Mon, 07 Nov 2011 14:15:07 -0800
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: mzxreary@0pointer.de
CC: alan@lxorguk.ukuu.org.uk, dave@gnu.org, hch@infradead.org,
        hughd@google.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, kay.sievers@vrfy.org
Subject: Re: [RFC PATCH] tmpfs: support user quotas
References: <1320614101.3226.5.camel@offbook> <20111107112952.GB25130@tango.0pointer.de> <1320675607.2330.0.camel@offworld> <20111107135823.3a7cdc53@lxorguk.ukuu.org.uk> <20111107143010.GA3630@tango.0pointer.de>
In-Reply-To: <20111107143010.GA3630@tango.0pointer.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(11/7/2011 6:30 AM), Lennart Poettering wrote:
> On Mon, 07.11.11 13:58, Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
> 
>>
>>> Right, rlimit approach guarantees a simple way of dealing with users
>>> across all tmpfs instances.
>>
>> Which is almost certainly not what you want to happen. Think about direct
>> rendering.
> 
> I don't see what direct rendering has to do with closing the security
> hole that /dev/shm currently is.
> 
>> For simple stuff tmpfs already supports size/nr_blocks/nr_inodes mount
>> options so you can mount private resource constrained tmpfs objects
>> already without kernel changes. No rlimit hacks needed - and rlimit is
>> the wrong API anyway.
> 
> Uh? I am pretty sure we don't want to mount a private tmpfs for each
> user in /dev/shm and /tmp. If you have 500 users you'd have 500 tmpfs on
> /tmp and on /dev/shm. Despite that without some ugly namespace hackery
> you couldn't make them all appear in /tmp as /dev/shm without
> subdirectories. Don't forget that /dev/shm and /tmp are an established
> userspace API.
> 
> Resource limits are exactly the API that makes sense here, because:
> 
> a) we only want one tmpfs on /tmp, and one tmpfs on /dev/shm, not 500 on
> each for each user

Ok, seems fair.

> b) we cannot move /dev/shm, /tmp around without breaking userspace
> massively

agreed.

> 
> c) we want a global limit across all tmpfs file systems for each user

Why? Is there any benefit this?


> d) we don't want to have to upload the quota database into each tmpfs at
> mount time.
> 
> And hence: a per user RLIMIT is exactly the minimal solution we want
> here.

If you want per-user limitation, RLIMIT is bad idea. RLIMIT is only inherited
by fork. So, The api semantics clearly mismatch your usecase.

Instead, I suggest to implement new sysfs knob.

Thank you.
