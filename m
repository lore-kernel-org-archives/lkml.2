Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759682Ab2CMIgc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 04:36:32 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37113 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294Ab2CMIg3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 04:36:29 -0400
MIME-Version: 1.0
In-Reply-To: <20120313082818.GA5421@gmail.com>
References: <20120313024818.GA7125@barrios>
	<1331620214-4893-1-git-send-email-wenqing.lz@taobao.com>
	<20120313064832.GA4968@gmail.com>
	<4F5EF563.5000700@openvz.org>
	<CAFPAmTTPxGzrZrW+FR4B_MYDB372HyzdnioO0=CRwx0zQueRSQ@mail.gmail.com>
	<CAFPAmTS-ExDtS7rpJoygc6MCwC10spapyThq7=5cCCGFbjZtqA@mail.gmail.com>
	<20120313080535.GA5243@gmail.com>
	<CAFPAmTSR_Lvsi2+Uid3a9RQK5bBnN3vD_cje6o02f-gBusCJHQ@mail.gmail.com>
	<CAFPAmTQWsq5sjnTVYL5ark6=LSOmOwiRsCr7wqTp=4ymBAUdUQ@mail.gmail.com>
	<20120313082818.GA5421@gmail.com>
Date: Tue, 13 Mar 2012 14:06:28 +0530
Message-ID: <CAFPAmTQ-7GiDfQkU5wKFfR5UVacrN-HrP5h_yNmAdK8tRO-xTA@mail.gmail.com>
Subject: Re: Fwd: Control page reclaim granularity
From: Kautuk Consul <consul.kautuk@gmail.com>
To: minchan@kernel.org, riel@redhat.com, kosaki.motohiro@jp.fujitsu.com,
        Zheng Liu <wenqing.lz@taobao.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Yes, I think so.  But it seems that there has some codes that are
> possible to be abused.  For example, as I said previously, applications
> can mmap a normal data file with PROT_EXEC flag.  Then this file gets a
> high priority to keep in memory (commit: 8cab4754).  So my point is that
> we cannot control applications how to use these mechanisms.  We just
> provide them and let applications to choose how to use them.
> :-)
>

That's true, but we are not talking about higher priority here,
because in extreme memory reclaim case
even PROT_EXEC pages will be reclaimed.

But I understand your point. It might be okay to have this for all
privileges applications.

The only problem that might happen might be in OOM because we will
have to include selection points for
these page-cache pages (proportionately) while finding the most
expensive process to kill.
( I'm talking about the page-cache pages which are not mapped to
usermode page-tables at all. )

If any usermode application reads in an extremely huge file, whose
inode has been set to AS_UNEVICTABLE,
we might want to kill those applications that read in those
pages(proportionately) so that the guilty application
can be killed.
