Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab2GJXge (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 19:36:34 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:49106 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084Ab2GJXgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 19:36:32 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-16.tower-132.messagelabs.com!1341963390!13978889!3
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 00/83] staging: comedi: rtd520: initial cleanup
Date: Tue, 10 Jul 2012 16:36:23 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207101636.23561.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'devpriv' macro usage in this driver is holding up other cleanup
of the comedi drivers.

This patch series removes all the macros used to read/write the
hardware registers. All of them are simple wrappers around standard
{read,write}[rwl] calls with some of them caching the write value
in a shadow variable in the private data.

Each of the macros is removed in a separate patch to ease reviewing.
They can all be squashed into one patch if desired.

After all the macros are gone, the devpriv macro itself can be removed
along with the boardinfo macro.

The "find pci device" code is also refactored to follow the style of
the other comedi pci drivers.

The range tables are also cleaned up for aesthetic reasons. The large
whitespace causes some pretty nasty line breaks in order to keep the
lines < 80 characters.

H Hartley Sweeten (83):
  staging: comedi: rtd520: remove RtdResetBoard macro
  staging: comedi: rtd520: remove RtdResetCGT macro
  staging: comedi: rtd520: remove RtdClearCGT macro
  staging: comedi: rtd520: remove RtdEnableCGT macro
  staging: comedi: rtd520: remove RtdWriteCGTable macro
  staging: comedi: rtd520: remove RtdWriteCGLatch macro
  staging: comedi: rtd520: remove RtdAdcClearFifo macro
  staging: comedi: rtd520: remove RtdAdcConversionSource macro
  staging: comedi: rtd520: remove RtdBurstStartSource macro
  staging: comedi: rtd520: remove RtdPacerStartSource macro
  staging: comedi: rtd520: remove RtdPacerStopSource macro
  staging: comedi: rtd520: remove RtdPacerClockSource macro
  staging: comedi: rtd520: remove RtdAdcSampleCounterSource macro
  staging: comedi: rtd520: remove RtdPacerTriggerMode macro
  staging: comedi: rtd520: remove RtdAboutStopEnable macro
  staging: comedi: rtd520: remove RtdTriggerPolarity macro
  staging: comedi: rtd520: remove RtdAdcStart macro
  staging: comedi: rtd520: remove RtdAdcFifoGet macro
  staging: comedi: rtd520: remove RtdAdcFifoGet2 macro
  staging: comedi: rtd520: remove RtdFifoStatus macro
  staging: comedi: rtd520: remove RtdPacerStart macro
  staging: comedi: rtd520: remove RtdPacerStop macro
  staging: comedi: rtd520: remove RtdInterruptStatus macro
  staging: comedi: rtd520: remove RtdInterruptMask macro
  staging: comedi: rtd520: remove RtdInterruptClear macro
  staging: comedi: rtd520: remove RtdInterruptClearMask macro
  staging: comedi: rtd520: remove RtdInterruptOverrunStatus macro
  staging: comedi: rtd520: remove RtdInterruptOverrunClear macro
  staging: comedi: rtd520: remove RtdPacerCount macro
  staging: comedi: rtd520: remove RtdPacerCounter macro
  staging: comedi: rtd520: remove RtdBurstCount macro
  staging: comedi: rtd520: remove RtdBurstCounter macro
  staging: comedi: rtd520: remove RtdDelayCount macro
  staging: comedi: rtd520: remove RtdDelayCounter macro
  staging: comedi: rtd520: remove RtdAboutCount macro
  staging: comedi: rtd520: remove RtdAboutCounter macro
  staging: comedi: rtd520: remove RtdAdcSampleCount macro
  staging: comedi: rtd520: remove RtdAdcSampleCounter macro
  staging: comedi: rtd520: remove RtdUtcCounterGet macro
  staging: comedi: rtd520: remove RtdUtcCounterPut macro
  staging: comedi: rtd520: remove RtdUtcCtrlPut macro
  staging: comedi: rtd520: remove RtdUtcClockSource macro
  staging: comedi: rtd520: remove RtdUtcGateSource macro
  staging: comedi: rtd520: remove RtdUsrOutSource macro
  staging: comedi: rtd520: remove RtdDio0Read macro
  staging: comedi: rtd520: remove RtdDio0Write macro
  staging: comedi: rtd520: remove RtdDio1Read macro
  staging: comedi: rtd520: remove RtdDio1Write macro
  staging: comedi: rtd520: remove RtdDioStatusRead macro
  staging: comedi: rtd520: remove RtdDioStatusWrite macro
  staging: comedi: rtd520: remove RtdDio0CtrlRead macro
  staging: comedi: rtd520: remove RtdDio0CtrlWrite macro
  staging: comedi: rtd520: remove RtdDacFifoPut macro
  staging: comedi: rtd520: remove RtdDacUpdate macro
  staging: comedi: rtd520: remove RtdDacBothUpdate macro
  staging: comedi: rtd520: remove RtdDacRange macro
  staging: comedi: rtd520: remove RtdDacClearFifo macro
  staging: comedi: rtd520: remove RtdDma0Source macro
  staging: comedi: rtd520: remove RtdDma1Source macro
  staging: comedi: rtd520: remove RtdDma0Reset macro
  staging: comedi: rtd520: remove RtdDma1Reset macro
  staging: comedi: rtd520: remove RtdPlxInterruptRead macro
  staging: comedi: rtd520: remove RtdPlxInterruptWrite macro
  staging: comedi: rtd520: remove RtdDma0Mode macro
  staging: comedi: rtd520: remove RtdDma0PciAddr macro
  staging: comedi: rtd520: remove RtdDma0LocalAddr macro
  staging: comedi: rtd520: remove RtdDma0Count macro
  staging: comedi: rtd520: remove RtdDma0Count macro
  staging: comedi: rtd520: remove RtdDma1Mode macro
  staging: comedi: rtd520: remove RtdDma1PciAddr macro
  staging: comedi: rtd520: remove RtdDma1LocalAddr macro
  staging: comedi: rtd520: remove RtdDma1Count macro
  staging: comedi: rtd520: remove RtdDma1Next macro
  staging: comedi: rtd520: remove RtdDma0Control macro
  staging: comedi: rtd520: remove RtdDma0Status macro
  staging: comedi: rtd520: remove RtdDma1Control macro
  staging: comedi: rtd520: remove RtdDma1Status macro
  staging: comedi: rtd520: remove devpriv macro
  staging: comedi: rtd520: remove thisboard macro
  staging: comedi: rtd520: factor out the "find pci device" code
  staging: comedi: rtd520: cleanup the "find pci device" code
  staging: comedi: rtd520: cleanup the range tables
  staging: comedi: rtd520: cleanup the boardinfo

 drivers/staging/comedi/drivers/rtd520.c | 915 +++++++++++---------------------
 1 file changed, 318 insertions(+), 597 deletions(-)

-- 
1.7.11

