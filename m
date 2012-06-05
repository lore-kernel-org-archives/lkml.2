Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760805Ab2FENV7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 09:21:59 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:47301 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630Ab2FENV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 09:21:57 -0400
X-IronPort-AV: E=Sophos;i="4.75,718,1330905600"; 
   d="scan'208";a="12839992"
Date: Tue, 5 Jun 2012 14:21:50 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "avi@redhat.com" <avi@redhat.com>,
        "raghukt@linux.vnet.ibm.com" <raghukt@linux.vnet.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, "jeremy@goop.org" <jeremy@goop.org>,
        "vatsa@linux.vnet.ibm.com" <vatsa@linux.vnet.ibm.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH v2 6/7] kvm,x86: RCU based table free
In-Reply-To: <878vg1rjts.fsf@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.02.1206051418170.6030@kaball.uk.xensource.com>
References: <20120604050223.4560.2874.stgit@abhimanyu.in.ibm.com> <20120604050822.4560.54662.stgit@abhimanyu.in.ibm.com> <alpine.DEB.2.02.1206051137270.6030@kaball.uk.xensource.com> <87ehpuqam8.fsf@linux.vnet.ibm.com> <alpine.DEB.2.02.1206051232270.6030@kaball.uk.xensource.com>
 <878vg1rjts.fsf@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2012, Nikunj A Dadhania wrote:
> On Tue, 5 Jun 2012 12:58:32 +0100, Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:
> > On Tue, 5 Jun 2012, Nikunj A Dadhania wrote:
> > > On Tue, 5 Jun 2012 11:48:02 +0100, Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:
> > > > 
> > > > I am also interested in introducing HAVE_RCU_TABLE_FREE on x86 for Xen.
> > > > Maybe we can pull our efforts together :-)
> > > > 
> > > > Giving a look at this patch, it doesn't look like it is introducing
> > > > CONFIG_HAVE_RCU_TABLE_FREE anywhere under arch/x86.
> > > > How is the user supposed to set it?
> > > >
> > > I am doing that in the next patch only for KVM-ParavirtTLB flush, as
> > > there is a bug in this implementation that patch [7/7] fixes.
> > > 
> > > Refer following thread for details:
> > > http://mid.gmane.org/1337254086.4281.26.camel@twins
> > > http://mid.gmane.org/1337273959.4281.62.camel@twins
> > 
> > Thanks, somehow I missed the 7/7 patch.
> > 
> > From the Xen POV, your patch is fine because we'll just select
> > PARAVIRT_TLB_FLUSH on CONFIG_XEN (see appended patch for completeness).
> > 
> Selecting ARCH_HW_WALKS_PAGE_TABLE in place of PARAVIRT_TLB_FLUSH should
> suffice.

We would also need to select HAVE_RCU_TABLE_FREE, but it could be a good
idea, not go through PARAVIRT_TLB_FLUSH.

