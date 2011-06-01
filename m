Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab1FAGTI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 02:19:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43621 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302Ab1FAGTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 02:19:04 -0400
Date: Wed, 1 Jun 2011 08:18:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, Matthew Garrett <mjg@redhat.com>,
        Tony Luck <tony.luck@gmail.com>, linux-kernel@vger.kernel.org,
        kees.cook@canonical.com, davej@redhat.com,
        torvalds@linux-foundation.org, adobriyan@gmail.com, eranian@google.com,
        penberg@kernel.org, davem@davemloft.net,
        Arjan van de Ven <arjan@infradead.org>, Valdis.Kletnieks@vt.edu,
        Andrew Morton <akpm@linux-foundation.org>, pageexec@freemail.hu,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
Message-ID: <20110601061843.GA27671@elte.hu>
References: <1306269105.21443.20.camel@dan>
 <1306442367.2279.25.camel@dan>
 <20110531165252.GB8971@srcf.ucam.org>
 <4DE5360D.5070809@zytor.com>
 <20110531185122.GA11998@srcf.ucam.org>
 <1306868609.6317.25.camel@dan>
 <20110531195551.GC26970@elte.hu>
 <4DE54C66.10106@zytor.com>
 <20110531202712.GB28731@elte.hu>
 <4DE54FFF.4010500@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE54FFF.4010500@zytor.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 05/31/2011 01:27 PM, Ingo Molnar wrote:
> > 
> >> Other than that, Ingo's idea at least have the merit that it would 
> >> break only older bootloaders doing things wrong.
> > 
> > I'm wondering, why would it break older bootloaders? It's just a 
> > slightly larger than usual kernel image, nothing is visible to the 
> > bootloader.
> > 
> 
> Older boot loaders did not know how big the kernel image was, 
> therefore had no way to avoid memory space collision.  That is 
> fixed in boot protocol 2.10.

But i loaded really large kernel images way back 10 years ago on 
various systems and never had any problems until the default 
allyesconfig hit a ~40 MB kernel image size limit ;-)

(which limit was in the kernel, not in the bootloader)

So yes, a large kernel image "can" be an issue with old bootloaders 
in some situations on weird machines but we don't really "break" them 
via randomization, they were broken and fragile in some situations to 
begin with.

It's fixed in any distro that cares and which would use our (not even 
released) kernel that might one day have randomization.

Is that a fair summary of the bootloader situation?

Thanks,

	Ingo
