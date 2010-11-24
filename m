Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999Ab0KXRR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 12:17:57 -0500
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:55336 "HELO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752960Ab0KXRRz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 12:17:55 -0500
MIME-Version: 1.0
In-Reply-To: <20101124060913.GE11705@linux-sh.org>
References: <cover.1289835508.git.bengardiner@nanometrics.ca>
	<cover.1289935504.git.bengardiner@nanometrics.ca>
	<95f48a32a0256ecdb7148aa08d16f64928a7e5d8.1289935504.git.bengardiner@nanometrics.ca>
	<B85A65D85D7EB246BE421B3FB0FBB59302477EA939@dbde02.ent.ti.com>
	<AANLkTi=HS7ym8n6=hF8vAg2WR33Md5=YRZL2NS7a+F2y@mail.gmail.com>
	<B85A65D85D7EB246BE421B3FB0FBB59302477EB2BE@dbde02.ent.ti.com>
	<AANLkTimRbsmR6xMok8P_wXpQAd1Xykew6_pPhqUWGsEN@mail.gmail.com>
	<B85A65D85D7EB246BE421B3FB0FBB5930247931247@dbde02.ent.ti.com>
	<8739qshwhm.fsf@deeprootsystems.com>
	<20101124060913.GE11705@linux-sh.org>
Date: Wed, 24 Nov 2010 12:17:52 -0500
Message-ID: <AANLkTinJ3WvwXARYthNaFKSeSFoqHzb0fY9yiA1KzR=R@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] da850-evm: add UI Expander pushbuttons
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Govindarajan, Sriramakrishnan" <srk@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexander Clouter <alex@digriz.org.uk>,
        Chris Cordahi <christophercordahi@nanometrics.ca>,
        Gabor Juhos <juhosg@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Wed, Nov 24, 2010 at 1:09 AM, Paul Mundt <lethal@linux-sh.org> wrote:
> On Tue, Nov 23, 2010 at 07:48:21AM -0800, Kevin Hilman wrote:
>> [...]
>> Agreed.  In general, we should not have machine/platform specific
>> conditionals in generic Kconfigs.   Generally, this should be handled in
>> machine/platform specific Kconfigs.
>>
> The patch that I originally wrote for this had the select under the
> Kconfig option for the driver itself, with the decision to use it or not
> being dynamically determined based on the platform data. I maintain that
> this is the only sensible way to deal with things, but this was rejected
> by the input folks at the time who felt that it was adding in extra
> overhead for a corner case. The alternatives then are to either make an
> identical copy of the driver that uses a polled interface, come up with
> lame INPUT_POLLDEV wrapper shims, or simply accept the fact that drivers
> using optional interfaces are going to have to have those interfaces
> built in to the kernel.

Thanks for weighing-in.

>From the statements that Dmitry has made [1] [2], I gather that a
separate driver is preferred. But I realized this too late.

I've tested the recent re-send of "[PATCH 09/18] input: add input
driver for polled GPIO buttons" by Gabor Juhos [3] with this patch
series and it works well. The changes needed in this patch series are
minimal. I have some review comments for the gpio_buttons patch that I
will be posting shortly.

The upshot is there will be no need for Kconfig entries for both
INPUT_POLLDEV and KEYBOARD_GPIO in arch/arm/mach-davinci, just one to
enable the gpio_buttons driver.

-- 
Best Regards,
Ben Gardiner

[1] http://article.gmane.org/gmane.linux.kernel.input/14044
[2] http://article.gmane.org/gmane.linux.kernel.input/16478
[3] http://article.gmane.org/gmane.linux.kernel.input/16610

---
Nanometrics Inc.
http://www.nanometrics.ca
