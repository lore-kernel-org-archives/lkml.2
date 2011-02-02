Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab1BBMsx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 07:48:53 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:60710 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753272Ab1BBMsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 07:48:52 -0500
X-Sasl-enc: vfWOW0RQcT/XSmcQrVxtqjs9BJvnjg2ZAI3BdY5+X5Hl 1296650931
Date: Wed, 2 Feb 2011 10:48:48 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>, Jeremy Fitzhardinge <jeremy@goop.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Xen Devel <Xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 0/2] x86/microcode: support for microcode update in Xen
 dom0
Message-ID: <20110202124848.GE9737@khazad-dum.debian.net>
References: <cover.1296259339.git.jeremy.fitzhardinge@citrix.com>
 <20110130113356.GA27967@liondog.tnic>
 <4D461FB9.5050807@goop.org>
 <20110131070241.GA22071@liondog.tnic>
 <4D46FC9F.6090309@goop.org>
 <20110131234131.GA16095@liondog.tnic>
 <4D475099.1080004@goop.org>
 <20110201110026.GA4739@liondog.tnic>
 <4D489348.90701@goop.org>
 <20110202095445.GA4761@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110202095445.GA4761@liondog.tnic>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Feb 2011, Borislav Petkov wrote:
> Why would you need that? You can safely assume that the ucode patch
> level on all cores across the system are identical - I've yet to see a

No.  You can safely assume that the ucode patch level on all cores on a
package are identical, and that's it.  Mixing processors with different
processor flags (and thus potentially different microcode) is not uncommon.
If it boots, it *will* be done, especially later in the product cycle, when
specific spare parts are harder to come by.  Sometimes you can even mix
processors of different steppings.

> mixed silicon systems is a large pain in the ass and you're better off
> buying yourself a completely new system.

Well, I have some of them at work.

Mixed CPU steppings or processor flags happen when you expand the system
later to fill in processor packages (reasonably common), or when you replace
a CPU that is flaky (rare).  This sort of mixing of different processors is
really common on older Xeon systems, and most of them need OS-assisted
microcode updates to get the latest microcode available.

I am not arguing anything about the way Xen decided to go about implementing
the feature, but they got the requirement "must pass through all the
microcodes without removing any" right.  It exists.

> > However, even aside from that, it means exporting a pile of internal
> > details from microcode_amd and reusing them within microcode_xen.  And
> > it requires that it be done again for each vendor.
> 
> Why can't you load the appropriate, unmodified microcode_<vendor> module
> in dom0 and let it call the hypercall?

Or add a microcode_virtual passthrough device, for that matter.  Wouldn't
that be much cleaner and more palatable?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
