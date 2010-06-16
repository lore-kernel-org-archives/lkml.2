Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758316Ab0FPAzY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 20:55:24 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47801 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757681Ab0FPAzW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 20:55:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=K+uEy1hcfUDaHg+RRWEqUkhIWeF9PgBgrH9133PBw6jSkGCKNHrgV731+sGDOU7yfa
         TNhyn1xW4/hs85qV2KMY0SMpancZgHYl8757N0fzAVg3pEg4vkUpzTXmRPpEyvq/rvPs
         63ru+upzLZiIMopgKQTqjDK2d5frtOf/8DXZI=
MIME-Version: 1.0
In-Reply-To: <AANLkTilfw_rXQ4P1jRnrOtun2c9kAq6zNEQHxTF124_x@mail.gmail.com>
References: <AANLkTilfw_rXQ4P1jRnrOtun2c9kAq6zNEQHxTF124_x@mail.gmail.com>
Date: Tue, 15 Jun 2010 20:55:20 -0400
Message-ID: <AANLkTilOK580U03orIO6jcMvzrHeNsykLSMkdlw0hZLI@mail.gmail.com>
Subject: Re: Does the kernel page the CFS's red-black tree nodes?
From: Richard Yao <shiningarcanine@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Linus Torvalds et all:

I read a recently published article on the ACM website, which
discusses the effect virtual memory pressure has on certain algorithms
and explains that data structures need to be designed in such a way
that they minimize such effects:

http://queue.acm.org/detail.cfm?id=1814327

The author observed slow-downs in an algorithm that ignored virtual
memory upon the incidence of page faults. The basic idea I took from
it is that people should use B-Heaps instead of Binary Heaps and
B-Trees instead of Binary Trees for optimal performance on modern
systems that use virtual memory. Today, it occurred to me that the
kernel's completely fair scheduler could be susceptible this sort of
slow-down, provided that the kernel pages its red-black tree nodes to
swap, so I thought I would ask here if this is the case.

With that said, does the kernel page the CFS's red-black tree nodes to
swap? If it does, it might be a good idea to reimplement the CFS'
Red-Black trees in B-Trees, which would minimize slow-downs from
vm-pressure and also have the additional benefit of minimizing cache
misses caused by tree traversal.

This is my first post to the kernel mailing list. The FAQ says that I
should indicate that I "wish to be personally CC'ed the
answers/comments posted to the list in response" to my posting, so
this sentence is my indication that I "wish to be personally CC'ed the
answers/comments posted to the list".

Yours truly,
Richard Yao
