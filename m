Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab2C0NPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 09:15:35 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:32702 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798Ab2C0NPZ convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Tue, 27 Mar 2012 09:15:25 -0400
Message-Id: <4F71D9BE020000780007B268@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 27 Mar 2012 14:16:14 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Cc: <mingo@elte.hu>, <hirofumi@mail.parknet.co.jp>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: hpet_disable() call sites
References: <4F719449020000780007B0CD@nat28.tlf.novell.com>
 <alpine.LFD.2.02.1203271457460.2542@ionos>
In-Reply-To: <alpine.LFD.2.02.1203271457460.2542@ionos>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 27.03.12 at 14:58, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Tue, 27 Mar 2012, Jan Beulich wrote:
>> up kernel has a problem if the HPET is in an unexpected state, in
>> particular preventing "normal" timer interrupts from occurring (which
>> was in particular found to be the case during kdump attempts after
>> Xen was running).
> 
> What's Xen doing special with the hpet ?

Just like Linux it may use the legacy routing and fsb delivery bits, and
a (native) kdump kernel subsequently coming up would fail the
timer-connected-to-IOAPIC test if either remained enabled.

>> Is there any reason why hpet_disable() should not also be called
>> from (or some equivalent action be taken, perhaps including clearing
>> certain bits in the individual counters' configuration registers, which
>> are apparently - but perhaps wrongly - implied to be clear in e.g.
>> hpet_set_mode(), in) hpet_enable()?
> 
> No, there is no particular reason why we don't clear those registers.

In that case I'll prepare a patch to do so. One related question is
whether use of the HPET should be suppressed when any bit unknown
to the kernel is found set, or whether unknown bits should also be
cleared.

Jan

