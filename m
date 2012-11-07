Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751367Ab2KGGlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 01:41:19 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:64176 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab2KGGlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 01:41:18 -0500
MIME-Version: 1.0
In-Reply-To: <50990849.4050003@st.com>
References: <1352170552-29564-1-git-send-email-omar.luna@linaro.org>
	<1352170552-29564-3-git-send-email-omar.luna@linaro.org>
	<50990849.4050003@st.com>
Date: Wed, 7 Nov 2012 00:41:17 -0600
Message-ID: <CALLhW=486Vf22Pag-N59kDcYvCDoF_ZF0AjazH7s5bnBzqCfsg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mailbox: split internal header from API header
From: Omar Ramirez Luna <omar.luna@linaro.org>
To: Loic PALLARDY <loic.pallardy@st.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Arnd Bergmann <arnd@arndb.de>, Ohad Ben-Cohen <ohad@wizery.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dom Cobley <popcornmix@gmail.com>, Wim Van Sebroeck <wim@iguana.be>,
        Linus Walleij <linus.walleij@linaro.org>, Suman Anna <s-anna@ti.com>,
        Juan Gutierrez <jgutierrez@ti.com>,
        Felipe Contreras <felipe.contreras@nokia.com>,
        Tejun Heo <tj@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Loic,

On 6 November 2012 06:53, Loic PALLARDY <loic.pallardy@st.com> wrote:
>
>
> On 11/06/2012 03:55 AM, Omar Ramirez Luna wrote:
>> Now internal structures can remain hidden to the user and just API
>> related functions and defines are made available.
>>
>> Signed-off-by: Omar Ramirez Luna<omar.luna@linaro.org>
>> ---
>>   drivers/mailbox/mailbox.c |   34 ++++++++++++++++++++++++++++++++
>>   drivers/mailbox/mailbox.h |   48 +--------------------------------------------
>>   include/linux/mailbox.h   |   22 +++++++++++++++++++
> I agree with the file split but I think mailbox framework API should be
> more generic.
> omap_ prefix should not be used. mailbox_ prefix will be better.

Ok.

> Message type must be more opened like for example:
> struct mailbox_msg {
>         int             size;
>         unsigned char   header;
>         unsigned char   *pdata;
> };

We can analyze the requirement for having such structure, presumably
you expect variable size messages, in OMAP case it is a 4 byte value,
but I'm open to change in order to accommodate other users needs.

Cheers,

Omar
