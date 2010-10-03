Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392Ab0JCSKt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 14:10:49 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:43581 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754037Ab0JCSKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 14:10:48 -0400
Date: Sun, 3 Oct 2010 23:40:44 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Steve Magnani <steve@digidescorp.com>
Cc: David Howells <dhowells@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH][RESEND] nommu: add anonymous page memcg accounting
Message-ID: <20101003181044.GG7896@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1285929315-2856-1-git-send-email-steve@digidescorp.com>
 <5206.1285943095@redhat.com>
 <WC20101001143139.810346@digidescorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <WC20101001143139.810346@digidescorp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steve Magnani <steve@digidescorp.com> [2010-10-01 09:31:39]:

> David Howells <dhowells@redhat.com> wrote:
> > 
> > Do we really need to do memcg accounting in NOMMU mode?  Might it be
> > better to just apply the attached patch instead?
> > 
> > David
> > ---
> > diff --git a/init/Kconfig b/init/Kconfig
> > index 2de5b1c..aecff10 100644
> > --- a/init/Kconfig
> > +++ b/init/Kconfig
> > @@ -555,7 +555,7 @@ config RESOURCE_COUNTERS
> >  
> >  config CGROUP_MEM_RES_CTLR
> >  	bool "Memory Resource Controller for Control Groups"
> > -	depends on CGROUPS && RESOURCE_COUNTERS
> > +	depends on CGROUPS && RESOURCE_COUNTERS && MMU
> >  	select MM_OWNER
> >  	help
> >  	  Provides a memory resource controller that manages both anonymous
> 
> If anything I think nommu is one of the better applications of memcg. Since nommu typically == 
> embedded, being able to put potential memory pigs in a sandbox so they can't destabilize the 
> system is a Good Thing. That was my motivation for doing this in the first place and it works 
> quite well.

Good to know, but I want to point out that I never explictly tested it
for NOMMU when I created memcg. I thought like the rest that not
having reclaim capability would limit memcg usage in the NOMMU world.


-- 
	Three Cheers,
	Balbir
