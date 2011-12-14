Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757929Ab1LNS1J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 13:27:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755498Ab1LNS1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 13:27:07 -0500
Date: Wed, 14 Dec 2011 16:21:01 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Eric B Munson <emunson@mgebm.net>, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, ryanh@linux.vnet.ibm.com, aliguori@us.ibm.com,
        jeremy.fitzhardinge@citrix.com, levinsasha928@gmail.com,
        Jan Kiszka <jan.kiszka@siemens.com>, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5 V5] Avoid soft lockup message when KVM is stopped by
 host
Message-ID: <20111214182101.GB21945@amt.cnet>
References: <1323116344-17911-1-git-send-email-emunson@mgebm.net>
 <4EDF7B0D.4060001@redhat.com>
 <20111214121622.GB18317@amt.cnet>
 <4EE8B53C.6070502@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EE8B53C.6070502@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 04:39:56PM +0200, Avi Kivity wrote:
> On 12/14/2011 02:16 PM, Marcelo Tosatti wrote:
> > > Having this controlled from userspace means it doesn't work for SIGSTOP
> > > or for long scheduling delays.  What about doing this automatically
> > > based on preempt notifiers?
> >
> > Long scheduling delays should be considered hangups from the guest
> > perspective.
> 
> Why?  To the guest it looks like slow hardware, but it will interpret it
> as a softlockup.

Slow enough that progress of the watchdog thread is unable to keep up
with timer interrupt processing. This is considered a hang and
should be reported.

> > About SIGSTOP, that is a corner case. Unsure if its even properly supported 
> > by QEMU.
> 
> It works from my experience.


