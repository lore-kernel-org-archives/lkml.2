Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934482Ab0EDWjF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 18:39:05 -0400
Received: from smtp-out.google.com ([74.125.121.35]:20097 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760225Ab0EDWjC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 18:39:02 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=v+aw7VCjqnZhRfuQND8C4yerTjGnbPVSkTwx4e+p6gidVU9UQhBmxPVqICmBRnzzx
	Jfb8kUJfLxJ8MQo9SuyXQ==
MIME-Version: 1.0
In-Reply-To: <30960.1272976896@redhat.com>
References: <20100503225105.GA18897@google.com> <30960.1272976896@redhat.com>
Date: Tue, 4 May 2010 15:38:56 -0700
Message-ID: <y2p8d20b11a1005041538zc2daea6cg2580e8cc14ccf8ed@mail.gmail.com>
Subject: Re: x86 rwsem: up_read() does not check active count in fast path
From: Michel Lespinasse <walken@google.com>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@google.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 4, 2010 at 5:41 AM, David Howells <dhowells@redhat.com> wrote:
> Michel Lespinasse <walken@google.com> wrote:
>
>> Looking at the x86 rwsem code, I have been wondering about the up_read()
>> path.  __rwsem_do_wake() comment mentions that one should check the active
>> count on the way there; however I could not find that check when coming from
>> up_read().
>
> Look in call_rwsem_wake(), which is implemented in assembly in two places in
> the x86 arch:
>
>        arch/x86/lib/rwsem_64.S
>        arch/x86/lib/semaphore_32.S

Gah thanks, I had totally missed that part (I knew about these files
but I had taken these as pure ABI wrappers; I did not notice the one
nugget of interesting logic hiding in there).

BTW, what's the reason for doing this check in call_rwsem_wake ? The
check is entirely redundant in the __up_write() case; and in
__up_read() things might be less confusing if edx was used locally
rather than in a separate function.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
