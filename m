Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467Ab2DKKs1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 06:48:27 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:52163 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab2DKKs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 06:48:26 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4F856173.8000901@cam.ac.uk>
Date: Wed, 11 Apr 2012 11:48:19 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, mingo@elte.hu,
        linux-kernel@vger.kernel.org, Jonathan Cameron <jic23@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH RESEND] x86, intel_mid: ADC management
References: <20120410131206.GB31551@sirena.org.uk> <20120410142501.6045c6c0@pyramind.ukuu.org.uk> <20120410133339.GK7499@opensource.wolfsonmicro.com> <20120410144235.1e05efd4@pyramind.ukuu.org.uk> <20120410140749.GL7499@opensource.wolfsonmicro.com> <20120410151529.5bcc5ce6@pyramind.ukuu.org.uk> <20120410151943.GM7499@opensource.wolfsonmicro.com> <20120410175632.5c11c36e@pyramind.ukuu.org.uk> <20120410175846.GQ7499@opensource.wolfsonmicro.com> <20120411112411.11825eec@pyramind.ukuu.org.uk> <20120411103827.GH3163@opensource.wolfsonmicro.com>
In-Reply-To: <20120411103827.GH3163@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/11/2012 11:38 AM, Mark Brown wrote:
> On Wed, Apr 11, 2012 at 11:24:11AM +0100, Alan Cox wrote:
>
>> If that code gets pulled out of IIO dumped into drivers/adc and has a bit
>> of a different API to the gpadc code then no problem, gpadc can follow it
>> happily enough. IIO can use it from staging and IIO can migrate whenever.
IIO is about a heck of a lot other than ADCs.  Keep that in mind. They 
are a substantial
corner but we handle a lot of output devices and other input devices 
(though these
might be adc's inside, that's not what your average users think of them as).
We 'have' to ensure anything we do works for the other device types as well.
>> It does make sense to think hard about userspace APIs for IIO but for
>> kernel APIs its really being too conservative - we break kernel APIs
>> every release. They are not set into stone.
> The way I keep thinking about this (which I'm sure I've suggested
> before) is that we should be refactoring IIO such that the userspace ABI
> is just another in-kernel consumer of the device driver bit of IIO and
> that driver bit should be small enough to just use.  I think that winds
> up being roughly equivalent to your suggestion but means that there's
> just one place to put the drivers which seems like a win.
The intent is there, but there are an awful lot of corner cases that 
need working out.
Mostly these don't relate to simple adc usage. Just take a look at those 
elements
of the drivers that don't pass through the read_raw and write_raw callbacks.

It might be possible to make the userspace interfaces optional without 
too much pain.

I  know it's not ideal, but at the end of the day IIO had a rather 
different target when
we wrote it from SoC ADCs. That target of consistent userspace 
interfaces and
brute force data capture still has to be met without introducing major 
regressions.



