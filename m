Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516Ab0HYAJc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 20:09:32 -0400
Received: from smtp-out.google.com ([74.125.121.35]:14552 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab0HYAJa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 20:09:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=chC1QpicMyNowyNv35eREKzhQ+fPqyOp7lIDlNMeZfZpPrz+h63SnHvSGHMeE+OYXf
         C4Q71gURvGTBDCPW4YRw==
MIME-Version: 1.0
In-Reply-To: <20100820185816.1dbcd53a.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100820185552.426ff12e.kamezawa.hiroyu@jp.fujitsu.com>
	<20100820185816.1dbcd53a.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 24 Aug 2010 17:09:25 -0700
Message-ID: <AANLkTi=imK6Px+JrdVupg2V3jtN9pgmEdWv=+aB1XKLY@mail.gmail.com>
Subject: Re: [PATCH 1/5] cgroup: ID notification call back
From: Paul Menage <menage@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        gthelen@google.com, m-ikeda@ds.jp.nec.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kamezawa.hiroyuki@gmail.com,
        "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 2:58 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> CC'ed to Paul Menage and Li Zefan.
> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> When cgroup subsystem use ID (ss->use_id==1), each css's ID is assigned
> after successful call of ->create(). css_ID is tightly coupled with
> css struct itself but it is allocated by ->create() call, IOW,
> per-subsystem special allocations.
>
> To know css_id before creation, this patch adds id_attached() callback.
> after css_ID allocation. This will be used by memory cgroup's quick lookup
> routine.
>
> Maybe you can think of other implementations as
>        - pass ID to ->create()
>        or
>        - add post_create()
>        etc...
> But when considering dirtiness of codes, this straightforward patch seems
> good to me. If someone wants post_create(), this patch can be replaced.

I think I'd prefer the approach where any necessary css_ids are
allocated prior to calling any create methods (which gives the
additional advantage of removing the need to roll back partial
creation of a cgroup in the event of alloc_css_id() failing) and then
passed in to the create() method. The main cgroups framework would
still be responsible for actually filling the css->id field with the
allocated id.

Paul
