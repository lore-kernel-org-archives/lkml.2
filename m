Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab1IBOua (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 10:50:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:60378 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349Ab1IBOu2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 10:50:28 -0400
Subject: Re: [PATCH 11/13] x86/ticketlock: only do kick after doing unlock
From: Peter Zijlstra <peterz@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Date: Fri, 02 Sep 2011 16:49:28 +0200
In-Reply-To: <8cd2c77886e2d3fcad8258aa62509b3b2fae5545.1314922370.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com>
	 <8cd2c77886e2d3fcad8258aa62509b3b2fae5545.1314922370.git.jeremy.fitzhardinge@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314974968.1861.3.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-01 at 17:55 -0700, Jeremy Fitzhardinge wrote:
> From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> 
> We must release the lock before checking to see if the lock is in
> slowpath or else there's a potential race where the lock enters the
> slow path after the unlocker has checked the slowpath flag, but before
> it has actually unlocked.
> 
> Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com> 

Wouldn't it be much better to fold it back so that this bug never
happens when you bisect?
