Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742Ab1F2Ueq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 16:34:46 -0400
Received: from smtp-out.google.com ([74.125.121.67]:4490 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860Ab1F2Uem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 16:34:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:x-system-of-record;
	b=evkGY7XgvESYdQm81UiVUGGu6KmctMbueqgr0BfwqQZcMsuFqgp9KEC9MNLrgF+5h
	RyVGKZeSNK6ydDEfAgtzA==
MIME-Version: 1.0
In-Reply-To: <m2tyb81jml.fsf@firstfloor.org>
References: <1309376033-32005-1-git-send-email-dima@android.com>
	<m2tyb81jml.fsf@firstfloor.org>
Date: Wed, 29 Jun 2011 13:34:38 -0700
X-Google-Sender-Auth: pm3ijgj9CUfEZ9iwuRmew9mo21E
Message-ID: <CAPz4a6CbzEm3QJZ-5wsaiSH1H9g7tgo7E7-HyRB8Fv5=NfGDRQ@mail.gmail.com>
Subject: Re: [PATCH] plist: add mutex to the blessed lock type for plists
From: Dima Zavin <dima@android.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 1:13 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Dima Zavin <dima@android.com> writes:
>
>> Currently, plist debugging "enforces" that the plist is locked
>> with either a raw_spinlock or a spinlock. The plist data structure
>> is useful in other places, where spinlocks are unnecessary.
>>
>> Extend the plist initializers and debug checks to allow the plist
>> to be protected by a mutex
>
> Seems really ugly and clearly not a godo path.
>
> It's a bit like adding a 11th argument to a function which already has
> 10.
>
> Perhaps better move out the locking completely to wrappers and remove
> the knowledge from the core plist code.

Yeah, it is pretty ugly. Are you proposing adding new plist types like
plist_mutex and plist_spinlock and have the initializers create the
wrapper plist types? And then you would have X types, and X different
functions for add and del? Unless I'm misunderstanding where you
propose putting the wrappers. And then we'll have to audit all the
users to know which flavors are currently being used where (raw vs
spin).

The whole enforcement of locking inside this code is awkward anyway.
We don't enforce locking on rb_trees, or on list_head, etc. Why
plists? The funny part is that the test code in plist.c itself has a
hack to skip the lock check.

--Dima

>
> -Andi
>
>
> --
> ak@linux.intel.com -- Speaking for myself only
>
