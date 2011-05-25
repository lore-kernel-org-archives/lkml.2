Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab1EYTgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 15:36:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39647 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754892Ab1EYTgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 15:36:19 -0400
Date: Wed, 25 May 2011 21:36:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Andi Kleen <ak@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 1/3] x86, intel: Output microcode revision
Message-ID: <20110525193601.GE17864@elte.hu>
References: <1306278210-18285-1-git-send-email-andi@firstfloor.org>
 <20110525070604.GE429@elte.hu>
 <20110525160656.GB25225@khazad-dum.debian.net>
 <20110525165803.GB14958@tassilo.jf.intel.com>
 <20110525182405.GA17864@elte.hu>
 <20110525190424.GA17793@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110525190424.GA17793@khazad-dum.debian.net>
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


* Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:

> On Wed, 25 May 2011, Ingo Molnar wrote:
> >
> > So displaying a non-fatal 'info' message about it would in fact 
> > be rather wise. Nothing scary, but we'd like to be informed.
> 
> A printk with levels info or notice, I do agree to be a good idea.  
> In fact, I like the idea a lot.
> 
> WARN() and kernel tainting, which is what I understand was being 
> proposed before, I cannot agree with.

Yeah, the taint is probably overdoing it - especially considering 
that mixing certain steppings is explicitly supported.

> OTOH, IMO mismatched microcode should be grounds for more serious 
> measures. And that includes fixing the annoying userspace ABI that 
> encourages bad behaviour in the first place and makes it harder to 
> do the proper thing.

Well, a problem the microcode driver has is that it needs that 
microcode blob. So we cannot really load it right at bootup (unless 
we promote the image to the initrd - somewhat hairy).

Thanks,

	Ingo
