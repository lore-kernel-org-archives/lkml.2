Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905Ab1DMI5b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 04:57:31 -0400
Received: from gate.crashing.org ([63.228.1.57]:60388 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757863Ab1DMI5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 04:57:30 -0400
Subject: Re: mm: convert vma->vm_flags to 64bit
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <20110413072935.GK7806@n2100.arm.linux.org.uk>
References: <BANLkTinLdWB+ON=TY=KHyzsrC8gC5bXg7Q@mail.gmail.com>
	 <1302646024.28876.52.camel@pasglop>
	 <20110413091301.41E1.A69D9226@jp.fujitsu.com> <20110413064432.GA4098@p183>
	 <1302678049.28876.77.camel@pasglop>
	 <20110413072935.GK7806@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Apr 2011 18:56:59 +1000
Message-ID: <1302685019.28876.80.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-13 at 08:29 +0100, Russell King - ARM Linux wrote:
> 
> > Right, it shouldn't. My original patch did that to avoid thinking
> about
> > archs that manipulated it from asm such as ARM but that wasn't the
> right
> > thing to do. But that doesn't invalidate having a type.
> 
> No, we don't manipulate it.  We only test for VM_EXEC in it in asm. 

Yeah whatever, you did something that I didn't spare the brain cell to
try to figure out back then :-) Maybe I should have ... I was also
worried about the embedded folks having a go at me for "bloat they don't
need". But in the end it was wrong, it should always be 64-bit.

But regardless, I still think it should be a specific type. "unsigned
long long" really sucks.

Cheers,
Ben.

