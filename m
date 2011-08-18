Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab1HRL71 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 07:59:27 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59459 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755584Ab1HRL70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 07:59:26 -0400
Date: Thu, 18 Aug 2011 13:59:21 +0200
From: Tejun Heo <tj@kernel.org>
To: Jan Beulich <JBeulich@novell.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: x86_32_early_logical_apicid() -> one warning per CPU on
 late-determined BIGSMP systems
Message-ID: <20110818115921.GA20085@htj.dyndns.org>
References: <4E43EBDF0200007800050CA7@nat28.tlf.novell.com>
 <20110812101556.GM23842@htj.dyndns.org>
 <4E4D19820200007800051D19@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E4D19820200007800051D19@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Aug 18, 2011 at 12:54:10PM +0100, Jan Beulich wrote:
> >>> On 12.08.11 at 12:15, Tejun Heo <tj@kernel.org> wrote:
> > Ooh, okay, bigsmp switches apic pretty late in the init.  Wouldn't it
> > be better to move that to right after dmi init regardless of this
> > problem?
> 
> No, because this depends on knowing num_possible_cpus(), which
> in turn can't be done until after the firmware tables got parsed (and
> that's where the ->x86_32_early_logical_apicid() call happens).

OIC, switching apic that late seems rather nasty.  Eh well...  :(

> > So, yeah, please go ahead and remove it.
> 
> There are quite a few references to this, and some from code that
> if I change it I would have no way of testing (Summit, ES7000, NUMAQ).
> So no, I don't think I'm in the position to do this cleanup (if it really is
> just that).
> 
> So for the time being I'll put together a patch re-writing
> early_per_cpu(x86_cpu_to_logical_apicid, ...) right after overriding
> apic_default with apic_bigsmp.

Yeap, sure.  We'll need less invasive for -stable anyway.  I'll kill
the method afterwards.

Thanks.

-- 
tejun
