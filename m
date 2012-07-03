Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933299Ab2GCIHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 04:07:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53131 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768Ab2GCIG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 04:06:56 -0400
From: Arnd Bergmann <arnd.bergmann@linaro.org>
Organization: Linaro Limited 
To: Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: linux-next: build failure after merge of the final tree (pwm tree related)
Date: Tue, 3 Jul 2012 08:06:49 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>
References: <20120629174826.546cc991459b12833f2aaebd@canb.auug.org.au> <20120703161846.59fee8d3815993bcea122eeb@canb.auug.org.au> <20120703062351.GA25217@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20120703062351.GA25217@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201207030806.49561.arnd.bergmann@linaro.org>
X-Provags-ID: V02:K0:6KXJ3MiF4w5ggcA04hkaW261Att842T5do0lHW92fS9
 fFvkaCU0oBocm8naLzjAC8M0OL93XP+gQxTne+tebehMBlSARE
 lnqEyvlCrhLqlKPclp1xpMdmfNqPW3nr7DQPIk3oijhWvjxfXD
 Gj0YvNat6MVt/nF8AmMtZDPleiQofMdCQiugFS6yGFCeWGlpn9
 wby5D/+mNJdK3hRM4diQ2PXuAuos0mMvsocZ6Qu8TIIEItaIwO
 OXsrC2xOUBVyJHJR4+DUP2cP/jj7gohk+HyKfM4zg4kkaLTFYI
 fN0u8HMB8/ebggLTKhvhco2JNorNzn43IL8xemKcu52Vqxclvt
 4g/dApjll0pOQS5N1br8xLPNmj0Vj/wNUb8zKorNe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 July 2012, Thierry Reding wrote:
> On Tue, Jul 03, 2012 at 04:18:46PM +1000, Stephen Rothwell wrote:
> > Hi Thierry,
> > 
> > On Tue, 3 Jul 2012 08:11:15 +0200 Thierry Reding <thierry.reding@avionic-design.de> wrote:
> > >
> > > I don't see how that can happen. If you have CONFIG_TWL6030_PWM=y, then
> > > you should also have CONFIG_HAVE_PWM=y, which would in turn conflict
> > > with CONFIG_PWM=y.
> > > 
> > > I'll have to fetch a powerpc toolchain and try to reproduce this.
> > 
> > CONFIG_HAVE_PWM only exists on arm, mips and unicore32 ... so the "select
> > HAVE_PWM" will not do anything on any other architecture.
> 
> So one option would be to add HAVE_PWM on powerpc, or alternatively to
> explicitly add a conflict to the TWL6030_PWM symbol (and any others that
> implement the legacy API). I'd think the second alternative is
> preferable and actually matches what Arnd proposed previously. Maybe
> this was exactly the reason he suggested that solution in the first
> place.

It's not what I was thinking of explicitly, but it's a good
reason nonetheless ;-)

	Arnd
