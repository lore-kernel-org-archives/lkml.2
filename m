Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686Ab0KWNcg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 08:32:36 -0500
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:57265 "HELO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752474Ab0KWNce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 08:32:34 -0500
MIME-Version: 1.0
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593024793124F@dbde02.ent.ti.com>
References: <cover.1289835508.git.bengardiner@nanometrics.ca>
	<cover.1289935504.git.bengardiner@nanometrics.ca>
	<d6d59b4a3c34149008f3681e0d6106efa15f354d.1289935504.git.bengardiner@nanometrics.ca>
	<B85A65D85D7EB246BE421B3FB0FBB59302477EAA89@dbde02.ent.ti.com>
	<AANLkTike4sRvptEe9PXLT2u+SrFMOpNC6pvLPSzBfVOX@mail.gmail.com>
	<B85A65D85D7EB246BE421B3FB0FBB59302477EB2D8@dbde02.ent.ti.com>
	<AANLkTin8+y0xkjv+RmnSZNKXgfwr2iV3c9P7cBMfVw3k@mail.gmail.com>
	<B85A65D85D7EB246BE421B3FB0FBB593024793124F@dbde02.ent.ti.com>
Date: Tue, 23 Nov 2010 08:32:34 -0500
Message-ID: <AANLkTi=JBWmwa6gaLH9+vU6hWPvZaT7_WH0jJ0iDuzks@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] da850-evm: add baseboard UI expander buttons,
 switches and LEDs
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: "Nori, Sekhar" <nsekhar@ti.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Govindarajan, Sriramakrishnan" <srk@ti.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexander Clouter <alex@digriz.org.uk>,
        Chris Cordahi <christophercordahi@nanometrics.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sekhar,

On Tue, Nov 23, 2010 at 7:42 AM, Nori, Sekhar <nsekhar@ti.com> wrote:
> On Mon, Nov 22, 2010 at 19:45:46, Ben Gardiner wrote:
>> [...]
>> I was assuming that those pins were not exported as gpio pins on
>> purpose; I was taking the prudent approach to prevent haphazard
>> toggling of sw_rst and deep_sleep_en from userspace. sw_rst because it
>> could initiate a reset of the cpu when toggled and deep_sleep_en
>> because it can override the behaviour of davinci_pm_enter().
>>
>> I'm not sure how they would be used by existing kernel classes either.
>> The sw_rst pin could be used for reset but since it is on the other
>> end of an i2c bus and there is an existing implementation of reset
>> using the on chip watchdog I don't think it would be benficial to
>> switch. Deep_sleep_en could override the behaviour in
>> davinci_pm_enter() -- _maybe_ (I don't really know) it could be used
>> as a hardware-assisted suspend-blocker? But I totally guessing here.
>
> My preference would be to leave these pins as is
> (don't call a gpio_request() on them) till someone
> comes up with a use case for them. From what you
> described, sysfs access cannot happen "accidently"
> so someone accessing these pins from sysfs surely
> knows what he is doing.

No problem. I will re-spin the patch shortly with the deep_sleep_en
and sw_rst pins free for use by client code.

Best Regards,
Ben Gardiner

---
Nanometrics Inc.
http://www.nanometrics.ca
