Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab0JYVfQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 17:35:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481Ab0JYVfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 17:35:14 -0400
Subject: Re: [PATCH 01/11] IMA: use rbtree instead of radix tree for inode
 information cache
From: Eric Paris <eparis@redhat.com>
To: John Stoffel <john@stoffel.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, hch@infradead.org, zohar@us.ibm.com,
        warthog9@kernel.org, david@fromorbit.com, jmorris@namei.org,
        kyle@mcmartin.ca, hpa@zytor.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, mingo@elte.hu, viro@zeniv.linux.org.uk
In-Reply-To: <19653.55494.240658.165153@quad.stoffel.home>
References: <20101025184118.20504.24290.stgit@paris.rdu.redhat.com>
	 <19653.55494.240658.165153@quad.stoffel.home>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Oct 2010 17:34:43 -0400
Message-ID: <1288042483.2655.16.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 15:21 -0400, John Stoffel wrote:
> >>>>> "Eric" == Eric Paris <eparis@redhat.com> writes:

> Which seems to fly in the face of your claim that it needs to be able
> to re-enable itself by tracking open inodes even when disabled.

You're confusing multiple completely unrelated things.  Your confusing
loading an IMA measurement policy vs IMA indicating that it's
measurements may be unreliable.

> As the number of inodes goes up (say during a backup which reads
> them...) won't the size of this cache go up as well, even when IMA is
> disabled?  Why is this overhead even needed?

At the end of this patch the number of integrity structures still has a
1-1 mapping with the number of inodes.  If you look at the entire series
you will see that is not the case.

This patch by itself will cut the memory usage per inode by almost 600
bytes.

