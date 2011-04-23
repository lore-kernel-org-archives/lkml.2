Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044Ab1DWDzt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 23:55:49 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:34646 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754317Ab1DWDzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 23:55:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=U8uS9PN1wE8uA1BlXoZPEg326xHtlHNxPmC13+F/oaq5VDzuXdlnTEd4kgkU5KJRoespaHKRt+ztn95vtNaun8I4eHADVeWj3mbkZGyDw3wU0z0AVyL/3Nrc6RMVjS9B;
Date: Fri, 22 Apr 2011 20:55:45 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Ben Greear <greearb@candelatech.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Debugging hung tasks?
Message-Id: <20110422205545.19196ada.rdunlap@xenotime.net>
In-Reply-To: <4DB20AA9.4080801@candelatech.com>
References: <4DB20AA9.4080801@candelatech.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Apr 2011 16:09:29 -0700 Ben Greear wrote:

> I am testing lots of NFS traffic against an over-loaded and slow file server.
> 
> I enabled the hung-task detection logic, and it's hitting after 180
> seconds.
> 
> First:  Is there any valid reason to have funky NFS cause a hung task?
> 
> Second: Why doesn't the hung-task panic logic print the stack trace of
>     the hung task?
>     Is this an option that can be enabled?

hung_task.c::check_hung_task() always calls sched_show_task() and
optionally does the panic:

	if (sysctl_hung_task_panic)
		panic("hung_task: blocked tasks");

sched.c::sched_show_task() calls show_stack(), which should be doing what
you are asking for AFAICT.  What kernel version are you using?


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
