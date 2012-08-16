Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab2HPKmk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 06:42:40 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:43768 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab2HPKmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 06:42:39 -0400
Date: Thu, 16 Aug 2012 13:42:34 +0300
From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To: Richard Genoud <richard.genoud@gmail.com>,
        Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] UBI: replace MTD_UBI_BEB_LIMIT with user-space
 parameter
Message-ID: <20120816134234.32b468f6@pixies.home.jungo.com>
In-Reply-To: <CACQ1gAhFJ6AKYJpc1ZiHm+3Y=APnwUmVL3f0KW=OFMDMWzCVJg@mail.gmail.com>
References: <1341937423-16516-1-git-send-email-richard.genoud@gmail.com>
	<1341937423-16516-5-git-send-email-richard.genoud@gmail.com>
	<20120816115713.726da8f2@pixies.home.jungo.com>
	<CACQ1gAhFJ6AKYJpc1ZiHm+3Y=APnwUmVL3f0KW=OFMDMWzCVJg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard, Artem,

On Thu, 16 Aug 2012 12:07:01 +0200 Richard Genoud <richard.genoud@gmail.com> wrote:
> > With you approach, these system MUST pass the limit parameter via the
> > ioctl / module-parameter.
> That's right.
> We can add a kernel config option to change the max_beb_per1024
> default value (actually, this is almost the patch I send first).
> But I see something disturbing with that:
> It means that an ubi_attach call from userspace, without specifying
> max_beb_per1024, won't have the same result, depending of the default
> config value the kernel has been compiled with.
> (Or maybe this behavior is acceptable).

Well, that was the previous behavior of MTD_UBI_BEB_RESERVE, long before
our patchsets.
I think it is acceptable, given the fact it simplifies the configuration
for most simple systems.

Anyway I'm just pointing out the consequences of your change and try to
suggest other alternatives.
Artem should decide as he's the maintainer.

> > Also, since max_beb_per1024 is always set, how one may specify a zero
> > limit?
> You can't.
> Do you think we need that ?

Well again, originally, prior our patchsets, one *could* set a zero
MTD_UBI_BEB_RESERVE for his system. So we're introducing a change that
affects the possible ways an ubi system can be configured, banning
a configuration that was valid in the past.

Does it make sense to set a zero limit? dunno.
For testing purposes, maybe.

Artem, what do you think? prohibit a zero beb limit?

Regards,
Shmulik
