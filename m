Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544Ab0IZLua (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 07:50:30 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:39167 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757378Ab0IZLu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 07:50:29 -0400
Date: Sun, 26 Sep 2010 17:09:10 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@suse.de>, Peter Zijlstra <peterz@infradead.org>,
        Jan Beulich <JBeulich@novell.com>, Avi Kivity <avi@redhat.com>,
        Xen-devel <xen-devel@lists.xensource.com>, suzuki@in.ibm.com
Subject: Re: [PATCH RFC 09/12] xen/pvticketlock: Xen implementation for PV
 ticket locks
Message-ID: <20100926113910.GA6719@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <cover.1279328276.git.jeremy.fitzhardinge@citrix.com>
 <32e63cc978ec4b3f36c7f641ce48b3d86aed22ed.1279328276.git.jeremy.fitzhardinge@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32e63cc978ec4b3f36c7f641ce48b3d86aed22ed.1279328276.git.jeremy.fitzhardinge@citrix.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 06:03:04PM -0700, Jeremy Fitzhardinge wrote:
> Replace the old Xen implementation of PV spinlocks with and implementation
> of xen_lock_spinning and xen_unlock_kick.

I see that the old implementation took care of a spinlock() call being
interrupted by another spinlock (in interrupt handler), by saving/restoring 
old lock of interest. We don't seem to be doing that in this new version?
Won't that lead to loss of wakeup -> hang?

Also are you planning to push this series into mainline sometime soon?

- vatsa
