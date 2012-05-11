Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759453Ab2EKMr6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 08:47:58 -0400
Received: from antcom.de ([188.40.178.216]:35811 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758563Ab2EKMr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 08:47:57 -0400
Message-ID: <4FAD0A79.8040207@antcom.de>
Date: Fri, 11 May 2012 14:47:53 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120216 Icedove/8.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Grant Likely <grant.likely@secretlab.ca>, arm@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, devicetree-discuss@lists.ozlabs.org,
        rob.herring@calxeda.com
Subject: Re: [PATCH RESEND v8] gpio: Device tree support for LPC32xx
References: <1336679838-30738-1-git-send-email-stigge@antcom.de> <20120510234100.7F5463E04A6@localhost> <201205111219.10025.arnd@arndb.de>
In-Reply-To: <201205111219.10025.arnd@arndb.de>
X-Enigmail-Version: 1.3.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2012 02:19 PM, Arnd Bergmann wrote:
> On Thursday 10 May 2012, Grant Likely wrote:
>> How about the following instead (very rough, there should be a cleaner
>> way to update the gc pointer in of_xlate):
>>
>>         gpio: gpio@40028000 {
>>                 compatible = "nxp,lpc3220-gpio";
>>                 reg = <0x40028000 0x1000>;
>>                 gpio-controller;
>>                 #gpio-cells = <3>; /* bank, pin, flags */
>>         }
>>
> 
> I thought about that when I suggested the current binding to Roland,
> but the problem with this is that passing the bank as a number is
> not very intuitive when the data sheet has separate number spaces
> for gpio, gpi and gpo here, so it seemed more natural to go with what
> the data sheet describes.

Right. Personally, I would be fine with either of my v8 (all banks in
dt, referenced naturally by name) and v9 (one simple DT entry for the
whole GPIO controller, integer index for referencing banks) patches.

Consider the DT-documented mapping in the latter case:

      0: GPIO P0
      1: GPIO P1
      2: GPIO P2
      3: GPIO P3
      4: GPI P3
      5: GPO P3

Not too difficult and would also be acceptable, IMO.

So Arnd and Grant, please agree one of those and pick it. :-)

Thanks in advance,

Roland
