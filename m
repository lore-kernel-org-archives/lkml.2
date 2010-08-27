Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071Ab0H0Rta (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 13:49:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276Ab0H0Rt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 13:49:27 -0400
Subject: Re: [PATCH] audit: speedup for syscalls when auditing is disabled
From: Eric Paris <eparis@redhat.com>
To: Anton Blanchard <anton@samba.org>
Cc: Michael Neuling <mikey@neuling.org>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        sgrubb@redhat.com
In-Reply-To: <20100826033456.GB17882@kryten>
References: <29151.1282270393@neuling.org>
	 <1282586177.2681.43.camel@localhost.localdomain>
	 <20887.1282615880@neuling.org>
	 <1282621410.26616.406.camel@localhost.localdomain>
	 <15180.1282705886@neuling.org>
	 <1282737584.13142.153.camel@localhost.localdomain>
	 <20100826033456.GB17882@kryten>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Aug 2010 13:49:15 -0400
Message-ID: <1282931355.3284.84.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-26 at 13:34 +1000, Anton Blanchard wrote:
> Hi Eric,
> 
> Here's another approach Mikey and I were discussing. We allocate the
> tsk->audit_context as before, but we avoid setting the TIF_SYSCALL_AUDIT until
> the first rule gets added.
> 
> We could look at clearing the flag when the rules go back to zero, but this
> simple patch covers the most common case I think.

It just dawned on me where we are going to have problems.  We have
things other than syscall filter rules that can cause us to want the
collected audit info.  Namely SELinux (or other LSM) denials.

Crap.

So the change in audit_alloc() should probably be conditionalized on
more than just audit_n_rules().  Not exactly sure what that is though.  

It might also make our syscall entry/exit speedups not as great of an
idea as I thought.  I need to look for other audit users to see how
these things are oging to affect them   :(

-Eric

