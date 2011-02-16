Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095Ab1BPItJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 03:49:09 -0500
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:33005 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753046Ab1BPItG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 03:49:06 -0500
Message-ID: <4D5B8F61.3090105@stericsson.com>
Date: Wed, 16 Feb 2011 09:48:33 +0100
From: Linus Walleij <linus.walleij@stericsson.com>
Organization: ST-Ericsson SA
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Cc: "dilinger@queued.net" <dilinger@queued.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: platform data and mfd design question
References: <4D5AF554.2030208@codeaurora.org>
In-Reply-To: <4D5AF554.2030208@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2011 10:51 PM, Abhijeet Dharmapurikar wrote:
> Msm on the other hand declares the struct mfd_cell subdevice[] array in
> the board file and passes this on to the core driver via platfom data.
>    

This way the platform data tells the core driver what kind of
silicon it has "hey, PM8058, guess what, you have an RTC!"
which looks backwards to me, especially given that it does
not need any fancy platform data at all, just two IRQ numbers
which the core driver can very well handle.

For example: if the platform data (which is about how the
components are connected on the board etc) does not
provide the RTC resource, all of a sudden it appears to the
system as if the PM8058 does not have an RTC, but it does...


Yours,
Linus Walleij
