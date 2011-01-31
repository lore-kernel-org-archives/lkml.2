Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860Ab1AaXNH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 18:13:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22024 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756714Ab1AaXNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 18:13:05 -0500
Date: Tue, 1 Feb 2011 00:13:01 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: CAI Qian <caiqian@redhat.com>, linux-mm <linux-mm@kvack.org>,
        linux-kernel@vger.kernel.org
Subject: Re: kswapd hung tasks in 2.6.38-rc1
Message-ID: <20110131231301.GP16981@random.random>
References: <1150342867.83404.1295513748640.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
 <1296507528.7797.4609.camel@nimitz>
 <1296513616.7797.4929.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296513616.7797.4929.camel@nimitz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 02:40:16PM -0800, Dave Hansen wrote:
> Still not a very good data point, but I ran a heavy swap load for an
> hour or so without reproducing this.  But, it happened again after I
> enabled transparent huge pages.  I managed to get a sysrq-t dump out of
> it:
> 
> 	http://sr71.net/~dave/ibm/2.6.38-rc2-hang-0.txt
> 
> khugepaged is one of the three running tasks.  Note, I set both its
> sleep timeouts to zero to stress it out a bit.

sysrq+l? sysrq+t doesn't provide interesting info for running tasks.

> I'll keep trying to reproduce without THP.

BTW, do you have prove locking enabled? With recent git I get a
deadlock inside _raw_spin_unlock_irq with prove locking enabled and it
goes away when I disable it.
