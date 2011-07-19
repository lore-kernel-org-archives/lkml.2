Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab1GSVAp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 17:00:45 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:32287 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab1GSVAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 17:00:44 -0400
Content-Type: text/plain; charset=UTF-8
From: Chris Mason <chris.mason@oracle.com>
To: paulmck <paulmck@linux.vnet.ibm.com>
Cc: "=?utf-8?q?Jan_H._Sch=C3=B6nherr?=" <schnhrr@cs.tu-berlin.de>,
        Dipankar Sarma <dipankar@in.ibm.com>, Corey Minyard <minyard@acm.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu: Fix wrong check in list_splice_init_rcu()
In-reply-to: <20110719202752.GO2357@linux.vnet.ibm.com>
References: <1311102626-14831-1-git-send-email-schnhrr@cs.tu-berlin.de> <20110719202752.GO2357@linux.vnet.ibm.com>
Date: Tue, 19 Jul 2011 17:00:11 -0400
Message-Id: <1311109131-sup-1906@shiny>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4E25F066.0054:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Paul E. McKenney's message of 2011-07-19 16:27:52 -0400:
> On Tue, Jul 19, 2011 at 09:10:26PM +0200, Jan H. Schönherr wrote:
> > Hi.
> > 
> > If I don't miss something obvious, the following patch would
> > be a good idea.
> > 
> > There are currently two users of list_splice_init_rcu(): IPMI and btrfs.
> > For these, list_splice_init_rcu() is currently a NOP.
> > 
> > If I interpret the code correctly, this fixes a memory leak for
> > IPMI and something probably worse for btrfs.
> > 
> > The call from within btrfs was introduced only after v2.6.39 with commit
> > 1f78160 ("Btrfs: using rcu lock in the reader side of devices list") by
> > converting a list_splice_init() call.
> > 
> > Therefore, this patch might be a candidate for v3.0.
> 
> Excellent catch!  This one has been around for some time, so my guess
> is that it goes into v3.1.  Either way, I have queued it, thank you!

A good catch and thanks for the cc.  The btrfs code in question here has
some other problems, and it's fine if this patch doesn't make 3.0.

-chris
