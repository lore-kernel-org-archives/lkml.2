Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab2KLXcp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 18:32:45 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:39697 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301Ab2KLXco convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 18:32:44 -0500
MIME-Version: 1.0
Message-ID: <c04bb062-bbce-4980-b2b3-fbbb18e64b66@default>
Date: Mon, 12 Nov 2012 15:32:11 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: KY Srinivasan <kys@microsoft.com>, David Rientjes <rientjes@google.com>,
        Konrad Wilk <konrad.wilk@oracle.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        andi@firstfloor.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        kamezawa.hiroyuki@gmail.com, mhocko@suse.cz, hannes@cmpxchg.org,
        yinghan@google.com
Subject: RE: [PATCH 1/1] mm: Export a function to read vm_committed_as
References: <1352600728-17766-1-git-send-email-kys@microsoft.com>
 <alpine.DEB.2.00.1211101830250.18494@chino.kir.corp.google.com>
 <426367E2313C2449837CD2DE46E7EAF930E35B45@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <alpine.DEB.2.00.1211121349130.23347@chino.kir.corp.google.com>
 <426367E2313C2449837CD2DE46E7EAF930E39FBC@SN2PRD0310MB382.namprd03.prod.outlook.com>
In-Reply-To: <426367E2313C2449837CD2DE46E7EAF930E39FBC@SN2PRD0310MB382.namprd03.prod.outlook.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6661.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: KY Srinivasan [mailto:kys@microsoft.com]
> Sent: Monday, November 12, 2012 3:58 PM
> To: David Rientjes
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> olaf@aepfle.de; apw@canonical.com; andi@firstfloor.org; akpm@linux-foundation.org; linux-mm@kvack.org;
> kamezawa.hiroyuki@gmail.com; mhocko@suse.cz; hannes@cmpxchg.org; yinghan@google.com; Dan Magenheimer
> Subject: RE: [PATCH 1/1] mm: Export a function to read vm_committed_as
> 
> > -----Original Message-----
> > From: David Rientjes [mailto:rientjes@google.com]
> > Sent: Monday, November 12, 2012 4:54 PM
> > To: KY Srinivasan
> > Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> > andi@firstfloor.org; akpm@linux-foundation.org; linux-mm@kvack.org;
> > kamezawa.hiroyuki@gmail.com; mhocko@suse.cz; hannes@cmpxchg.org;
> > yinghan@google.com
> > Subject: RE: [PATCH 1/1] mm: Export a function to read vm_committed_as
> >
> > On Sun, 11 Nov 2012, KY Srinivasan wrote:
> >
> > > Thanks for the prompt response. For the Linux balloon driver for Hyper-V, I
> > need access
> > > to the metric that reflects the system wide memory commitment made by the
> > guest kernel.
> > > In the Hyper-V case, this information is one of the many metrics used to drive
> > the policy engine
> > > on the host. Granted, the interface name I have chosen here could be more
> > generic; how about
> > > read_mem_commit_info(void). I am open to suggestions here.
> > >
> >
> > I would suggest vm_memory_committed() and there shouldn't be a comment
> > describing that this is just a wrapper for modules to read
> > vm_committed_as, that's apparent from the implementation: it should be
> > describing exactly what this value represents and why it is a useful
> > metric (at least in the case that you're concerned about).
> 
> Will do; thanks.
> >
> > > With regards to making changes to the Xen self ballooning code, I would like to
> > separate that patch
> > > from the patch that implements the exported mechanism to access the
> > memory commitment information.
> >
> > Why?  Is xen using it for a different inference?
> 
> I think it is good to separate these patches. Dan (copied here) wrote the code for the
> Xen self balloon driver. If it is ok with him I can submit the patch for Xen as well.

Hi KY --

If I understand correctly, this would be only a cosmetic (function renaming) change
to the Xen selfballooning code.  If so, then I will be happy to Ack when I
see the patch.  However, Konrad (konrad.wilk@oracle.com) is the maintainer
for all Xen code so you should ask him... and (from previous painful experience)
it can be difficult to sync even very simple interdependent changes going through
different maintainers without breaking linux-next.  So I can't offer any
help with that process, only commiseration. :-(

Dan
