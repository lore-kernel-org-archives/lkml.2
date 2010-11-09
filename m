Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027Ab0KIUtY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 15:49:24 -0500
Received: from nm2-vm0.bullet.mail.ukl.yahoo.com ([217.146.183.226]:40162 "HELO
	nm2-vm0.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753911Ab0KIUtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 15:49:22 -0500
X-Yahoo-Newman-Id: 910010.98814.bm@omp1033.mail.ukl.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=DKIM-Signature:Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:X-Enigmail-Version:Content-Type:Content-Transfer-Encoding;
  b=k01T95tN4Aq0Rey+GlpNM+s3XDlmzCF/FJ719RASGNTLmuOHtV8e9YkPO7CNHzawhInbJGQfOgohF/asgZqmSiedcpedxh/nerDMveoRbr2zzYHD7J/I+6gEt382nUjDVJohyQeWDqIM5csJpv1+b9qYtkFXyIY5H612E5PkoV4=  ;
X-Yahoo-SMTP: zgdcvJ6swBBcTOk5fgveL37ak9AQxYCP7GdO
X-YMail-OSG: sVLUWWMVM1mH5gJtsVMKtKl1H0ATmkuKxPWXCWVKVEyBGb0
 sa9pWRuU48W9F3K5v._vhQ2O7aXnSySrF2KY0STRMq1iTg5.WzMKBg2uh7Re
 OWucyK2CyHJK3YU_gebAaj5msaDPRBm6C2CWf4.pf_C_dNaBaSDqfQGPstwd
 L9RaPWCSfJl8IsWuE2APrkpkNO3fi6dm5RPhvJzGarSs_CIIxoxw7T0Eu2hw
 3UNO8pNH7vzndDPNIV5Kgf6WsHHdjgTvBfDjXnYgNZVSJCm9zjCGnsFoLjlr
 L..i4erz6g9bMSrc0M762eQsvUZn9l6PmkBFP8qV5OWVf.g1Y49dlrdGG2np
 50z2ZRnwm1sDhjDJJNhA-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4CD9B3DD.8090603@yahoo.fr>
Date: Tue, 09 Nov 2010 21:49:33 +0100
From: Lionel Debroux <lionel_debroux@yahoo.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100131 Thunderbird/3.0.1
MIME-Version: 1.0
To: Kees Cook <kees.cook@canonical.com>
CC: David Daney <ddaney@caviumnetworks.com>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
Subject: Re: [linux-next] automatic use of checkpatch.pl for security?
References: <20101109173357.GA5876@outflux.net> <4CD9887E.3040607@caviumnetworks.com> <20101109175921.GD5876@outflux.net>
In-Reply-To: <20101109175921.GD5876@outflux.net>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09.11.2010 18:59, Kees Cook wrote:
> Hi David,
> On Tue, Nov 09, 2010 at 09:44:30AM -0800, David Daney wrote:
> > On 11/09/2010 09:33 AM, Kees Cook wrote:
> > > In an effort to continue the constification work, it'd be nice to
> > > not accidentally introduce regressions or add additional work.
> > > Since checkpatch.pl already knows to warn about a lot of things
> > > including const structures, it would be great to have all commits
> > > going through linux-next (or something) have to pass at least a
> > > subset of checkpatch.pl's checks.
> > >
> > > For example, Lionel Debroux pointed out to me that looking at the
> > > last 1000 commits, there are a lot of warnings, including things
> > > like:
> > >
> > > WARNING: struct dma_map_ops should normally be const
> > > #499: FILE: arch/mips/mm/dma-default.c:301:
> > > +static struct dma_map_ops mips_default_dma_map_ops = {
> > >
> > > Can we add some kind of automatic checking to actually give
> > > checkpatch.pl some real teeth for at least some of its checks?
> > >
> >
> > Ok, did you actually try to make it const as suggested?  If you
> > had, you would have found that there are declarations throughout
> > the code base that conflict with checkpatch.pl's suggestion.
> >
> > There are several things we could do:
> >
> > 1) Force people to clean up the entire kernel tree before making
> > trivial changes that checkpatch.pl might complain about.
> >
> > 2) Change checkpatch.pl so that it doesn't complain about this.
> >
> > 3) Make reasonable changes and ignore the checkpatch.pl warning.
> >
> >
> > In that specific case you cite, #3 was chosen.
> 
> Right, I don't want to suggest unreasonable changes; I want to try
> and start a discussion about what might make a good addition to
> help avoid obvious problems. (The chosen example was, perhaps, not
> a good one.)
My bad, sorry.
backlight_ops and platform_suspend_ops, for which I sent patches to
linux-janitors, may be better examples: several new static mutable
instances of those structs have been added after
79404849e90a41ea2109bd0e2f7c7164b0c4ce73, which adds backlight_ops,
platform_suspend_ops and others to the list of "should be const" structures.
backlight_device_register() has been taking a "const struct
backlight_ops *ops" argument since
9905a43b2d563e6f89e4c63c4278ada03f2ebb14, nearly 11 months ago.

> > If you gate admission to linux-next with some sort of automated
> > check like this, I fear the wrath of the disgruntled masses may
> > fall upon you.
> But it seems like it might be nice to do at least something there?
I think so, in order to help janitorial work.


Lionel.
