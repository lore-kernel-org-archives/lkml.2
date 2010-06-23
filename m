Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884Ab0FWAKT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 20:10:19 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49656 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab0FWAKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 20:10:17 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mike McCormack <mikem@ring3k.org>
Subject: Re: [PATCH] proc: Add complete process group list
Cc: kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org, oleg@redhat.com,
       serue@us.ibm.com, jmorris@namei.org, linux-kernel@vger.kernel.org
In-Reply-To: <4C20D1AE.5000205@ring3k.org>
References: <4C20D1AE.5000205@ring3k.org>
Message-Id: <20100623090544.B588.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 23 Jun 2010 09:10:13 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
> 
> Signed-off-by: Mike McCormack <mikem@ring3k.org>

Just dumb question.

Why don't you fix /proc/<pid>/status? Can we share your worry? I haven't review your patch 
carefully yet. but your groups_proc_show() seems don't have heavy weight lock.

note: I'm not against your plan. it's just curiosity.


