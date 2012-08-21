Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758629Ab2HUVcO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 17:32:14 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:62859 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757430Ab2HUVcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 17:32:10 -0400
Subject: Re: [PATCH] task_work: add a scheduling point in task_work_run()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ". James Morris" <jmorris@namei.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
In-Reply-To: <1345581470.2815.14.camel@falcor.watson.ibm.com>
References: <1341014197.2342.7.camel@falcor.watson.ibm.com>
	 <20120630050238.GZ14083@ZenIV.linux.org.uk>
	 <1341172202.2556.13.camel@falcor>
	 <20120701205722.GD22927@ZenIV.linux.org.uk>
	 <1341193591.2249.3.camel@falcor>
	 <20120702034310.GE22927@ZenIV.linux.org.uk>
	 <20120702051155.GF22927@ZenIV.linux.org.uk>
	 <1341229790.2350.1.camel@falcor>
	 <20120702120259.GG22927@ZenIV.linux.org.uk>
	 <1341234091.2166.5.camel@falcor>
	 <20120702133329.GH22927@ZenIV.linux.org.uk>
	 <1341240603.2086.1.camel@falcor>
	 <1345554314.5158.490.camel@edumazet-glaptop>
	 <1345581470.2815.14.camel@falcor.watson.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Aug 2012 23:32:05 +0200
Message-ID: <1345584725.5158.550.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-21 at 16:37 -0400, Mimi Zohar wrote:

> We're here, because fput() called schedule_work() to delay the last
> fput().  The execution needs to take place before the syscall returns to
> userspace.  Need to read __schedule()...  Do you know if cond_resched()
> can guarantee that it will be executed before the return to userspace? 

Some clarifications : 

- fput() does not call schedule_work() in this case but task_work_add()

- cond_resched() wont return to userspace.


