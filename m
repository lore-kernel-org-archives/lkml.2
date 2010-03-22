Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524Ab0CVVZs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 17:25:48 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:55075 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756488Ab0CVVZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 17:25:46 -0400
X-Auth-Info: VjE4svEAlDM+rpWBUfiGtvWqicIJzhWzsctb0kGmg9w=
Message-ID: <4BA7DFF8.4060407@grandegger.com>
Date: Mon, 22 Mar 2010 22:24:08 +0100
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100228)
MIME-Version: 1.0
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
CC: socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, sameo@linux.intel.com
Subject: Re: [PATCH 2/3] can: add support for Janz VMOD-ICAN3 Intelligent
 CAN	module
References: <20100319151914.GB13672@ovro.caltech.edu>	<4BA39C05.8050800@grandegger.com>	<20100319200325.GE13672@ovro.caltech.edu>	<4BA3DAF1.4090206@grandegger.com>	<20100319215227.GF13672@ovro.caltech.edu>	<4BA47F64.8030108@grandegger.com>	<20100322155318.GA19251@ovro.caltech.edu>	<4BA7C236.9060609@grandegger.com>	<20100322201039.GA19327@ovro.caltech.edu>	<4BA7D2E9.6010007@grandegger.com> <20100322205101.GC19327@ovro.caltech.edu>
In-Reply-To: <20100322205101.GC19327@ovro.caltech.edu>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ira W. Snyder wrote:
> On Mon, Mar 22, 2010 at 09:28:25PM +0100, Wolfgang Grandegger wrote:
> 
> [ big snip ]
> 
>> You could even add the tx/rx values for each error message (for both,
>> state changes and bus-errors).
>>
> 
> Ok, with that change, I get the following:
> 
> berr-reporting on:
> 
>   can0  20000088  [8] 00 00 80 19 00 00 08 00   ERRORFRAME
>   can0  20000088  [8] 00 00 80 19 00 00 10 00   ERRORFRAME
>   can0  20000088  [8] 00 00 80 19 00 00 18 00   ERRORFRAME
>   can0  20000088  [8] 00 00 80 19 00 00 20 00   ERRORFRAME
>   can0  20000088  [8] 00 00 80 19 00 00 28 00   ERRORFRAME
>   can0  20000088  [8] 00 00 80 19 00 00 30 00   ERRORFRAME
>   can0  20000088  [8] 00 00 80 19 00 00 38 00   ERRORFRAME
>   can0  20000088  [8] 00 00 80 19 00 00 40 00   ERRORFRAME
>   can0  20000088  [8] 00 00 80 19 00 00 48 00   ERRORFRAME
>   can0  20000088  [8] 00 00 80 19 00 00 50 00   ERRORFRAME
>   can0  20000088  [8] 00 00 80 19 00 00 58 00   ERRORFRAME
>   can0  20000004  [8] 00 08 00 00 00 00 60 00   ERRORFRAME
>   can0  20000088  [8] 00 00 80 19 00 00 60 00   ERRORFRAME
>   can0  20000088  [8] 00 00 80 19 00 00 68 00   ERRORFRAME
>   can0  20000088  [8] 00 00 80 19 00 00 70 00   ERRORFRAME
>   can0  20000088  [8] 00 00 80 19 00 00 78 00   ERRORFRAME
>   can0  20000004  [8] 00 20 00 00 00 00 80 00   ERRORFRAME
>   can0  20000088  [8] 00 00 80 19 00 00 80 00   ERRORFRAME
>   can0  20000088  [8] 00 00 80 19 00 00 80 00   ERRORFRAME
> 
> And now lots more of this last frame repeated, until the controller
> decides to stop. Seems fine. It has always done this.
> 
> berr-reporting off:
> 
>   can1  20000004  [8] 00 08 00 00 00 00 60 00   ERRORFRAME
>   can1  20000004  [8] 00 20 00 00 00 00 80 00   ERRORFRAME
> 
> 
> Same as before. Excellent.

Yes, below is some more theory from the AT91 CAN manual, in case you are
interested in technical details.

Wolfgang.

-----------------------------------------------------------------------
o REC: Receive Error Counter
  When a receiver detects an error, REC will be increased by one, except
  when the detected error is a BIT ERROR while sending an ACTIVE ERROR
  FLAG or an OVERLOAD FLAG. When a receiver detects a dominant bit as
  the first bit after sending an ERROR FLAG, REC is increased by 8.
  When a receiver detects a BIT ERROR while sending an ACTIVE ERROR
  FLAG, REC is increased by 8. Any node tolerates up to 7 consecutive
  dominant bits after sending an ACTIVE ERROR FLAG, PASSIVE ERROR FLAG
  or OVERLOAD FLAG. After detecting the 14th consecutive dominant bit
  (in case of an ACTIVE ERROR FLAG or an OVER-LOAD FLAG) or after
  detecting the 8th consecutive dominant bit following a PASSIVE ERROR
  FLAG, and after each sequence of additional eight consecutive dominant
  bits, each receiver increases its REC by 8. After successful reception
  of a message, REC is decreased by 1 if it was between 1 and 127. If
  REC was 0, it stays 0, and if it was greater than 127, then it is set
  to a value between 119 and 127.

o TEC: Transmit Error Counter
  When a transmitter sends an ERROR FLAG, TEC is increased by 8 except
  when:
  - the transmitter is error passive and detects an ACKNOWLEDGMENT ERROR
    because of not detecting a dominant ACK and does not detect a
    dominant bit while sending its PASSIVE ERROR FLAG.
  - the transmitter sends an ERROR FLAG because a STUFF ERROR occurred
    during arbitration and should have been recessive and has been sent
    as recessive but monitored as dominant.
  When a transmitter detects a BIT ERROR while sending an ACTIVE ERROR
  FLAG or an OVERLOAD FLAG, the TEC will be increased by 8.
  Any node tolerates up to 7 consecutive dominant bits after sending an
  ACTIVE ERROR FLAG, PASSIVE ERROR FLAG or OVERLOAD FLAG. After
  detecting the 14th consecutive dominant bit (in case of an ACTIVE
  ERROR FLAG or an OVERLOAD FLAG) or after detecting the 8th consecutive
  dominant bit following a PASSIVE ERROR FLAG, and after each
  sequence of additional eight consecutive dominant bits every
  transmitter increases its TEC by 8. After a successful transmission
  the TEC is decreased by 1 unless it was already 0.

