Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab2KFMzI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 07:55:08 -0500
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:52069 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751454Ab2KFMzG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 07:55:06 -0500
From: Loic PALLARDY <loic.pallardy@st.com>
To: Omar Ramirez Luna <omar.luna@linaro.org>
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
Date: Tue, 6 Nov 2012 13:53:29 +0100
Subject: Re: [PATCH v2 2/2] mailbox: split internal header from API header
Thread-Topic: [PATCH v2 2/2] mailbox: split internal header from API header
Thread-Index: Ac28Hbk/LGQ71AyyQgGnoZyf+wqnXA==
Message-ID: <50990849.4050003@st.com>
References: <1352170552-29564-1-git-send-email-omar.luna@linaro.org>
 <1352170552-29564-3-git-send-email-omar.luna@linaro.org>
In-Reply-To: <1352170552-29564-3-git-send-email-omar.luna@linaro.org>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120412
 Thunderbird/11.0.1
acceptlanguage: fr-FR, en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/06/2012 03:55 AM, Omar Ramirez Luna wrote:
> Now internal structures can remain hidden to the user and just API
> related functions and defines are made available.
>
> Signed-off-by: Omar Ramirez Luna<omar.luna@linaro.org>
> ---
>   drivers/mailbox/mailbox.c |   34 ++++++++++++++++++++++++++++++++
>   drivers/mailbox/mailbox.h |   48 +--------------------------------------------
>   include/linux/mailbox.h   |   22 +++++++++++++++++++
I agree with the file split but I think mailbox framework API should be 
more generic.
omap_ prefix should not be used. mailbox_ prefix will be better.
Message type must be more opened like for example:
struct mailbox_msg {
	int		size;
	unsigned char	header;
	unsigned char	*pdata;
};

Regards,
Loic