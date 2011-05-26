Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758451Ab1EZUc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 16:32:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50219 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755237Ab1EZUcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 16:32:24 -0400
Date: Thu, 26 May 2011 16:31:08 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Valdis.Kletnieks@vt.edu
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, davej@redhat.com,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        torvalds@linux-foundation.org, adobriyan@gmail.com, penberg@kernel.org,
        hpa@zytor.com, Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        pageexec@freemail.hu
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
Message-ID: <20110526203108.GJ29496@redhat.com>
References: <1306269105.21443.20.camel@dan>
 <20110526200121.GG29496@redhat.com>
 <26081.1306440965@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26081.1306440965@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 04:16:05PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 26 May 2011 16:01:21 EDT, Vivek Goyal said:
> 
> > Also randomization of kernel load address at run time will probably have
> > some issues with crashkernel=X@Y address syntax. So far user knew what
> > address first kernel is booting from and user could speicy where to 
> > reserve memory. Now it might happen that user specified some memory
> > to reserve and kernel decided to occupy that space resulting in failed
> > memory reservation for crash kernel.
> 
> That is however fixable - the randomizer just needs to make sure it doesn't
> overlay the crashkernel= space, and the crashkernel needs to be started with a
> 'norandomize' parameter.

That can be done but at the same time if kernel does not find any suitable
range to boot from, it should override crashkernel=X@Y settings and fail
crash memory reservation.

I guess with randomize space thing a more suitable crash kernel command
line will be crashkernel=X where kernel decides the base address for
second kernel depending on availability.

> If your threat model includes attacks on the
> crashkernel that randomizing will help with, you got bigger problems. ;)
> 

:-) I think norandomize for kdump kernel should be just fine.

Thanks
Vivek
