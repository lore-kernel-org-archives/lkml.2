Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab1HWWL6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 18:11:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:32912 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730Ab1HWWLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 18:11:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Subject: Re: try_to_freeze() called with IRQs disabled on ARM
Date: Wed, 24 Aug 2011 00:13:40 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <20110823151936.GM9232@opensource.wolfsonmicro.com> <201108232351.55432.rjw@sisk.pl> <CAOS58YNUSn2eVLDLzqKmrtL7M5tSetkhZ1ODecLK54NSDnZVAA@mail.gmail.com>
In-Reply-To: <CAOS58YNUSn2eVLDLzqKmrtL7M5tSetkhZ1ODecLK54NSDnZVAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108240013.40705.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 23, 2011, Tejun Heo wrote:
> Hello,
> 
> On Tue, Aug 23, 2011 at 11:51 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> and the boot runs very slowly.  Reverting the series merged in 56f0be
> >> appears to resolve the issue,
> >
> > In fact, the patch from:
> >
> > https://patchwork.kernel.org/patch/1083602/
> >
> > is sufficient to make the calltrace go away.
> 
> Yes, that's true but the added might_sleep() discovered an actual bug
> here, so I still think it's better to keep it there.

Well, I think we _have_ _to_ put it into __refrigerator() at least until
the ARM issue is fixed (other architectures seem to do similar things, BTW),
since otherwise this can be reported over and over again.

Let's try to fix the known issues first and _then_ we can move the
might_sleep() back into try_to_freeze().

Thanks,
Rafael
