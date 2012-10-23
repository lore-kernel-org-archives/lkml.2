Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975Ab2JWJbS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 05:31:18 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:64732 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027Ab2JWJbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 05:31:16 -0400
MIME-Version: 1.0
In-Reply-To: <5085ACCD.3040203@wwwdotorg.org>
References: <1350651909-5337-1-git-send-email-linus.walleij@stericsson.com>
	<20121019181019.GP4730@atomide.com>
	<CACRpkdZazjMoSzkr5t15-GeCnQKCJDsZyvT=KVMyw5XhjDybGQ@mail.gmail.com>
	<5085ACCD.3040203@wwwdotorg.org>
Date: Tue, 23 Oct 2012 11:31:15 +0200
Message-ID: <CACRpkdY002gNuy81_XfenQfhZnMVyAxViMhoSd3nNMH5k0=JBQ@mail.gmail.com>
Subject: Re: [PATCH v2] pinctrl: reserve pins when states are activated
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Patrice Chotard <patrice.chotard@st.com>,
        Jean Nicolas Graux <jean-nicolas.graux@stericsson.com>,
        Loic Pallardy <loic.pallardy@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 10:30 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 10/22/2012 02:21 AM, Linus Walleij wrote:

>> If this turns out to be a severe performance bottleneck, I
>> suggest to add some additional constraint API, like
>> pinctrl_set_pinmux_homegeneous_pinsets(true) that will
>> at runtime select whether the pin allocation is done when
>> getting the pinctrl handle instead.
>
> That API sounds like something system-wide, which seems like it would be
> rather presumptuous (CPU/SoC support code couldn't execute it, since
> that would presume a facet of all board designs that could change in the
> future). Even a driver shouldn't be assuming this; it can't know what
> boards it gets used in ahead of time.

Well, yeah. It should rather be part of the pinctrl descriptor
then, so it becomes a per-controller runpath simplification.

> Instead, it seems like the map registration code could easily look at
> all states defined for a device, and determine if the set of pins/groups
> used by those states was identical, and switch between up-front or
> dynamic registration as needed by the specific map entries.

That kind of constraint-resolution in the kernel scares me,
soon we will have a prolog runtime ... (but hm maybe that is not
such a bad idea considering some other constraint things I've
seen around)

Yours,
Linus Walleij
