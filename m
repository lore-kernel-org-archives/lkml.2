Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255Ab2IPTsF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 15:48:05 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50323 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab2IPTsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 15:48:03 -0400
Message-ID: <50562D06.2040304@gmail.com>
Date: Sun, 16 Sep 2012 21:48:22 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120902 Thunderbird/15.0
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: torvalds@linux-foundation.org, tj@kernel.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        ebiederm@xmission.com, neilb@suse.de, bfields@fieldses.org,
        ejt@redhat.com, snitzer@redhat.com, edumazet@google.com,
        josh@joshtriplett.org, David.Laight@aculab.com, rmallon@gmail.com,
        palves@redhat.com
Subject: Re: [PATCH v5] hashtable: introduce a small and naive hashtable
References: <1347702798-19202-1-git-send-email-levinsasha928@gmail.com> <20120915151428.GA30459@Krystal> <CA+1xoqcO73Q7KOkoPKGCcWL3CfwpoTSXjhqk+JPwooeQdeYRhA@mail.gmail.com> <20120916193348.GA13726@Krystal>
In-Reply-To: <20120916193348.GA13726@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2012 09:33 PM, Mathieu Desnoyers wrote:
>> How would you create a dynamic hashtable with this code to begin with?
> With a var. sized array in a structure, e.g.:
> 
> struct hashtable {
>         size_t len;
>         struct hlist_head t[];
> };
> 
> Then create a hash table allocation function, and turn both hash_empty
> and hash_init into functions that take a struct simplehash pointer as
> parameter. The downside is to consume extra space (especially because
> the array always has a power of 2 len), but the nice thing is that we
> could use this code with a kmalloc'd/vmalloc'd hash table.
> 
> I'm not saying we need to do it (due to the space consumption downside),
> but that we should at least document this limitation.

We've gone through the process of attempting to support dynamic hashtables in
the previous versions of this patch, this turned to complicate the code a lot
beyond simply changing the array of hlist_heads into the struct you proposed, so
it was decided to not support dynamic hashtables at this point at all.

I thought we've agreed that non-dynamically allocated hashtables are widespread
enough to have a dedicated abstraction of their own, and further hashtable
implementations may introduce their own API for that.

We can ofcourse open that for discussion again, but I'd rather not go back and
forth adding support for dynamic hashtables and removing it again.


Thanks,
Sasha
