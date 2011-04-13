Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188Ab1DMHah (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 03:30:37 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55769 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757056Ab1DMHag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 03:30:36 -0400
Date: Wed, 13 Apr 2011 08:29:35 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: mm: convert vma->vm_flags to 64bit
Message-ID: <20110413072935.GK7806@n2100.arm.linux.org.uk>
References: <BANLkTinLdWB+ON=TY=KHyzsrC8gC5bXg7Q@mail.gmail.com> <1302646024.28876.52.camel@pasglop> <20110413091301.41E1.A69D9226@jp.fujitsu.com> <20110413064432.GA4098@p183> <1302678049.28876.77.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302678049.28876.77.camel@pasglop>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 05:00:49PM +1000, Benjamin Herrenschmidt wrote:
> On Wed, 2011-04-13 at 09:44 +0300, Alexey Dobriyan wrote:
> > > Yes, I take Hugh's version because vm_flags_t is ugly to me. And
> > arch 
> > > dependent variable size is problematic.
> > 
> > Who said it should have arch-dependent size? 
> 
> Right, it shouldn't. My original patch did that to avoid thinking about
> archs that manipulated it from asm such as ARM but that wasn't the right
> thing to do. But that doesn't invalidate having a type.

No, we don't manipulate it.  We only test for VM_EXEC in it in asm.
