Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757709Ab1F2UKq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 16:10:46 -0400
Received: from smtp-out.google.com ([74.125.121.67]:55701 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756912Ab1F2UKm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 16:10:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=b/uVXlVzAOb3oU4pw9mg43ifeGKe1dbuBDyvoQ7dj6PUvgA9L4/gf2VjWCDe8lTNF
	8/tqGlq4Do1zffH6jk45w==
MIME-Version: 1.0
In-Reply-To: <1309377708.26417.41.camel@gandalf.stny.rr.com>
References: <1309376033-32005-1-git-send-email-dima@android.com>
	<1309377708.26417.41.camel@gandalf.stny.rr.com>
Date: Wed, 29 Jun 2011 13:10:39 -0700
X-Google-Sender-Auth: PMIrwg-r-EikJ3WOoqwehFEyGrI
Message-ID: <CAPz4a6BzYdwH-fTdP=tC-AcC4x_bMtu4YHa80rcTUy6ZV4JEfA@mail.gmail.com>
Subject: Re: [PATCH] plist: add mutex to the blessed lock type for plists
From: Dima Zavin <dima@android.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 1:01 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 2011-06-29 at 12:33 -0700, Dima Zavin wrote:
>
>> +#include <linux/mutex.h>
>>  #include <linux/plist.h>
>>  #include <linux/spinlock.h>
>>
>> @@ -56,11 +57,14 @@ static void plist_check_list(struct list_head *top)
>>
>>  static void plist_check_head(struct plist_head *head)
>>  {
>> -     WARN_ON(head != &test_head && !head->rawlock && !head->spinlock);
>> +     WARN_ON(head != &test_head && !head->rawlock && !head->spinlock &&
>> +             !head->mutex);
>>       if (head->rawlock)
>>               WARN_ON_SMP(!raw_spin_is_locked(head->rawlock));
>>       if (head->spinlock)
>>               WARN_ON_SMP(!spin_is_locked(head->spinlock));
>> +     if (head->mutex)
>> +             WARN_ON_SMP(!mutex_is_locked(head->mutex));
>
> Spin locks are NOPs on SMP, but mutexes are not. Are you sure you want
> this as WARN_ON_SMP()?

Doh. Copy-pasty-itis.. Will switch to plain WARN_ON.

--Dima


>
> -- Steve
>
>>       if (!plist_head_empty(head))
>>               plist_check_list(&plist_first(head)->prio_list);
>>       plist_check_list(&head->node_list);
>
>
>
