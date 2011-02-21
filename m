Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab1BUPyu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 10:54:50 -0500
Received: from casper.infradead.org ([85.118.1.10]:42068 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab1BUPyt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 10:54:49 -0500
Subject: Re: [PATCH v2 1/1] headers: fix circular dependency between
 linux/sched.h and linux/wait.h
From: Peter Zijlstra <peterz@infradead.org>
To: David Cohen <dacohen@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, linux-omap@vger.kernel.org,
        linux-media@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
In-Reply-To: <1298299131-17695-2-git-send-email-dacohen@gmail.com>
References: <1298299131-17695-1-git-send-email-dacohen@gmail.com>
	 <1298299131-17695-2-git-send-email-dacohen@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 21 Feb 2011 16:54:37 +0100
Message-ID: <1298303677.24121.1.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-21 at 16:38 +0200, David Cohen wrote:
> Currently sched.h and wait.h have circular dependency between both.
> wait.h defines macros wake_up*() which use macros TASK_* defined by
> sched.h. But as sched.h indirectly includes wait.h, such wait.h header
> file can't include sched.h too. The side effect is when some file
> includes wait.h and tries to use its wake_up*() macros, it's necessary
> to include sched.h also.
> This patch moves all TASK_* macros from linux/sched.h to a new header
> file linux/task_state.h. This way, both sched.h and wait.h can include
> task_state.h and fix the circular dependency. No need to include sched.h
> anymore when wake_up*() macros are used. 

I think Alexey already told you what you done wrong.

Also, I really don't like the task_state.h header, it assumes a lot of
things it doesn't include itself and only works because its using macros
and not inlines at it probably should.


