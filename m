Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab0HSUh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 16:37:26 -0400
Received: from smtp-out.google.com ([216.239.44.51]:52320 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab0HSUhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 16:37:25 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Nesn47Ykqt9oPg1nMrryoKVOSPwXIqRzCTDEyrqgc59UJ5oMV/bje8taVMyDcgR41
	BhTZdjZkoqbhMPHcngw+A==
Date: Thu, 19 Aug 2010 13:37:18 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 2/2] oom: fix tasklist_lock leak
In-Reply-To: <20100819195346.5FCA.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1008191336060.18994@chino.kir.corp.google.com>
References: <20100819194707.5FC4.A69D9226@jp.fujitsu.com> <20100819195346.5FCA.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Aug 2010, KOSAKI Motohiro wrote:

> commit 0aad4b3124 (oom: fold __out_of_memory into out_of_memory)
> introduced tasklist_lock leak. Then it caused following obvious
> danger warings and panic.
> 
>     ================================================
>     [ BUG: lock held when returning to user space! ]
>     ------------------------------------------------
>     rsyslogd/1422 is leaving the kernel with locks still held!
>     1 lock held by rsyslogd/1422:
>      #0:  (tasklist_lock){.+.+.+}, at: [<ffffffff810faf64>] out_of_memory+0x164/0x3f0
>     BUG: scheduling while atomic: rsyslogd/1422/0x00000002
>     INFO: lockdep is turned off.
> 
> This patch fixes it.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Acked-by: David Rientjes <rientjes@google.com>
