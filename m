Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759135Ab1IIPHl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 11:07:41 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:25239 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758953Ab1IIPHj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 11:07:39 -0400
MIME-Version: 1.0
Message-ID: <d3d83a5a-ffee-40a3-98be-08694f731b75@default>
Date: Fri, 9 Sep 2011 08:06:10 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, jeremy@goop.org, hughd@google.com,
        ngupta@vflare.org, Konrad Wilk <konrad.wilk@oracle.com>,
        JBeulich@novell.com, Kurt Hackel <kurt.hackel@oracle.com>,
        npiggin@kernel.dk, riel@redhat.com, hannes@cmpxchg.org, matthew@wil.cx,
        Chris Mason <chris.mason@oracle.com>, sjenning@linux.vnet.ibm.com,
        jackdachef@gmail.com, cyclonusj@gmail.com, levinsasha928@gmail.com
Subject: RE: [PATCH V8 3/4] mm: frontswap: add swap hooks and extend
 try_to_unuse
References: <20110829164929.GA27216@ca-server1.us.oracle.com>
 <20110907162703.7f8116b9.akpm@linux-foundation.org>
 <52b5aee3-f424-42ae-830f-d1cf64fa49ef@default
 20110909111445.4821d326.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110909111445.4821d326.kamezawa.hiroyu@jp.fujitsu.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A020205.4E6A2B86.008B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: KAMEZAWA Hiroyuki [mailto:kamezawa.hiroyu@jp.fujitsu.com]
> Subject: Re: [PATCH V8 3/4] mm: frontswap: add swap hooks and extend try_to_unuse
> 
> On Thu, 8 Sep 2011 08:50:11 -0700 (PDT)
> Dan Magenheimer <dan.magenheimer@oracle.com> wrote:
> 
> > > From: Andrew Morton [mailto:akpm@linux-foundation.org]
> > > Sent: Wednesday, September 07, 2011 5:27 PM
> > > To: Dan Magenheimer
> > > Subject: Re: [PATCH V8 3/4] mm: frontswap: add swap hooks and extend try_to_unuse
> > >
> > > On Mon, 29 Aug 2011 09:49:29 -0700
> > > Dan Magenheimer <dan.magenheimer@oracle.com> wrote:
> > >
> > > > -static int try_to_unuse(unsigned int type)
> > > > +int try_to_unuse(unsigned int type, bool frontswap,
> > >
> > > Are patches 2 and 3 in the wrong order?
> >
> > No, they've applied in that order and built after each patch
> > properly for well over a year.  At a minimum, frontswap.h must
> > be created before patch 3of4, though I suppose the introduction
> > of frontswap.c could be after patch 3of4... Note that frontswap.c
> > (which calls try_to_unuse()) is non-functional (and isn't even built)
> > until after patch 4of4 is applied.
> >
> > There is enough interdependency between the four parts
> > that perhaps it should all be a single commit.  I split
> > it up for reviewer's convenience but apparently different
> > reviewers use different review processes than I anticipated. :-}
> >
> 
> IIRC, I said 'please move this change of line to patch 1'.
> 
> Thanks,
> -Kame

Sorry.  To be honest, my patch scripts don't handle this
very well.  I'll try to get it moved in the next rev.

Dan
