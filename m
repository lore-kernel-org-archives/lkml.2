Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab1IUPeY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 11:34:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33053 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab1IUPeX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 11:34:23 -0400
Subject: Re: [V5][PATCH 4/6] x86, nmi:  add in logic to handle multiple
 events and unknown NMIs
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Don Zickus <dzickus@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "avi@redhat.com" <avi@redhat.com>, "jeremy@goop.org" <jeremy@goop.org>
Date: Wed, 21 Sep 2011 17:33:52 +0200
In-Reply-To: <20110921151829.GC6063@erda.amd.com>
References: <1316529792-6560-1-git-send-email-dzickus@redhat.com>
	 <1316529792-6560-5-git-send-email-dzickus@redhat.com>
	 <20110921100842.GA6063@erda.amd.com> <20110921140432.GP5795@redhat.com>
	 <20110921151829.GC6063@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316619232.24750.2.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-21 at 17:18 +0200, Robert Richter wrote:
> 1. The cpu executes some microcode or SMM code.
> 2. HW triggers the first NMI, an NMI is pending.
> 3. HW triggers a second NMI, the NMI is still pending.
> 4. The cpu finished microcode or SMM code.
> 5. NMI handler is called, no NMI pending anymore.
> 6. Return from NMI handler. 

Even without SMM, all you need is two different NMI users to trigger
while an NMI is in flight.

Wouldn't be entirely impossible to trigger if you have
non-fatal-MCE/hardware-NMI-switch/PMI all active.
