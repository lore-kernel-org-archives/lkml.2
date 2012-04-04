Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090Ab2DDIjh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 04:39:37 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:49731 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab2DDIjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 04:39:35 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4F7C08C3.7090603@cam.ac.uk>
Date: Wed, 04 Apr 2012 09:39:31 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Jon Brenner <jbrenner@TAOSinc.com>
CC: jic23@kernel.org, gregkh@linuxfoundation.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Proposed addition to 'IIO interface' for color light sensing
 devices
References: <B4B07CCC7B7A084E989CF9386538EA1D0120B3B3@exchsrvr.taosinc.com>
In-Reply-To: <B4B07CCC7B7A084E989CF9386538EA1D0120B3B3@exchsrvr.taosinc.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure who else would be interested in this discussion so if anyone can cc
any interested parties that would be great! (
> I would like to propose the following addition to the 'IIO device
> interface' for color light sensing devices to accommodate CCT (AKA color
> temperature) and access to the raw RGB channel data for user analysis.
>
> IIO channel type name: CCT
>
> The CCT ABI should be documented similar to as follows:
> In sys-bus-iio-light:
> What:		/sys/bus/iio/devices/device[n]/cct[_input|_raw]
> KernelVersion:	3.3.0
> Contact:	linux-iio@vger.kernel.org
> Description:
> 		This should return the correlated color temperature from
> the RGBC color sensor
> 		expressed as SI unit (degree kelvin).
> 		If it comes back in SI units, it should also
> include_input else it
> 		should include _raw to signify it is not in SI units.
Works for me though the formatting of the above is somewhat different from
our current docs...
>
> IIO modifiers:
> IIO_MOD_LIGHT_RED
> IIO_MOD_LIGHT_GREEN
> IIO_MOD_LIGHT_BLUE
So these modifiers apply to intensity channels?   Colour temp is built from
multiple raw sensors I believe (like illuminance is often done?)
Hence it's another 'virtual' channel we compute?
>
> The 'clear' and IR channels are already covered by the use of IIO_LIGHT
> and IIO ILLUMINANCE (and respective modifiers).
> The RGB modifiers will help to express the relative frequencies to their
> respective channel, and appear to fit well with the overall convention.
>
> And last but not least, the textual modifier names "red", "green", and
> "blue" be accommodated within 'industrialio-core'.
Fine with me.

>
> Channel specific interrupt event / sources are not presented at this
> time.
>
> Any thoughts or comments are welcomed.
>
> Jon Brenner
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

