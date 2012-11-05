Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab2KEUSc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 15:18:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753394Ab2KEUS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 15:18:29 -0500
Date: Mon, 5 Nov 2012 15:18:25 -0500
From: Aristeu Rozanski <aris@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH] coredump: run the coredump helper using the same
 namespace as the dead process
Message-ID: <20121105201825.GM14789@redhat.com>
References: <20121105163810.GJ14789@redhat.com>
 <87r4o7alod.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r4o7alod.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2012 at 11:34:26AM -0800, Eric W. Biederman wrote:
> I would argue that you very much need to define what it means to have a
> per container core dump at the same time as you argue this.
> 
> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> Running in a namespace different than whoever set the core dump
> pattern/helper makes core dump helpers much more attackable.  With this
> patch and a little creativity I expect I can get root to write to
> whatever file I would like.  Since I also control the content of what is
> going into that file.... This design seems emintely exploitable.

Understood. Indeed this is bad design. Having it tied to the mount
namespace of the process setting the pattern/helper, therefore any
process crashing under the same mount namespace would use the same
pattern/helper? 

> Furthermore not all namespaces are pointed at by nsproxy, so even
> for it's original design this patch is buggy.

is it userns? I just assumed it wasn't there yet because it's being
worked on.

> I do think supporting a per container coredump setting makes a lot of
> sense but I do not think this patch is the way to do it.

I understand, thanks for the time reviewing it.


-- 
Aristeu

