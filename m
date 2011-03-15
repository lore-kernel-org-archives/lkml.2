Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab1COHN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 03:13:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42540 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754389Ab1COHN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 03:13:57 -0400
Date: Tue, 15 Mar 2011 08:13:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Waychison <mikew@google.com>
Cc: Greg KH <greg@kroah.com>, Matt Domsch <Matt_Domsch@dell.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>, San Mehat <san@google.com>
Subject: Re: [PATCH v3 5/5] driver: Google Memory Console
Message-ID: <20110315071334.GA29969@elte.hu>
References: <20110315065839.12047.70666.stgit@mike.mtv.corp.google.com>
 <20110315065905.12047.71103.stgit@mike.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110315065905.12047.71103.stgit@mike.mtv.corp.google.com>
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


* Mike Waychison <mikew@google.com> wrote:

> +static struct dmi_system_id memconsole_dmi_table[] __initdata = {
> +	{
> +		.ident = "Google Board",
> +		.matches = {
> +			DMI_MATCH(DMI_BOARD_VENDOR, "Google, Inc."),
> +		},
> +	},
> +	{}
> +};
> +MODULE_DEVICE_TABLE(dmi, memconsole_dmi_table);
> +
> +static int __init memconsole_init(void)
> +{
> +	int ret;
> +
> +	if (!dmi_check_system(memconsole_dmi_table))
> +		return -ENODEV;
> +
> +	if (!found_memconsole())
> +		return -ENODEV;

Ok, that's a much safer method of discovery.

Acked-by: Ingo Molnar <mingo@elte.hu>

Thanks,

	Ingo
