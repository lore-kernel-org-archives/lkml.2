Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab1EDJW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 05:22:28 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:40466 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751699Ab1EDJW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 05:22:27 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18MBuxjeR/HnEDYEr/wIbz+
Date: Wed, 4 May 2011 02:22:19 -0700
From: Tony Lindgren <tony@atomide.com>
To: Colin Cross <ccross@google.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>,
        Martin Persson <martin.persson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Erik Gilling <konkers@google.com>
Subject: Re: [PATCH 1/4] drivers: create a pinmux subsystem
Message-ID: <20110504092219.GW2092@atomide.com>
References: <1304363786-30376-1-git-send-email-linus.walleij@stericsson.com>
 <74CDBE0F657A3D45AFBB94109FB122FF0497F1B201@HQMAIL01.nvidia.com>
 <BANLkTimKU-=GXzrn8=MQn-GAmKHOvKmuNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimKU-=GXzrn8=MQn-GAmKHOvKmuNQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Colin Cross <ccross@google.com> [110502 14:26]:
> On Mon, May 2, 2011 at 1:52 PM, Stephen Warren <swarren@nvidia.com> wrote:
> 
> * Drive strength is also controlled through groups of pins, but
> different groups than pinmux.  Most of the drive strength groups are
> collections of pad mux groups, but there are a few pins that are in
> the same pad mux group but a different drive strength group.
> * Setting a pin as a GPIO overrides its group's mux setting, except
> for the group's tristate.  You must untristate the entire group to use
> a single pin as a GPIO.
> * Each group has a "safe mode", but which mux id to select to enter
> the safe mode is completely random.

Just posted something in this thread regarding using standard data and
standard read and write functions, then allow setting platform specific
custom flags as needed. Care to see if that works for you too?
 
> In the end, we determined that there was no way to sanely handle
> setting up Tegra's pinmux programatically, and instead required each
> board to pass in a table of pinmux settings.

Eventually we should get the package specific table of available pins
and the board specific settings in devicetree data. And then it's
easy to set the pins as desired while being able to debug it.

Regards,

Tony
