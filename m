Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab2H0UXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 16:23:17 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:55857 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754508Ab2H0UXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 16:23:11 -0400
Message-ID: <1346098984.8623.23.camel@lambeau>
Subject: Re: [PATCH RFC 0/3] Add guest cpu_entitlement reporting
From: Michael Wolf <mjw@linux.vnet.ibm.com>
Reply-To: mjw@linux.vnet.ibm.com
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, peterz@infradead.org,
        mtosatti@redhat.com, glommer@parallels.com, mingo@redhat.com
Date: Mon, 27 Aug 2012 15:23:04 -0500
In-Reply-To: <503BC298.3080306@redhat.com>
References: <20120823231346.11681.1502.stgit@lambeau>
	 <503BC298.3080306@redhat.com>
Organization: IBM
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082720-5806-0000-0000-000018DBDDA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-27 at 11:55 -0700, Avi Kivity wrote:
> On 08/23/2012 04:14 PM, Michael Wolf wrote:
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
> > This patchset is changing the contents/output of /proc/stat and could affect 
> > user tools.  However the default setting is that the cpu is entitled to 100% 
> > so the code will act as before.  Also another field could be added to the 
> > /proc/stat output and show the unaltered steal time. Since this additional 
> > field could cause more confusion than it would clear up I have left it out 
> > for now.
> >                 
> 
> How would a guest know what its entitlement is?
> 
> 

Currently the Admin/management tool setting up the guests will put it on
the qemu commandline.  From this it is passed via an ioctl to the host.
The guest will get the value from the host via a hypercall.

In the future the host could try and do some of it automatically in some
cases. 

