Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263Ab2DFWXJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 18:23:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37970 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757413Ab2DFWXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 18:23:07 -0400
Date: Fri, 6 Apr 2012 15:23:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Hillf Danton <dhillf@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v2] hugetlb: fix race condition in hugetlb_fault()
Message-Id: <20120406152305.59408e35.akpm@linux-foundation.org>
In-Reply-To: <4F7887A5.3060700@tilera.com>
References: <201203302018.q2UKIFH5020745@farm-0012.internal.tilera.com>
	<CAJd=RBCoLNB+iRX1shKGAwSbE8PsZXyk9e3inPTREcm2kk3nXA@mail.gmail.com>
	<201203311339.q2VDdJMD006254@farm-0012.internal.tilera.com>
	<CAJd=RBBWx7uZcw=_oA06RVunPAGeFcJ7LY=RwFCyB_BreJb_kg@mail.gmail.com>
	<4F7887A5.3060700@tilera.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Apr 2012 12:51:49 -0400
Chris Metcalf <cmetcalf@tilera.com> wrote:

> >> Cc: stable@kernel.org
> > Let Andrew do the stable work, ok?
> 
> Fair point.  I'm used to adding the Cc myself for things I push through the
> arch/tile tree.  This of course does make more sense to go through Andrew,
> so I'll remove it.

No, please do add the stable tag if you think it is needed.  And ensure
that the changelog explains why a backport is needed, by describing
the user-visible effects of the bug.

Tree-owners regularly forget to wonder if a patch should be backported
and we end up failing to backport patches which should have been
backported.  If we have more people flagging backport patches, fewer
patches will fall through the cracks.
