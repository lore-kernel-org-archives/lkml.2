Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab1FTAAL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 20:00:11 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41873 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954Ab1FTAAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 20:00:08 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 20 Jun 2011 08:53:07 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Ankita Garg <ankita@in.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        svaidy@linux.vnet.ibm.com, thomas.abraham@linaro.org
Subject: Re: [PATCH 00/10] mm: Linux VM Infrastructure to support Memory
 Power Management
Message-Id: <20110620085307.76e16c8f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110617152845.GA13574@in.ibm.com>
References: <1306499498-14263-1-git-send-email-ankita@in.ibm.com>
	<20110613134701.2b23b8d8.kamezawa.hiroyu@jp.fujitsu.com>
	<20110616042044.GA28563@in.ibm.com>
	<20110616181251.caf484b6.kamezawa.hiroyu@jp.fujitsu.com>
	<20110617152845.GA13574@in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jun 2011 20:58:45 +0530
Ankita Garg <ankita@in.ibm.com> wrote:

> Hi,
> 
> On Thu, Jun 16, 2011 at 06:12:51PM +0900, KAMEZAWA Hiroyuki wrote:
> > On Thu, 16 Jun 2011 09:50:44 +0530
> > Ankita Garg <ankita@in.ibm.com> wrote:
> > 
> > > Hi,
> > > 
> > > On Mon, Jun 13, 2011 at 01:47:01PM +0900, KAMEZAWA Hiroyuki wrote:
> > > > On Fri, 27 May 2011 18:01:28 +0530
> > > > Ankita Garg <ankita@in.ibm.com> wrote:
> > > > 
> > > > > Hi,
> > > > > 
> > > > 
> > > > I'm sorry if you've answered already.
> > > > 
> > > > Is memory hotplug is too bad and cannot be enhanced for this purpose ?
> > > > 
> > > > I wonder
> > > >   - make section-size smaller (IIUC, IBM's system has 16MB section size)
> > > > 
> > > >   - add per section statistics
> > > > 
> > > >   - add a kind of balloon driver which does software memory offline
> > > >     (which means making a contiguous chunk of free pages of section_size
> > > >      by page migration) in background with regard to memory usage statistics.
> > > >     If system says "need more memory!", balloon driver can online pages.
> > > > 
> > > > can work for your purpose. It can allow you page isolatation and
> > > > controls in 16MB unit.  If you need whole rework of memory hotplug, I think
> > > > it's better to rewrite memory hotplug, too.
> > > >
> > > 
> > > Interesting idea, but a few issues -
> > > 
> > > - Correctly predicting memory pressure is difficult and thereby being
> > >   able to online the required pages at the right time could be a
> > >   challenge
> > 
> > But it will be required for your purpose, anyway. Isn't it ?
> > 
> > > - Memory hotplug is a heavy operation, so the overhead involved may be
> > >   high
> > 
> > soft-offline of small amount of pages will not very heavy.
> > compaction and cma patches use the same kind of logic.
> > 
> > 
> > > - Powering off memory is just one of the ways in which memory power could
> > >   be saved. The platform can also dynamically transition areas of memory
> > >   into a  content-preserving lower power state if it is not referenced
> > >   for a pre-defined threshold of time. In such a case, we would need a
> > >   mechanism to soft offline the pages - i.e, no new allocations to be
> > >   directed to that memory
> > > 
> > 
> > Hmm, sounds like a similar idea of CleanCache ?
> > 
> > Reusing section is much easier than adding new one.., I think.
> > 
> 
> But sections do not define the granualarity at which memory operations
> are done right ? i.e, allocations/deallocations or reclaim cannot be
> directed to a section or a group of sections ?


Just because there are no users. If you'll be a 1st user, you can
add codes, I think.

Thanks,
-Kame




