Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab0KDFJG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 01:09:06 -0400
Received: from smtp-out.google.com ([216.239.44.51]:58021 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab0KDFJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 01:09:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=C+iVjlMBgpCTnfez3ef5cqB1b8Ye2F1lo3fZQ/Etpvg7PDSxBbJgfpcCswKV+YSUXi
         lu3k+0K44Kinug+mBoHA==
Date: Wed, 3 Nov 2010 22:08:56 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Figo.zhang" <zhangtianfei@leadcoretech.com>
cc: figo zhang <figo1802@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@osdl.org>
Subject: Re: Re:[PATCH v2]oom-kill: CAP_SYS_RESOURCE should get bonus
In-Reply-To: <1288845730.2102.11.camel@myhost>
Message-ID: <alpine.DEB.2.00.1011032203470.10054@chino.kir.corp.google.com>
References: <1288662213.10103.2.camel@localhost.localdomain> <1288827804.2725.0.camel@localhost.localdomain> <alpine.DEB.2.00.1011031646110.7830@chino.kir.corp.google.com> <AANLkTimjfmLzr_9+Sf4gk0xGkFjffQ1VcCnwmCXA88R8@mail.gmail.com> <1288834737.2124.11.camel@myhost>
 <alpine.DEB.2.00.1011031847450.21550@chino.kir.corp.google.com> <1288836733.2124.18.camel@myhost> <alpine.DEB.2.00.1011031952110.28251@chino.kir.corp.google.com> <1288845730.2102.11.camel@myhost>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Nov 2010, Figo.zhang wrote:

> CAP_SYS_RESOURCE == 1 means without resource limits just like a
> superuser,
> CAP_SYS_RESOURCE == 0 means hold resource limits, like normal user,
> right?
> 

Yes.

> a new lower oom_score_adj will protect the process, right?
> 

Yes.

> Tasks without CAP_SYS_RESOURCE, means that it is not a superuser, why
> user canot protect it by oom_score_adj?
> 

Because, as I said, it would be trivial for a user program to deplete all 
memory (either intentionally or unintentioally) and cause every other task 
on the system to be oom killed as a result.  That's an undesired result of 
a blatently obvious DoS.

> like i want to protect my program such as gnome-terminal which is
> without CAP_SYS_RESOURCE (have resource limits), 
> 
> [figo@myhost ~]$ ps -ax | grep gnome-ter
> Warning: bad ps syntax, perhaps a bogus '-'? See
> http://procps.sf.net/faq.html
>  2280 ?        Sl     0:01 gnome-terminal
>  8839 pts/0    S+     0:00 grep gnome-ter
> [figo@myhost ~]$ cat /proc/2280/oom_adj 
> 3
> [figo@myhost ~]$ echo -17 >  /proc/2280/oom_adj 
> bash: echo: write error: Permission denied
> [figo@myhost ~]$ 
> 
> so, i canot protect my program.
> 

If this is your system, you can either give yourself CAP_SYS_RESOURCE or 
do it through the superuser.  This isn't exactly new, it's been the case 
for the past four years.

I'm still struggling to find out the problem that you're trying to address 
with your various patches, perhaps because you haven't said what it is.
