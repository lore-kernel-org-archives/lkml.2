Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab2HNTw5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 15:52:57 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:11538
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752376Ab2HNTw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 15:52:56 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI1432Izz1202hzzz2dh668h839h944hd25hd2bhf0ah107ah)
X-WSS-ID: 0M8RGK1-02-6UB-02
X-M-MSG: 
Date: Tue, 14 Aug 2012 14:52:48 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Borislav Petkov <bp@alien8.de>, Tejun Heo <tj@kernel.org>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 5/5] x86: Move enabling of PSE and PGE out of
 init_memory_mapping
Message-ID: <20120814195247.GA32453@jshin-Toonie>
References: <1344547389-4599-1-git-send-email-jacob.shin@amd.com>
 <1344547389-4599-6-git-send-email-jacob.shin@amd.com>
 <20120811200133.GG2874@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120813073440.GC16654@liondog.tnic>
 <20120813232040.GE25632@google.com>
 <20120814084916.GA16399@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120814084916.GA16399@liondog.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 10:49:16AM +0200, Borislav Petkov wrote:
> On Mon, Aug 13, 2012 at 04:20:40PM -0700, Tejun Heo wrote:
> > I meant the patch should come before the patch making multiple calls
> > to init_memory_mapping().

Ah, okay .. got it.

Hm .. for some reason Tejun's emails are no longer making it into my
inbox, there must be some filtering going on at the corporate IT level.
I'll try and inquire IT about it ..

Sorry, :-(

> 
> Ah, this makes sense.
> 
> > > > Also, there seem to be other stuff which need to be moved out.
> > > 
> > > Which are those pls?
> > 
> > Rebuilding pgtable on each invocation?
> 
> You mean pagetable_reserve() right?

This is actually needed on every call to init_memory_mapping(),

My patch 2/5 changes find_early_table_space() to find just enough space
to map start to end. The pagetable_reserve() will then reserve what we
actually used. Since init_memory_mapping() is called again and again
with different start to end ranges, we find space for the page tables
and reserve them every time.

> 
> Yes, Jacob, you basically might want to carve out all functionality
> from init_memory_mapping() which is independent from its start and end
> args and do the carving in a pre-patch or two to 1/5.
> 
> Thanks.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 

