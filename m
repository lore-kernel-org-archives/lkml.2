Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab0KVOPu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 09:15:50 -0500
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:60287 "HELO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754983Ab0KVOPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 09:15:49 -0500
MIME-Version: 1.0
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB59302477EB2D8@dbde02.ent.ti.com>
References: <cover.1289835508.git.bengardiner@nanometrics.ca>
	<cover.1289935504.git.bengardiner@nanometrics.ca>
	<d6d59b4a3c34149008f3681e0d6106efa15f354d.1289935504.git.bengardiner@nanometrics.ca>
	<B85A65D85D7EB246BE421B3FB0FBB59302477EAA89@dbde02.ent.ti.com>
	<AANLkTike4sRvptEe9PXLT2u+SrFMOpNC6pvLPSzBfVOX@mail.gmail.com>
	<B85A65D85D7EB246BE421B3FB0FBB59302477EB2D8@dbde02.ent.ti.com>
Date: Mon, 22 Nov 2010 09:15:46 -0500
Message-ID: <AANLkTin8+y0xkjv+RmnSZNKXgfwr2iV3c9P7cBMfVw3k@mail.gmail.com>
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

On Mon, Nov 22, 2010 at 7:00 AM, Nori, Sekhar <nsekhar@ti.com> wrote:
> Thanks for the explanation. I should have probably asked
> earlier, why do we need to prevent sysfs access of
> deep sleep enable and sw reset pins? We don't seem to be
> using them in the kernel either.

You're welcome.

I was assuming that those pins were not exported as gpio pins on
purpose; I was taking the prudent approach to prevent haphazard
toggling of sw_rst and deep_sleep_en from userspace. sw_rst because it
could initiate a reset of the cpu when toggled and deep_sleep_en
because it can override the behaviour of davinci_pm_enter().

I'm not sure how they would be used by existing kernel classes either.
The sw_rst pin could be used for reset but since it is on the other
end of an i2c bus and there is an existing implementation of reset
using the on chip watchdog I don't think it would be benficial to
switch. Deep_sleep_en could override the behaviour in
davinci_pm_enter() -- _maybe_ (I don't really know) it could be used
as a hardware-assisted suspend-blocker? But I totally guessing here.

Best Regards,
Ben Gardiner

---
Nanometrics Inc.
http://www.nanometrics.ca
