Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab0FVWi6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 18:38:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40097 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751528Ab0FVWi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 18:38:57 -0400
Date: Tue, 22 Jun 2010 15:37:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike McCormack <mikem@ring3k.org>
Cc: oleg@redhat.com, kosaki.motohiro@jp.fujitsu.com, serue@us.ibm.com,
       jmorris@namei.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: Add complete process group list
Message-Id: <20100622153757.dcb6bda9.akpm@linux-foundation.org>
In-Reply-To: <4C20D1AE.5000205@ring3k.org>
References: <4C20D1AE.5000205@ring3k.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jun 2010 00:07:26 +0900
Mike McCormack <mikem@ring3k.org> wrote:

> If a process is in more than NGROUPS_SMALL (32) groups, it's not possible
>  for any other user space process to determine the list of groups it is
>  in using /proc/<pid>/status.
> 
> Increasing the list of groups listed by /proc/<pid>/status would lead to
>  very long lines that file, and possible misbehavior of userspace programs
>  that parse /proc/<pid>/status, so instead I have opted to create a new
>  file /proc/<pid>/groups, which contains the list of supplementary groups
>  for each pid.
> 
> The new file /proc/<pid>/groups consists of a single group id per line,
>  with each line being 11 characters long.  This should be enough space
>  for 16bit or 32bit group ids.
> 
> This feature might be useful for a server listening on a unix domain pipe
>  to determine the list of groups that a client process is in from its pid.

"might be"?

It would be useful to hear a bit more about usage scenarios, why this
is needed, etc - some hard info which would justify permanent extension
of the kernel->userspace API.  How does this get used, why is it
needed, what are the alternatives, etc.

I don't recall having heard of anyone using the groups fields in
/proc/pid/status before.
