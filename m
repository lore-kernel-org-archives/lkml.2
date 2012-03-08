Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734Ab2CHWBH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 17:01:07 -0500
Received: from antcom.de ([188.40.178.216]:46017 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758604Ab2CHWBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 17:01:05 -0500
Message-ID: <4F592C1C.1050909@antcom.de>
Date: Thu, 08 Mar 2012 23:01:00 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120216 Icedove/8.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, w.sang@pengutronix.de,
        kevin.wells@nxp.com, linux-arm-kernel@lists.infradead.org,
        arnd@arndb.de
Subject: Re: [PATCH RESEND v3] USB: Support for LPC32xx SoC
References: <1331068913-9321-1-git-send-email-stigge@antcom.de> <20120308211120.GB21058@kroah.com>
In-Reply-To: <20120308211120.GB21058@kroah.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/12 22:11, Greg Kroah-Hartman wrote:
>> -	pnx4008_unset_usb_bits();
>> +	if (machine_is_pnx4008())
>> +		pnx4008_unset_usb_bits();
> 
> How come some of these pnx4008_* functions you have wrapped in
> machine_is_pnx4008(), but not all of them?
> 
> Actually, why don't those functions do that kind of checking themselves,
> without having to do this before you call them each time?

Good idea, I moved the machine dependent execution of the bits()
functions into the functions.

The dependency is only in the bits functions because those are done via
interfaces not available on LPC. The other pnx4008 functions seem to be
mostly compatible.

Thanks for your notes!

Roland
