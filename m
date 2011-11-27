Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774Ab1K0KuI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 05:50:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270Ab1K0KuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 05:50:07 -0500
Date: Sun, 27 Nov 2011 12:50:00 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Liu Ping Fan <kernelfans@gmail.com>, aliguori@us.ibm.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org,
        linux-kernel@vger.kernel.org, ryanh@us.ibm.com, jan.kiszka@web.de
Subject: Re: [Qemu-devel] [PATCH 2/2] kvm: exit to userspace with reason
 KVM_EXIT_VCPU_DEAD
Message-ID: <20111127105000.GL2557@redhat.com>
References: <1322188529-11609-1-git-send-email-kernelfans@gmail.com>
 <1322361735-21428-1-git-send-email-kernelfans@gmail.com>
 <4ED212C7.1080901@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ED212C7.1080901@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 27, 2011 at 12:36:55PM +0200, Avi Kivity wrote:
> On 11/27/2011 04:42 AM, Liu Ping Fan wrote:
> > From: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
> >
> > The vcpu can be safely released when
> > --1.guest tells us that the vcpu is not needed any longer.
> > --2.vcpu hits the last instruction _halt_
> >
> > If both of the conditions are satisfied, kvm exits to userspace
> > with the reason vcpu dead. So the user thread can exit safely.
> >
> >
> 
> Seems to be completely unnecessary.  If you want to exit from the vcpu
> thread, send it a signal.
> 
Also if guest "tells us that the vcpu is not needed any longer" (via
ACPI I presume) and vcpu actually doing something critical instead of
sitting in 1:hlt; jmp 1b loop then it is guest's problem if it stops
working after vcpu destruction.

--
			Gleb.
