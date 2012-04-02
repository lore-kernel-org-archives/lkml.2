Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab2DBW6d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 18:58:33 -0400
Received: from 90-46-11-204.rar.beartech.net ([204.11.46.90]:35834 "EHLO
	exchsrvr.taosinc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752736Ab2DBW6c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 18:58:32 -0400
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Proposed addition to 'IIO interface' for color light sensing devices
Date: Mon, 2 Apr 2012 18:04:20 -0500
Message-ID: <B4B07CCC7B7A084E989CF9386538EA1D0120B3B3@exchsrvr.taosinc.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Proposed addition to 'IIO interface' for color light sensing devices
Thread-Index: Ac0RJOPOrCrxjF1WRMi0UYmqt1VOgQ==
From: "Jon Brenner" <jbrenner@TAOSinc.com>
To: <jic23@kernel.org>, <gregkh@linuxfoundation.org>
Cc: <linux-iio@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I would like to propose the following addition to the 'IIO device
interface' for color light sensing devices to accommodate CCT (AKA color
temperature) and access to the raw RGB channel data for user analysis.

IIO channel type name: CCT

The CCT ABI should be documented similar to as follows: 
In sys-bus-iio-light:
What:		/sys/bus/iio/devices/device[n]/cct[_input|_raw]
KernelVersion:	3.3.0
Contact:	linux-iio@vger.kernel.org
Description:
		This should return the correlated color temperature from
the RGBC color sensor
		expressed as SI unit (degree kelvin). 
		If it comes back in SI units, it should also
include_input else it
		should include _raw to signify it is not in SI units.

IIO modifiers:
IIO_MOD_LIGHT_RED
IIO_MOD_LIGHT_GREEN
IIO_MOD_LIGHT_BLUE

The 'clear' and IR channels are already covered by the use of IIO_LIGHT
and IIO ILLUMINANCE (and respective modifiers).
The RGB modifiers will help to express the relative frequencies to their
respective channel, and appear to fit well with the overall convention.

And last but not least, the textual modifier names "red", "green", and
"blue" be accommodated within 'industrialio-core'.

Channel specific interrupt event / sources are not presented at this
time.

Any thoughts or comments are welcomed.

Jon Brenner

