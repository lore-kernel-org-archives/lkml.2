Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab1LSMwi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 07:52:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322Ab1LSMwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 07:52:36 -0500
Date: Mon, 19 Dec 2011 18:22:17 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Eric B Munson <emunson@mgebm.net>, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, ryanh@linux.vnet.ibm.com, aliguori@us.ibm.com,
        mtosatti@redhat.com, jeremy.fitzhardinge@citrix.com,
        levinsasha928@gmail.com, Jan Kiszka <jan.kiszka@siemens.com>,
        kvm@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5 V5] Avoid soft lockup message when KVM is stopped by
 host
Message-ID: <20111219125217.GC3139@amit-x200.redhat.com>
References: <1323116344-17911-1-git-send-email-emunson@mgebm.net>
 <20111208113422.GA27919@amit-x200.redhat.com>
 <4EE9E023.4000904@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EE9E023.4000904@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Thu) 15 Dec 2011 [13:55:15], Avi Kivity wrote:
> On 12/08/2011 01:34 PM, Amit Shah wrote:
> > On (Mon) 05 Dec 2011 [15:18:59], Eric B Munson wrote:
> > > When a guest kernel is stopped by the host hypervisor it can look like a soft
> > > lockup to the guest kernel.  This false warning can mask later soft lockup
> > > warnings which may be real.  This patch series adds a method for a host
> > > hypervisor to communicate to a guest kernel that it is being stopped.  The
> > > final patch in the series has the watchdog check this flag when it goes to
> > > issue a soft lockup warning and skip the warning if the guest knows it was
> > > stopped.
> >
> > Guest S4 would need similar treatment, and I think the code in the two
> > approaches can be shared.  Just something to consider.
> >
> 
> Why does S4 need any treatment?  The guest is aware that it's sleeping,
> unlike the other cases treated here.

Er, right.

S4 needs some treatment, though, as resume after s4 doesn't work with
kvmclock enabled.  I didn't realise this series was only handling the
soft lockup case.

		Amit
