Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239Ab1DLU1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 16:27:09 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:48667 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757149Ab1DLU1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 16:27:08 -0400
From: Richard Weinberger <richard@nod.at>
To: Pekka Enberg <penberg@kernel.org>
Subject: Re: um: this_cpu_cmpxchg16b_emu
Date: Tue, 12 Apr 2011 22:27:03 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.25.20-0.7-pae; KDE/4.4.4; i686; ; )
Cc: Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>,
        linux-kernel@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net, hpa@zytor.com
References: <201104121609.56901.richard@nod.at> <20110412192014.GF16342@mtj.dyndns.org> <BANLkTimsw1N=0QkEsySBE58GJx7g12XQpQ@mail.gmail.com>
In-Reply-To: <BANLkTimsw1N=0QkEsySBE58GJx7g12XQpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104122227.03688.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 12 April 2011, 21:22:47 schrieb Pekka Enberg:
> On Tue, Apr 12, 2011 at 08:41:11PM +0200, Richard Weinberger wrote:
> >> Am Dienstag 12 April 2011, 20:10:37 schrieb Christoph Lameter:
> >> > On Tue, 12 Apr 2011, Richard Weinberger wrote:
> >> > > This patch implements this_cpu_cmpxchg16b_emu() for UML.
> >> > 
> >> > Is this really necessary? Just undefine CONFIG_CMPXCHG_LOCAL for UML
> >> > and the asm code will not be used.
> >> 
> >> UML includes arch/x86/Kconfig.cpu which defines CONFIG_CMPXCHG_LOCAL
> >> automatically. Just disabling CONFIG_CMPXCHG_LOCAL for UML is IMHO not
> >> very nice. When chpxchg is available also UML should use it...
> 
> On Tue, Apr 12, 2011 at 10:20 PM, Tejun Heo <tj@kernel.org> wrote:
> > Ugh... I'd really like to avoid things like this for UML.  Is there
> > any SLUB performance sensitive workload running on UML?  I've never
> > seen any UML in production environment.  Wouldn't it be better to keep
> > things simple?
> 
> Yes, it would be. :-)

Okay. Then let's keep it simple. :-)
I'll disable CONFIG_CMPXCHG_LOCAL for UML.

Has someone looked at my this_cpu_cmpxchg16b_emu() implementation,
is it correct? Especially the call to C stuff.
I've tested it, it works fine.

Thanks,
//richard
