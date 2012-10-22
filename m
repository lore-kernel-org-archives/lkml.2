Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab2JVTHw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 15:07:52 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:39803 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755956Ab2JVTHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 15:07:50 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+4YpmkDNnOl3urgCabZ+Ee
Date: Mon, 22 Oct 2012 12:07:45 -0700
From: Tony Lindgren <tony@atomide.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Patrice Chotard <patrice.chotard@st.com>,
        Jean Nicolas Graux <jean-nicolas.graux@stericsson.com>,
        Loic Pallardy <loic.pallardy@st.com>
Subject: Re: [PATCH v2] pinctrl: reserve pins when states are activated
Message-ID: <20121022190743.GE4730@atomide.com>
References: <1350651909-5337-1-git-send-email-linus.walleij@stericsson.com>
 <20121019181019.GP4730@atomide.com>
 <CACRpkdZazjMoSzkr5t15-GeCnQKCJDsZyvT=KVMyw5XhjDybGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZazjMoSzkr5t15-GeCnQKCJDsZyvT=KVMyw5XhjDybGQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Walleij <linus.walleij@linaro.org> [121022 01:22]:
> On Fri, Oct 19, 2012 at 8:10 PM, Tony Lindgren <tony@atomide.com> wrote:
> > [Me]
> >> Instead: let use reserve the pins when the state is activated
> >> and drop them when the state is disabled, i.e. when we move to
> >> another state. This way different devices/functions can use the
> >> same pins at different times.
> >
> > Hmm doesn't this mean that we are now doing lots of extra
> > reserving and dropping of pins? Performance is important from
> > latency point of view for cases where we need to remux pins
> > constantly runtime PM.
> 
> It is only done in case the pinmux state is switched in runtime
> suspend/resume, so it's e.g. possible to just alter the pin config.
> 
> But in general what you say is true.
> 
> We used to to the same thing by having drivers call
> pinctrl_get()/pinctrl_put() in this case instead, but that went
> away with the introduction of states, so we cannot encode
> different pin sets with say
> pinctrl_get(dev, "foo")/pinctrl_get(dev, "bar")
> anymore since there is only one pinctrl handle per device,
> but multiple states.

OK
 
> If this turns out to be a severe performance bottleneck, I
> suggest to add some additional constraint API, like
> pinctrl_set_pinmux_homegeneous_pinsets(true) that will
> at runtime select whether the pin allocation is done when
> getting the pinctrl handle instead.

Or maybe you could release + reserve the pins only if the
pins change?

Regards,

Tony
