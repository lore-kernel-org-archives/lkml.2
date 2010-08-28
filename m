Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab0H1VUC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 17:20:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432Ab0H1VUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 17:20:01 -0400
Subject: Re: [PATCH 1/2] fsnotify: fix NULL dereference in send_to_group()
From: Eric Paris <eparis@redhat.com>
To: Csaba Henk <csaba@gluster.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1283023542-1251-1-git-send-email-csaba@gluster.com>
References: <1283023542-1251-1-git-send-email-csaba@gluster.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 28 Aug 2010 17:19:57 -0400
Message-ID: <1283030397.3284.133.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-08-29 at 00:55 +0530, Csaba Henk wrote:
> If fanotify is triggered via a vfsmount mark (so that there is
> no inode mark, group in send_to_group() is set from a structure
> member where the struct pointer is NULL.
> 
> This can be tested with the fanotify utility available from
> http://people.redhat.com/eparis/fanotify/:
> 
>  # fanotify -m / & touch /x

This should be fixed in the pull request I sent to Linus last night.
Sorry you had to track it down as well.  There are a number of other bug
fixes in my tree

http://git.infradead.org/users/eparis/notify.git

There might still be some code duplication which something like 2/2
could clean up but your patch does apply to my devel tree and it has a
logic flaw.  In the case we have both a vfsmount and an inode mark we
need to test:

event_mask & vmark->mask & ~vmark->ignored_mask & ~imark->ignored mask.

You would only ever test one or the other, not both together like that.

Thanks!  Please let me know any other problems you run into!

-Eric

