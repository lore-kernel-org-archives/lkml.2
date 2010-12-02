Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959Ab0LBVxx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 16:53:53 -0500
Received: from bosmailout03.eigbox.net ([66.96.187.3]:43817 "EHLO
	bosmailout03.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757144Ab0LBVxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 16:53:51 -0500
X-Greylist: delayed 1887 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Dec 2010 16:53:51 EST
X-EN-OrigOutIP: 10.20.18.12
X-EN-IMPSID: eMN41f0060FdZ9W01MN49Y
Message-ID: <4CF80DC6.1020801@yahoo.es>
Date: Fri, 03 Dec 2010 05:21:10 +0800
From: Hein_Tibosch <hein_tibosch@yahoo.es>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Sahitya Tummala <stummala@codeaurora.org>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Pierre Ossman <pierre@ossman.eu>, Chris Ball <cjb@laptop.org>,
        Ben Nizette <bn@niasdigital.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Adrian Hunter <adrian.hunter@nokia.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH v4] mmc: Make ID freq configurable
References: <4C80187D.9000304@yahoo.es> <1291288582.15187.91.camel@stummala-linux.in.qualcomm.com>
In-Reply-To: <1291288582.15187.91.camel@stummala-linux.in.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 3946c951b80c12a8be5482963a0b1232:e0ae43bc192b431f8b69f09a37527cbc
X-EN-AuthUser: hein@htibosch.net
X-EN-OrigIP: 202.70.59.250
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sahitya,

On 2-12-2010 19:16, Sahitya Tummala wrote:
> Hi Hein Tibosch,
>
> On Fri, 2010-09-03 at 05:34 +0800, Hein_Tibosch wrote:
>> In the latest releases of the mmc driver, the freq during initialization
>> is set to a fixed 400 Khz. This was reportedly too fast for several
>> users. As there doesn't seem to be an ideal frequency which-works-for-all,
>> Pierre suggested to let the driver try several frequencies.
>> <cut>
>> +		/*
>> +		 * First we search for SDIO...
>> +		 */
>> +		err = mmc_send_io_op_cond(host, 0, &ocr);
>> +		if (!err) {
>> +			if (mmc_attach_sdio(host, ocr)) {
>> +				mmc_claim_host(host);
>> +				/* try SDMEM (but not MMC) even if SDIO is broken */
>> +				if (mmc_send_app_op_cond(host, 0, &ocr))
> In case of SDIO error, mmc_power_off() is getting called as part of
> mmc_detach_bus().  Shouldn't we power up the host before checking for
> SDMEM? Any comments?
>
I think you should ask Michal Miroslaw, as he wrote the patch for the
SD-combo (IO + mem)*

But yes, in case of a failure, mmc_attach_sdio() will call mmc_detach_bus()
which in turn will call mmc_power_off()

And so it should be mmc_power_up() again before trying to detect SD memory.


Hein Tibosch

* http://permalink.gmane.org/gmane.linux.kernel.mmc/2052
