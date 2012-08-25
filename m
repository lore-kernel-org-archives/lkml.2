Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750971Ab2HYEUb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 00:20:31 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:59132
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750806Ab2HYEU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 00:20:29 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1202hzzz2dh668h839h944hd25hd2bhf0ah107ah1155h)
X-WSS-ID: 0M9AMPW-02-20K-02
X-M-MSG: 
Date: Fri, 24 Aug 2012 23:20:20 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
        Dave Young <dyoung@redhat.com>, Chao Wang <chaowang@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 3/5] x86: Only direct map addresses that are marked as
 E820_RAM
Message-ID: <20120825042020.GC26127@jshin-Toonie>
References: <1345852516-3125-1-git-send-email-jacob.shin@amd.com>
 <1345852516-3125-4-git-send-email-jacob.shin@amd.com>
 <50381C9D.5070007@zytor.com>
 <20120825004859.GB10812@jshin-Toonie>
 <5038269E.80707@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5038269E.80707@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 06:13:02PM -0700, H. Peter Anvin wrote:
> On 08/24/2012 05:49 PM, Jacob Shin wrote:
> > 
> > Right, I think what I was attempting to do was to merge the 1MB
> > with E820_RAM right above 1MB:
> > 
> > So instead of:
> > 
> > init_memory_mapping(0, 1MB)
> > init_memory_mapping(1MB, 2GB)
> > 
> > It would be:
> > 
> > init_memory_mapping(0, 2GB)
> > 
> > While taking care of the odd case where there is a gap right after
> > 1MB.
> > 
> > But if its not worth it, I can move it out of the loop.
> > 
> 
> What is the benefit?

So that in the case where we have E820_RAM right above 1MB, we don't
call init_memory_mapping twice, first on 0 ~ 1MB and then 1MB ~ something

we only call it once. 0 ~ something.

I'll get it out of the loop if you don't think its a good idea.

> 
> 	-hpa
> 
> 

