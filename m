Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab1DSRPH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 13:15:07 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:23301 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753778Ab1DSRPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 13:15:06 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: ckhlbV0VM1kGCQFpB3u3C0JB2WoYSOgS6jTWeHQ1kXDGzt7
 kWV5UgieYQxDdJJRNtsDitkbYp9Xi.lt49KI0FgfaJhUM0fPO4qefnPrwKGo
 Cor39d06Bi2Kbdi4vljbh2d803JrBtWyLzhBwyJJrKXEG_SRjrNrZaDJ0aPf
 dRTV.IzJg4uIQBu12sv.RM3qnWlZu3ZKr5il_3YYOhdHywQk8c4CCw2bN_oa
 VWP51JzxC1A_2ZYPCnAxz.bSP1b58in_DOc8qs2TORcUTIQSyfEKIFA2bzyF
 itEPpwz5qFsCqS7FmZspUfbJt3xZ_PcXtecj.3ZjJe6wZiMCY
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 19 Apr 2011 12:15:01 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v3] mm: make expand_downwards symmetrical to
 expand_upwards
In-Reply-To: <1303233088.3171.26.camel@mulgrave.site>
Message-ID: <alpine.DEB.2.00.1104191213120.17888@router.home>
References: <20110415135144.GE8828@tiehlicka.suse.cz>  <alpine.LSU.2.00.1104171952040.22679@sister.anvils>  <20110418100131.GD8925@tiehlicka.suse.cz>  <20110418135637.5baac204.akpm@linux-foundation.org>  <20110419111004.GE21689@tiehlicka.suse.cz> 
 <1303228009.3171.18.camel@mulgrave.site>  <BANLkTimYrD_Sby_u-fPSwn-RJJyEVavU5w@mail.gmail.com> <1303233088.3171.26.camel@mulgrave.site>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Apr 2011, James Bottomley wrote:

> On Tue, 2011-04-19 at 20:05 +0300, Pekka Enberg wrote:
> > > It seems to be a random intermittent mm crash because the next reboot
> > > crashed with the same trace but after the fsck had completed and the
> > > third came up to the login prompt.
> >
> > Looks like a genuine SLUB problem on parisc. Christoph?
>
> Looking through the slub code, it seems to be making invalid
> assumptions.  All of the node stuff is dependent on CONFIG_NUMA.
> However, we're CONFIG_DISCONTIGMEM (with CONFIG_NUMA not set): on the
> machines I and Dave Anglin have, our physical memory ranges are 0-1GB
> and 64-65GB, so I think slub crashes when we get a page from the high
> memory range ... because it's not expecting a non-zero node number.

Right !NUMA systems only have node 0.
