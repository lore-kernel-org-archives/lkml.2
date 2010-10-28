Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759467Ab0J1Xdv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 19:33:51 -0400
Received: from smtp-out.google.com ([74.125.121.35]:4303 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759268Ab0J1Xdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 19:33:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=SqCvsIQ1aeDhpCxoAuBzYqmlfuNREzbDDI0actNIhk51WV/O+xSErKjHnxPuKOi0kY
         Y877PpwvUetjcEkykWNg==
MIME-Version: 1.0
In-Reply-To: <4CC4D84C.5000705@cn.fujitsu.com>
References: <4CC146A4.9090505@cn.fujitsu.com>
	<1287751801.15336.35.camel@twins>
	<4CC4D84C.5000705@cn.fujitsu.com>
Date: Thu, 28 Oct 2010 16:33:41 -0700
Message-ID: <AANLkTin9Lzvqw_Dz6b6mywFAOLfoK0P_EfHN9Nchec9j@mail.gmail.com>
Subject: Re: [PATCH 0/7] cgroups: Allow to bind/unbind subsystems to/from
 non-trival hierarchy
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "akpm >> Andrew Morton" <akpm@linux-foundation.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        containers@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 24, 2010 at 6:07 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>
> Paul had a patch to allow some subsystems to be added to multi-hierarchies,
> which may help.

I more or less dropped it since I couldn't see a big use for it - all
the examples I had were more easily implemented as basic cgroup
control files (and hence available in all hierarchies automatically)

> But it forbids accessing t->cgroups, which makes this
> feature of limited use.

Not exactly - it meant that you couldn't do a fast dereference via
t->cgroups to get to your cgroup_subsys_state, since there was no
longer a unique css for each task for that subsystem - there would be
one per mounted instance of the subsystem. Instead it became necessary
to follow a chain of pointers to find the appropriate css for the
hierarchy in question.

In general this also means that it's harder for the multi-bound
subsystem have any real-world meaning - it's mostly useful for
stateless subsystems, or ones where the cgroup_subsys_state contents
have no direct connection with machine-wide data.

Paul
