Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331Ab1EaTDo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 15:03:44 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:58408 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757863Ab1EaTDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 15:03:42 -0400
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, kees.cook@canonical.com,
        davej@redhat.com, torvalds@linux-foundation.org, adobriyan@gmail.com,
        eranian@google.com, penberg@kernel.org, davem@davemloft.net,
        Arjan van de Ven <arjan@infradead.org>, Valdis.Kletnieks@vt.edu,
        Andrew Morton <akpm@linux-foundation.org>, pageexec@freemail.hu,
        Ingo Molnar <mingo@elte.hu>, Vivek Goyal <vgoyal@redhat.com>
In-Reply-To: <20110531185122.GA11998@srcf.ucam.org>
References: <1306269105.21443.20.camel@dan> <1306442367.2279.25.camel@dan>
	 <20110531165252.GB8971@srcf.ucam.org> <4DE5360D.5070809@zytor.com>
	 <20110531185122.GA11998@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 May 2011 15:03:29 -0400
Message-ID: <1306868609.6317.25.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-31 at 19:51 +0100, Matthew Garrett wrote:
> On Tue, May 31, 2011 at 11:40:13AM -0700, H. Peter Anvin wrote:
> > On 05/31/2011 09:52 AM, Matthew Garrett wrote:
> > > The BIOS E820 map, or the kernel representation? In either case, this 
> > > isn't going to work well with EFI. There are regions that will be marked 
> > > as available in the E820 map that we *mustn't* touch until we've entered 
> > > EFI virtual mode.
> > > 
> > > (This is, clearly, insane).
> > > 
> > 
> > I believe we could (should!) mark them reserved, not available, in the
> > E820 map and free them later.
> 
> That was my original approach, but it requires that the bootloader be 
> modified and it turns out that it's a lot harder to hand reserved 
> regions back to the OS than it is to just reserve it in-kernel. The 
> complete inflexibility of e820 is massively unhelpful here. It's just 
> not possible to represent all of the EFI memory map data in it.
> 

Just for the record, I've put this patch on hold until there's some more
consensus about whether boot-time randomization of the physical kernel
address is the best approach.  There are some other potential issues
that haven't been brought up yet publicly, such as the possibility of
local attackers performing cache timing attacks to find the kernel image
location at runtime, which may make traditional ASLR somewhat pointless
regardless (except in the case of remote attackers, I suppose).  Perhaps
HPA's suggestion of further modularizing the kernel would have some
advantages in this regard.

-Dan

> -- 
> Matthew Garrett | mjg59@srcf.ucam.org


