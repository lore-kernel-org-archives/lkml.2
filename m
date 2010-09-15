Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab0IOOqw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 10:46:52 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45190 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208Ab0IOOqu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 10:46:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=B3Yti/9InRJdwela5ZX2y9+tA0xqRFEFilmHSTCC7IJXWHYsGj3QIiwcNgjhiD8fy7
         YmIK5d0o3fwol3qd+Jf1clwnj/6QL8z3m/zRVVZ/p15/c7Mi9tvq0GjMRB3ulfb8SpXx
         8VZjfB7S3UtQNIFG2vIGM+kkj9XjdJ/UcO0pg=
MIME-Version: 1.0
In-Reply-To: <4C90A6C7.9050607@redhat.com>
References: <20100915104855.41de3ebf@lilo> <4C90A6C7.9050607@redhat.com>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Wed, 15 Sep 2010 23:46:09 +0900
Message-ID: <AANLkTi=rmUUPCm212Sju-wW==5cT4eqqU+FEP_hX-Z_y@mail.gmail.com>
Subject: Re: [RFC][PATCH] Cross Memory Attach
To: Avi Kivity <avi@redhat.com>
Cc: Christopher Yeoh <cyeoh@au1.ibm.com>, linux-kernel@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 15, 2010 at 19:58, Avi Kivity <avi@redhat.com> wrote:

> Instead of those two syscalls, how about a vmfd(pid_t pid, ulong start,
> ulong len) system call which returns an file descriptor that represents a
> portion of the process address space.  You can then use preadv() and
> pwritev() to copy memory, and io_submit(IO_CMD_PREADV) and
> io_submit(IO_CMD_PWRITEV) for asynchronous variants (especially useful with
> a dma engine, since that adds latency).
>
> With some care (and use of mmu_notifiers) you can even mmap() your vmfd and
> access remote process memory directly.

Rather than introducing a new vmfd() API for this, why not just add
implementations for these more efficient operations to the existing
/proc/$pid/mem interface?
