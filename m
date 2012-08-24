Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689Ab2HXPLZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 11:11:25 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:33921 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753811Ab2HXPLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 11:11:22 -0400
Message-ID: <1345821066.4950.6.camel@lambeau>
Subject: Re: [PATCH RFC 0/3] Add guest cpu_entitlement reporting
From: Michael Wolf <mjw@linux.vnet.ibm.com>
Reply-To: mjw@linux.vnet.ibm.com
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, peterz@infradead.org,
        mtosatti@redhat.com, mingo@redhat.com, avi@redhat.com
Date: Fri, 24 Aug 2012 10:11:06 -0500
In-Reply-To: <503708C8.2090401@parallels.com>
References: <20120823231346.11681.1502.stgit@lambeau>
	 <503708C8.2090401@parallels.com>
Organization: IBM
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082415-5806-0000-0000-000018C37A49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-08-24 at 08:53 +0400, Glauber Costa wrote:
> On 08/24/2012 03:14 AM, Michael Wolf wrote:
> > This is an RFC regarding the reporting of stealtime.  In the case of
> > where you have a system that is running with partial processors such as
> > KVM the user may see steal time being reported in accounting tools such
> > as top or vmstat.  This can cause confusion for the end user.  To
> > ease the confusion this patch set adds a sysctl interface to set the
> > cpu entitlement.  This is the percentage of cpu that the guest system is
> >  expected to receive.  As long as the steal time is within its expected
> > range it will show up as 0 in /proc/stat.  The user will then see in the
> > accounting tools that they are getting a full utilization of the cpu
> > resources assigned to them.
> > 
> 
> And how is such a knob not confusing?
> 
> Steal time is pretty well defined in meaning and is shown in top for
> ages. I really don't see the point for this.

Currently you can see the steal time but you have no way of knowing if
the cpu utilization you are seeing on the guest is the expected amount.
I decided on making it a knob because a guest could be migrated to
another system and it's entitlement could change because of hardware or 
load differences.  It could simply be a /proc file and report the
current entitlement if needed.   As things are currently implemented I 
don't see how someone knows if the guest is running as expected or
whether there is a problem.

