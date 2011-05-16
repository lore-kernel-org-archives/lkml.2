Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150Ab1EPMqa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 08:46:30 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49877 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab1EPMq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 08:46:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=E7VJmlKjHvzYQq8SiQpt4A8ItDErJI6EtnlQKcLIz3rrxm8HDE7cbOHZ3Am5xw7Qsl
         KGbMZA8ctvnuLmGbf6s/n48A4zk0qKeVA7VG8faZEiiMn1Q6an92IaPhQbdrP7PkXdrm
         +n6MzKpanmPhyqWJ0rfGWncQ5tPLRSyXqngc0=
Date: Mon, 16 May 2011 14:46:25 +0200
From: Tejun Heo <tj@kernel.org>
To: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: waitpid(WNOHANG) should report SIGCHLD-notified signals  [Re:
 [PATCH 09/11] job control: reorganize wait_task_stopped()]
Message-ID: <20110516124625.GV23665@htj.dyndns.org>
References: <20110512160253.GK1030@htj.dyndns.org>
 <20110512172506.GA23033@redhat.com>
 <20110512173228.GO1030@htj.dyndns.org>
 <20110515144017.GC31855@host1.jankratochvil.net>
 <20110515164705.GI23665@htj.dyndns.org>
 <20110515174722.GA26361@host1.jankratochvil.net>
 <20110516091318.GQ23665@htj.dyndns.org>
 <20110516121116.GB10469@host1.jankratochvil.net>
 <20110516122756.GT23665@htj.dyndns.org>
 <20110516123930.GA11933@host1.jankratochvil.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516123930.GA11933@host1.jankratochvil.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, May 16, 2011 at 02:39:30PM +0200, Jan Kratochvil wrote:
> > The above wouldn't be linux kernel's top design concerns, right?
> 
> They are - as without threads one needs reliable WNOHANG - while which you say
> it is not reliable.

As I wrote before, I think it's reliable for ptrace.  The problematic
ones are transitions between continued and stopped and running and I
don't think it would affect ptrace.

> > It's not like new interface is gonna break that, but I think it's gonna be
> > more fragile.  Well, it shouldn't be worse than now.
> 
> BTW I really do not think this WNOHANG issue is anyhow related to this whole
> discussion.

Probably not but I've seen gdb going out of sync with the expected
state of the tracee.  Dunno whether it was kernel bug or gdb bug but
it seemed pretty fragile and adding group stop notifications might
make it a bit more difficult.  I don't know.  It was just my five
cents.  Feel free to ignore.

Thanks.

-- 
tejun
