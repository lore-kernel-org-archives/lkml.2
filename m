Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab2DCNlq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 09:41:46 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60820 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab2DCNln convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 09:41:43 -0400
From: "AnilKumar, Chimata" <anilkumar@ti.com>
To: Wolfgang Grandegger <wg@grandegger.com>
CC: "socketcan@hartkopp.net" <socketcan@hartkopp.net>,
        "m.kleine-budde@pengutronix.de" <m.kleine-budde@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gole, Anant" <anantgole@ti.com>, "Nori, Sekhar" <nsekhar@ti.com>
Subject: RE: [PATCH] ARM: OMAP: AM33XX: CAN: d_can: Add support for Bosch
 D_CAN controller
Thread-Topic: [PATCH] ARM: OMAP: AM33XX: CAN: d_can: Add support for Bosch
 D_CAN controller
Thread-Index: AQHNEZXW4WifiYIc20mGGxLe7+r04paIr8SAgABeuVA=
Date: Tue, 3 Apr 2012 13:41:28 +0000
Message-ID: <331ABD5ECB02734CA317220B2BBEABC1317D85D0@DBDE01.ent.ti.com>
References: <1333456339-9372-1-git-send-email-anilkumar@ti.com>
 <4F7AF0C7.7020506@grandegger.com>
In-Reply-To: <4F7AF0C7.7020506@grandegger.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: BBTN CLON HEvN OwTC Xd08 enbr kJiW oRNG qir+ sdzJ u553
 0lI5 2GLQ ACFWLw== ADQ8QQ==
 AECc4g==;7;bABpAG4AdQB4AC0AYwBhAG4AQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBsAGkAbgB1AHgALQBvAG0AYQBwAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBtAC4AawBsAGUAaQBuAGUALQBiAHUAZABkAGUAQABwAGUAbgBnAHUAdAByAG8AbgBpAHgALgBkAGUAOwBuAGUAdABkAGUAdgBAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAcwBvAGMAawBlAHQAYwBhAG4AQABoAGEAcgB0AGsAbwBwAHAALgBuAGUAdAA7AHcAZwBAAGcAcgBhAG4AZABlAGcAZwBlAHIALgBjAG8AbQA=;Sosha1_v1;7;{78BEB024-26CA-4E95-A704-01B6FFAD8EAD};YQBuAGkAbABrAHUAbQBhAHIAQAB0AGkALgBjAG8AbQA=;Tue,
 03 Apr 2012 13:41:13
 GMT;UgBFADoAIABbAFAAQQBUAEMASABdACAAQQBSAE0AOgAgAE8ATQBBAFAAOgAgAEEATQAzADMAWABYADoAIABDAEEATgA6ACAAZABfAGMAYQBuADoAIABBAGQAZAAgAHMAdQBwAHAAbwByAHQAIABmAG8AcgAgAEIAbwBzAGMAaAAgAEQAXwBDAEEATgAgAGMAbwBuAHQAcgBvAGwAbABlAHIA
x-cr-puzzleid: {78BEB024-26CA-4E95-A704-01B6FFAD8EAD}
x-originating-ip: [172.24.132.227]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfgang,

Thanks for reviewing the patch

On Tue, Apr 03, 2012 at 18:14:55, Wolfgang Grandegger wrote:
> On 04/03/2012 02:32 PM, AnilKumar Ch wrote:
> > This patch adds the support for Bosch D_CAN controller.
> > 
> > Bosch D_CAN controller is a full-CAN implementation compliant to
> > CAN protocol version 2.0 part A and B. Bosch D_CAN user manual
> > can be obtained from: http://www.semiconductors.bosch.de/media/
> > en/pdf/ipmodules_1/can/d_can_users_manual_111.pdf
> > 
> > D_CAN device is used on many SoCs like AM335x, DM8148 and DM813x
> > EVMs from TI, D_CAN details on AM335x can be accessed from:
> > http://www.ti.com/lit/ug/spruh73c/spruh73c.pdf
> > 
> > D_CAN can be configurable for 16, 32, 64 and 128 message objects.
> > The driver implementation is based on 64 message objects.
> > 
> > Following are the design choices made while writing the controller
> > driver:
> > 1. Interface Register set IF0 has be used for receive and IF1 is
> >    used for transmit message objects.
> > 2. Out of the total Message objects available, half of it are kept
> >    aside for RX purposes and the rest for TX purposes.
> > 3. NAPI implementation is such that both the TX and RX paths
> >    functions in polling mode.
> > 
> > Signed-off-by: AnilKumar Ch <anilkumar@ti.com>
> 
> Please explain why this CAN controller cannot be handled by the existing
> C_CAN driver, eventually with some extensions. The register layout seems
> almost identical, at least.
> 
> Wolfgang.
> 

These are the some of the pointers I can say, why I had gone for separate
file instead of existing driver:
* In case of D_CAN driver we can see all the registers are 32bit length
  but in case of C_CAN registers are in 16bit length.
* Some of the registers, bit masks are different, so we have to add
  checks on every API for differentiating the kind of device
* In case of D_CAN we have some extra features like direct message RAM
  access, DMA support, TX/RX pins can be used as GPIO lines (if applicable),
  more interrupt lines and three sets of interface registers.
* Wait timings while init bit set/reset during bit-timing initialization
  are different in both the cases
* bittiming configurations are different.

Thanks
AnilKumar
