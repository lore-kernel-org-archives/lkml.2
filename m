Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758587Ab1FWA5l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 20:57:41 -0400
Received: from ozlabs.org ([203.10.76.45]:53285 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754341Ab1FWA5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 20:57:41 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: module: sysfs - add 'uevent' file to allow coldplug
In-Reply-To: <BANLkTimNpDdp+JBXt0wUjuc0awypJSvXRg@mail.gmail.com>
References: <1308434431.1050.5.camel@mop> <8739j59zib.fsf@rustcorp.com.au> <BANLkTink8YTe=-Tr5Ax3epiFoFCfzcex7w@mail.gmail.com> <87boxshrwe.fsf@rustcorp.com.au> <BANLkTinL4r3RfNuA5x6=UK4DCSSJNeZw7w@mail.gmail.com> <87r56m8w2b.fsf@rustcorp.com.au> <BANLkTimNpDdp+JBXt0wUjuc0awypJSvXRg@mail.gmail.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Thu, 23 Jun 2011 09:57:22 +0930
Message-ID: <87fwn18k9h.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jun 2011 12:17:49 +0200, Kay Sievers <kay.sievers@vrfy.org> wrote:
> On Wed, Jun 22, 2011 at 04:00, Rusty Russell <rusty@rustcorp.com.au> wrote:
> > I apologize for skimming,
> 
> Absolutely no problem. Asking such questions can not be wrong.

Sure, but as we know nothing is as abrupt as a hacker who has just
encountered their own ignorance :)

> > but this should be the *title* of the patch!
> 
> Right, it's hard sometimes from 'inside' to make good titles that make
> titles that are properly understood 'outside'. If you have any better
> idea, please just change it.

Good observation; for me writing documentation serves this purpose.  I
renamed half the functions in the iptables code after I'd written the
user docs...

> > Now we've got that sorted, is there a reason why you changed all the
> > signatures rather than just using mod->mkobj in store_uevent()?
> 
> Because we should be able to use the same 'struct module_attribute'
> for built-in modules and for loaded modules at the same time. The
> current 'struct module_attribute' has 'struct module' references, but
> 'struct module' will never exist for built-in modules.
> 
> 'Struct module_kobject' has nice back-pointer to 'struct module', so
> this was the simplest to do, and looks still fine, I thought.

Yes, it's weird.  The only reason it currently works is because we don't
use the mod parameter in param_attr_show and param_attr_store; it's NULL
for built-in modules.

I'd prefer that patch first, I think: it's a sensible cleanup.

Thanks,
Rusty.
