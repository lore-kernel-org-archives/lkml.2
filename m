Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab2D0Fsu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 01:48:50 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:41722 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab2D0Fst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 01:48:49 -0400
Date: Fri, 27 Apr 2012 13:48:44 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Dong Aisheng <b29396@freescale.com>, b20223@freescale.com,
        linus.walleij@stericsson.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        kernel@pengutronix.de, cjb@laptop.org, s.hauer@pengutronix.de,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 2/4] pinctrl: pinctrl-imx: add imx pinctrl core driver
Message-ID: <20120427054842.GJ2234@S2101-09.ap.freescale.net>
References: <1335451227-27709-1-git-send-email-b29396@freescale.com>
 <1335451227-27709-2-git-send-email-b29396@freescale.com>
 <20120426144446.GN9142@game.jcrosoft.org>
 <20120426151536.GO9142@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120426151536.GO9142@game.jcrosoft.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 05:15:36PM +0200, Jean-Christophe PLAGNIOL-VILLARD wrote:
> We have on Imx mxc at91 and other SoC controler hich you configure per pin
> 
> which means one pin have multiple function and the same function is on
> multiple pins
> 
> so the groups are just a list of possible pins
> 
> Instead of re-inventing bindings we do need to come with a common binding whre
> it's possible
> 
> So instead I proppose (send in the v2) to use common way to describe the group
> 
Let's see how many nodes we will have in device tree.  For imx6q
example, there are 332 pins and each pin has up to 8 function selects.
We will end up with having 332 x 8 = 2656 sub nodes under node
"functions".  Device tree simply cannot afford such a bloating.

Regards,
Shawn

> 1) we describe one function per pin
> 
> 	functions {
> 		rxd_pb12 {
> 			atmel,pin-id = <44>;
> 			atmel,mux = <0>;
> 		};
> 
> 		txd_pb13 {
> 			atmel,pin-id = <45>;
> 			atmel,pull = <2>;
> 			atmel,mux = <0>;
> 		};
> 
> 		txd0_pb19 {
> 			atmel,pin-id = <51>;
> 			atmel,pull = <2>;
> 			atmel,mux = <0>;
> 		};
> 
> 		rxd0_pb18 {
> 			atmel,pin-id = <50>;
> 			atmel,mux = <0>;
> 		};
> 
> 		rts0_pb17 {
> 			atmel,pin-id = <49>;
> 			atmel,mux = <1>;
> 		};
> 
> 		cts0_pb15 {
> 			atmel,pin-id = <47>;
> 			atmel,mux = <1>;
> 		};
> 	};
> 
> 
> advantage if you need to set a pull-up or any pin parameter different on your board
> you can overwrite it without re-creating a group
> 
> This is controller specific
> 
> and then we have the common bindings to describe the group
> by using phandle of the functions to describe the group
> 
> 	groups {
> 		dbgu {
> 			pinctrl,functions = < &rxd_pb12
> 					      &txd_pb13 >;
> 		};
> 
> 		uart0_rxd_txd {
> 			pinctrl,functions = < &rxd0_pb18
> 					      &txd0_pb19 >;
> 		};
> 
> 		uart0_rts_cts {
> 			pinctrl,functions = < &rxd0_pb18
> 					      &txd0_pb19
> 					      &rts0_pb17
> 					      &cts0_pb15 >;
> 		};
> 	};
> 
> this will be handle by a generic code in c
> 
> Best Regards,
> J.
