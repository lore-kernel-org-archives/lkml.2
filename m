Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981Ab1CaOly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 10:41:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38022 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757711Ab1CaOlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 10:41:53 -0400
Date: Thu, 31 Mar 2011 15:41:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        Len Brown <len.brown@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/9] x86 idle: remove NOP cpuinfo_x86.hlt_works_ok flag
Message-ID: <20110331154103.70d88899@lxorguk.ukuu.org.uk>
In-Reply-To: <4D948D86.2050607@zytor.com>
References: <67e90d97e0a77df4acd0c75e1bacc7714e011f3e.1301550524.git.len.brown@intel.com>
	<b048802b0285a5ff28e74a4309d833116174904a.1301550524.git.len.brown@intel.com>
	<20110331061247.GA24786@elte.hu>
	<alpine.LFD.2.02.1103310252160.8569@x980>
	<20110331081800.GH5938@elte.hu>
	<20110331102355.17d30a38@lxorguk.ukuu.org.uk>
	<20110331092721.GA16570@elte.hu>
	<20110331103320.5a72ff8c@lxorguk.ukuu.org.uk>
	<20110331093528.GA19288@elte.hu>
	<4D948D86.2050607@zytor.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Mar 2011 07:19:50 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 03/31/2011 02:35 AM, Ingo Molnar wrote:
> > 
> > * Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > 
> >>> Btw., we used to auto-detect broken HLT systems IIRC - but that got lost 
> >>> already. We should at least honor the boot parameter.
> >>
> >> I don't believe we ever auto detected them or found a way to do so. That
> >> was why the HLT message was printed before hlt was executed.
> > 
> > Yeah - the CPU hang was unrecoverably deep so no auto-detection was possible.
> > 
> > That's seriously ancient stuff - still, keeping the boot option around (<10 
> > lines of code) does not hurt anyone.
> > 
> 
> What it was was bad power supplies or low-capacitance, high-inductance
> power distribution that happened to work with MS-DOS which always burned
> the CPU at 100% and therefore left the power draw relatively consistent
> current.  A proper OS putting the CPU in HLT produced a lot more high
> frequency noise on the power busses, with disastrous results without
> proper bypass.

And also chipset errata in some cases - eg some revisions of the CS5510
hung the box solid if a CPU hlt occurred during an IDE transfer. I don't
think any CS5510s are still around although I've had mail from someone
with a CS5520 in use not that long ago so who knows!

The joy of ancient history.
