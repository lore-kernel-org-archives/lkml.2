Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab2JVOka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 10:40:30 -0400
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:57140
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754116Ab2JVOk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 10:40:29 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 5
X-BigFish: VPS5(zzbb2dI98dI103dK148cI1432I4015Izz1202h1d1ah1d2ahzz177df4h17326ah8275bh8275dhf73b6uz2dh668h839h944hd25hd2bhf0ah107ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1155h)
X-WSS-ID: 0MCAU3A-01-6W1-02
X-M-MSG: 
Date: Mon, 22 Oct 2012 09:40:20 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Tom Rini <trini@ti.com>, <hpa@zytor.com>
CC: Yinghai Lu <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: BUG: 1bbbbe7 (x86: Exclude E820_RESERVED regions...) PANIC on
 boot
Message-ID: <20121022144020.GA14425@jshin-Toonie>
References: <903a3ead-98b5-4afa-88a4-3dc723895e82@blur>
 <d556fc0f-da5d-4531-b331-6dc086461f34@blur>
 <50833F30.4020802@ti.com>
 <CAE9FiQWpSvKp=Oh+4Y8OpdOjdRnkYVL2HvNNXc29ESpNsMC0AQ@mail.gmail.com>
 <20121021041858.GA14809@jshin-Toonie>
 <50843627.4020103@ti.com>
 <20121021210633.GA14311@jshin-Toonie>
 <508467EE.4040807@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <508467EE.4040807@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 21, 2012 at 02:23:58PM -0700, Tom Rini wrote:
> On 10/21/12 14:06, Jacob Shin wrote:
> > Ah, sorry, this one should apply on top of 3.7-rc2:
> > 
> > https://lkml.org/lkml/2012/8/24/469
> > 
> > Could you try that? Just that single patch, not the whole patchset.
> 
> That fixes it, replied with a note and Tested-by, thanks!

Thanks for testing!

hpa, so sorry, but it looks like we need one more patch [PATCH 2/5] x86:
find_early_table_space based on memory ranges that are being mapped:

  https://lkml.org/lkml/2012/8/24/469

on top of this, because find_early_table_space calculation does not come out
correctly for this particular E820 table that Tom has:

  http://pastebin.com/4eSPEAvB

The reason why we hit this now, and never hit it before is because before the
start was hard coded to 1UL<<32.

Thanks,

-Jacob

> 
> -- 
> Tom
> 
> 

