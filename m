Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab2DMQjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 12:39:18 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:63901 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab2DMQjP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 12:39:15 -0400
MIME-Version: 1.0
In-Reply-To: <20120413143524.GA3668@elgon.mountain>
References: <20120413143524.GA3668@elgon.mountain>
Date: Fri, 13 Apr 2012 09:39:13 -0700
X-Google-Sender-Auth: Okd4AU7IcPPUYpGZSvP-BC6rSP8
Message-ID: <CAOS58YOSy-acB7Oara9ay1Zeznx0vCSB0Z23F+6KtEKZ56nXmQ@mail.gmail.com>
Subject: Re: [RFC] workqueue: do a sanity check on new work
From: Tejun Heo <tj@kernel.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel@vger.kernel.org, Matt Renzelmann <mjr@cs.wisc.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Dan.

On Fri, Apr 13, 2012 at 7:35 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> There may be a better way to do this.  If someone tries to call
> shedule_work() on a work_struck before doing an INIT_WORK() then we
> hit the BUG_ON(!list_empty(&work->entry)) in __queue_work() and hang.
> Instead of that, we could just print a stack dump and return.

Hmmm... why not just change the BUG_ON() in __queue_work() to "if
(WARN_ON()) return;"?

Thanks.

-- 
tejun
