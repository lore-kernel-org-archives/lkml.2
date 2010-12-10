Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570Ab0LJQdo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 11:33:44 -0500
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:42839 "HELO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752261Ab0LJQdm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 11:33:42 -0500
MIME-Version: 1.0
In-Reply-To: <87tyild2ms.fsf@deeprootsystems.com>
References: <cover.1290635422.git.bengardiner@nanometrics.ca>
	<cover.1291931041.git.bengardiner@nanometrics.ca>
	<87tyild2ms.fsf@deeprootsystems.com>
Date: Fri, 10 Dec 2010 11:33:41 -0500
Message-ID: <AANLkTik78Lb0ejUiAvqbkToi=QAKSXXj_6JaBkPYw70Z@mail.gmail.com>
Subject: Re: [PATCH v6 0/5] da850-evm: add gpio-{keys,leds} for UI and BB expanders
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: davinci-linux-open-source@linux.davincidsp.com,
        linux-input@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org,
        Chris Cordahi <christophercordahi@nanometrics.ca>,
        Paul Mundt <lethal@linux-sh.org>, Sekhar Nori <nsekhar@ti.com>,
        Gabor Juhos <juhosg@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

On Fri, Dec 10, 2010 at 11:16 AM, Kevin Hilman
<khilman@deeprootsystems.com> wrote:
> Hi Ben,
>
> Ben Gardiner <bengardiner@nanometrics.ca> writes:
>
>> The da850-evm baseboard (BB) and its UI board both have tca6416 IO expanders.
>> They are bootstrapped to different I2C addresses so they can be used
>> concurrently.
>>
>> The expander on the UI board is currently used to enable/disable the
>> peripherals that are available on the UI board. In addition to this
>> functionality the expander is also connected to 8 pushbuttons. The expander
>> on the baseboard is not currently used; it is connected to deep sleep enable,
>> sw reset, a push button, some switches and LEDs.
>>
>> This proposed patch series enables the push buttons and switches on the UI and
>> BB expanders using the gpio-keys polling mode patch by Gabor Juhos. Some
>> work was performed to test irq-based gpio-keys support on the expanders (a WIP
>> patch can be posted on request) but I believe that it is not possible to use
>> irq-based gpio-keys on IO expanders for arm systems at this time.
>
> Thanks for your patience and persistence on this series, and thanks for
> working closely with the input folks to get the issues worked through.

It is my pleasure.

> This series looks good to me, so I'll be queuing it in davinci-next for
> 2.6.38.  It should show up in davinci git shortly.  Please validate
> things are working as expected there.  Were there any changes needed to
> the defaults in da8xx_omapl_defconfig to enable these features by
> default?  or does the Kconfig change in PATCH 5/5 cover it?

Thank you very much, Kevin.

I will check linux-davinci/master on monday.

Yes, the 5/5 covers the necessary Kconfig changes; it makes the polled
gpio keys default-on for da850evm.

> Also, I really appreciate the thorough patch descriptions and history
> information.   This greatly eases the work of maintainers.  Thanks!

Again, you are most welcome.

> One minor question: the series has a couple of Signed-off-by tags from
> Sekhar Nori.  The s-o-b tag is for folks on the delivery path, and based
> on what I saw, these should probably be Acked-by tags from Sekhar, since
> he certainly helped on the review/test/validate side, but AFAICT, was
> not an author or on the delivery path.  If I'm wrong on this (e.g., if
> Sekhar actually did author some of those patches) let me know, otherwise
> I'll change the s-o-b to Acked-by for Sekhar.

The s-o-b 's for Sehkar are because I folded-in suggested changes
submitted in review by Sehkar in the form of a patch. I 'think' this
qualifies as authorship. I'll leave it to your good judgement.

Best Regards,
Ben Gardiner

---
Nanometrics Inc.
http://www.nanometrics.ca
