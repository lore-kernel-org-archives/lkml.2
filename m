Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab0CVX5M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 19:57:12 -0400
Received: from smtp-out.google.com ([74.125.121.35]:40451 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab0CVX5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 19:57:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=QyPBlj8D4RBhINNf14WFK3XvaJKHBzlg2mMmgTZlQM/gMTzaHaDFaDvGCdfWtlEkQ
	91sd9UvZFkbAiTY31bOPg==
MIME-Version: 1.0
In-Reply-To: <20100322102247.GA8363@redhat.com>
References: <200908202114.n7KLEN5H026646@imap1.linux-foundation.org>
	 <20090821102611.GA2611@redhat.com> <20090821104528.GA3487@redhat.com>
	 <6599ad830908211637w6c9fd3a7tbe41bc106ada03d7@mail.gmail.com>
	 <20090822130952.GA4240@redhat.com> <20100105185330.GA17545@redhat.com>
	 <20100117204833.GA29596@unix38.andrew.cmu.edu>
	 <20100322102247.GA8363@redhat.com>
Date: Mon, 22 Mar 2010 16:57:05 -0700
Message-ID: <6599ad831003221657q61e20286q49b2ef39b3999b05@mail.gmail.com>
Subject: Re: [RFC] [PATCH 1/2] cgroups: read-write lock CLONE_THREAD forking 
	per threadgroup
From: Paul Menage <menage@google.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ben Blum <bblum@andrew.cmu.edu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, ebiederm@xmission.com,
       lizf@cn.fujitsu.com, matthltc@us.ibm.com,
       containers@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 3:22 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> Please use ->signal instead. By the lucky coincidence the lifetime rules
> for (greatly misnamed) signal_struct were changed recently in -mm.
>
> With the recent changes, it is always safe to use task->signal. It can't
> be changed, can't go away, no need to bump the counter, no races, etc.
>
> What do you think?

If signal_struct is much simpler to reason about, then using it seems
like a good idea.

Paul
