Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099Ab2CMIW4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 04:22:56 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58858 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab2CMIWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 04:22:53 -0400
Date: Tue, 13 Mar 2012 16:28:18 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
To: Kautuk Consul <consul.kautuk@gmail.com>
Cc: minchan@kernel.org, riel@redhat.com, kosaki.motohiro@jp.fujitsu.com,
        Zheng Liu <wenqing.lz@taobao.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: Fwd: Control page reclaim granularity
Message-ID: <20120313082818.GA5421@gmail.com>
Mail-Followup-To: Kautuk Consul <consul.kautuk@gmail.com>,
	minchan@kernel.org, riel@redhat.com, kosaki.motohiro@jp.fujitsu.com,
	Zheng Liu <wenqing.lz@taobao.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
References: <20120313024818.GA7125@barrios>
 <1331620214-4893-1-git-send-email-wenqing.lz@taobao.com>
 <20120313064832.GA4968@gmail.com>
 <4F5EF563.5000700@openvz.org>
 <CAFPAmTTPxGzrZrW+FR4B_MYDB372HyzdnioO0=CRwx0zQueRSQ@mail.gmail.com>
 <CAFPAmTS-ExDtS7rpJoygc6MCwC10spapyThq7=5cCCGFbjZtqA@mail.gmail.com>
 <20120313080535.GA5243@gmail.com>
 <CAFPAmTSR_Lvsi2+Uid3a9RQK5bBnN3vD_cje6o02f-gBusCJHQ@mail.gmail.com>
 <CAFPAmTQWsq5sjnTVYL5ark6=LSOmOwiRsCr7wqTp=4ymBAUdUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFPAmTQWsq5sjnTVYL5ark6=LSOmOwiRsCr7wqTp=4ymBAUdUQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 01:38:56PM +0530, Kautuk Consul wrote:
> >
> > I agree, but that's not my point.
> >
> > All I'm saying is that we probably don't want to give normal
> > unprivileged usermode apps
> > the capability to set the mapping to AS_UNEVICTABLE as anyone can then
> > write an application
> > that hogs memory without allowing the kernel to free it through memory reclaim.

Yes, I think so.  But it seems that there has some codes that are
possible to be abused.  For example, as I said previously, applications
can mmap a normal data file with PROT_EXEC flag.  Then this file gets a
high priority to keep in memory (commit: 8cab4754).  So my point is that
we cannot control applications how to use these mechanisms.  We just
provide them and let applications to choose how to use them.
:-)

Regards,
Zheng

> 
> Sorry, I mean :
> "... that hogs kernel unmapped page-cache memory without allowing the
> kernel to free it through memory reclaim."
