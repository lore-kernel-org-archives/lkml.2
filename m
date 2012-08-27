Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab2H0Pv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 11:51:26 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:40855 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab2H0PvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 11:51:24 -0400
Message-ID: <1346082646.8623.8.camel@lambeau>
Subject: Re: [PATCH RFC 0/3] Add guest cpu_entitlement reporting
From: Michael Wolf <mjw@linux.vnet.ibm.com>
Reply-To: mjw@linux.vnet.ibm.com
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, peterz@infradead.org,
        mtosatti@redhat.com, mingo@redhat.com, avi@redhat.com
Date: Mon, 27 Aug 2012 10:50:46 -0500
In-Reply-To: <50396173.4020005@parallels.com>
References: <20120823231346.11681.1502.stgit@lambeau>
	 <503708C8.2090401@parallels.com> <1345821066.4950.6.camel@lambeau>
	 <50396173.4020005@parallels.com>
Organization: IBM
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082715-1780-0000-0000-000008C47C75
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000293; HX=3.00000196; KW=3.00000007;
 PH=3.00000001; SC=3.00000007; SDB=6.00168973; UDB=6.00038294; UTC=2012-08-27
 15:51:23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-08-25 at 19:36 -0400, Glauber Costa wrote:
> On 08/24/2012 11:11 AM, Michael Wolf wrote:
> > On Fri, 2012-08-24 at 08:53 +0400, Glauber Costa wrote:
> >> On 08/24/2012 03:14 AM, Michael Wolf wrote:
> >>> This is an RFC regarding the reporting of stealtime.  In the case of
> >>> where you have a system that is running with partial processors such as
> >>> KVM the user may see steal time being reported in accounting tools such
> >>> as top or vmstat.  This can cause confusion for the end user.  To
> >>> ease the confusion this patch set adds a sysctl interface to set the
> >>> cpu entitlement.  This is the percentage of cpu that the guest system is
> >>>  expected to receive.  As long as the steal time is within its expected
> >>> range it will show up as 0 in /proc/stat.  The user will then see in the
> >>> accounting tools that they are getting a full utilization of the cpu
> >>> resources assigned to them.
> >>>
> >>
> >> And how is such a knob not confusing?
> >>
> >> Steal time is pretty well defined in meaning and is shown in top for
> >> ages. I really don't see the point for this.
> > 
> > Currently you can see the steal time but you have no way of knowing if
> > the cpu utilization you are seeing on the guest is the expected amount.
> > I decided on making it a knob because a guest could be migrated to
> > another system and it's entitlement could change because of hardware or 
> > load differences.  It could simply be a /proc file and report the
> > current entitlement if needed.   As things are currently implemented I 
> > don't see how someone knows if the guest is running as expected or
> > whether there is a problem.
> > 
> 
> Turning off steal time display won't get even close to displaying the
> information you want. What you probably want is a guest-visible way to
> say how many miliseconds you are expected to run each second. Right?

It is not clear to me how knowing how many milliseconds you are
expecting to run will help the user.  Currently the users will run top
to see how well the guest is running.  If they see _any_ steal time some
users think they are not getting the full use of their processor
entitlement.

Maybe I'm missing what you are proposing, but even if you knew the
milliseconds that you were expecting for your processor you would have
to adjust the top output in your head so to speak.  You would see the
utilization and then say 'ok that matches the number of milliseconds I
expected to run..."   If we take away the steal time (as long as it is
equal to or less than the expected amount of steal time) then the user
running top will see the 100% utilization.



