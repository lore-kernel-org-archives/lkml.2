Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847Ab2AYB6N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 20:58:13 -0500
Received: from mail2.nsc.com ([12.238.8.132]:54916 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755786Ab2AYB6M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 20:58:12 -0500
X-WSS-ID: 0LYC04W-0A-3W1-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Mark Brown" <broonie@opensource.wolfsonmicro.com>,
        "Linus Walleij" <linus.walleij@linaro.org>
cc: "shreshthakumar.sahu@stericsson.com" 
	<shreshthakumar.sahu@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>
Date: Tue, 24 Jan 2012 17:57:35 -0800
Subject: RE: [PATCH 3/7] leds-lm3530: add 'is_vin_always_on' in the
 lm3530_platform_data
Thread-Topic: [PATCH 3/7] leds-lm3530: add 'is_vin_always_on' in the
 lm3530_platform_data
Thread-Index: AczaBZnhmOVkXEMmSQCoeTS8KdImaQA/rqEw
Message-ID: <B567DBAB974C0544994013492B949F8E3812CD3E47@EXMAIL03.scwf.nsc.com>
References: <AczXFZjmtQHOiXDCSJi9Lr1dSJlaCQ==>
 <B567DBAB974C0544994013492B949F8E3812C6D0CD@EXMAIL03.scwf.nsc.com>
 <CACRpkdbyK3eevSu3JeTzWguhJkSAm+8vmxymV03UhxhNQUtVsw@mail.gmail.com>
 <20120123193122.GB26409@opensource.wolfsonmicro.com>
In-Reply-To: <20120123193122.GB26409@opensource.wolfsonmicro.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 6301BE1B1LS9908754-02-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, I see. I'll try to follow design patterns for the regulator.
Thanks a lot for your comment.

Best Regards,
Milo -


-----Original Message-----
From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com] 
Sent: Tuesday, January 24, 2012 4:31 AM
To: Linus Walleij
Cc: Kim, Milo; shreshthakumar.sahu@stericsson.com; linux-kernel@vger.kernel.org; rpurdie@rpsys.net
Subject: Re: [PATCH 3/7] leds-lm3530: add 'is_vin_always_on' in the lm3530_platform_data

On Mon, Jan 23, 2012 at 08:13:18PM +0100, Linus Walleij wrote:

> As far as I know we want to get rid of different design patterns
> avoiding the regulator interface. The way forward for this is
> either:

> (A) Provide a fixed voltage regulator in your platform for this
>   device (AFAIK the voltage does not even have to be correct)
> (B) Enable dummy regulators in your platform

> (A) is more elegant.

Yeah, regulator usage should essentially never be conditional at a
driver level unless there's actual optional supplies in the hardware.
The situation has never been any different to that.

