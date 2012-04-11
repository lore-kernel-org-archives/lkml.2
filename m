Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760145Ab2DKMzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 08:55:32 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:58503 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab2DKMzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 08:55:31 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4F857F3F.5080701@cam.ac.uk>
Date: Wed, 11 Apr 2012 13:55:27 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>, mingo@elte.hu,
        linux-kernel@vger.kernel.org, Jonathan Cameron <jic23@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH RESEND] x86, intel_mid: ADC management
References: <20120410131206.GB31551@sirena.org.uk> <20120410142501.6045c6c0@pyramind.ukuu.org.uk> <20120410133339.GK7499@opensource.wolfsonmicro.com> <20120410144235.1e05efd4@pyramind.ukuu.org.uk> <20120410140749.GL7499@opensource.wolfsonmicro.com> <20120410151529.5bcc5ce6@pyramind.ukuu.org.uk> <20120410151943.GM7499@opensource.wolfsonmicro.com> <20120410175632.5c11c36e@pyramind.ukuu.org.uk> <20120410175846.GQ7499@opensource.wolfsonmicro.com> <20120411112411.11825eec@pyramind.ukuu.org.uk> <20120411103827.GH3163@opensource.wolfsonmicro.com> <4F856173.8000901@cam.ac.uk> <20120411121309.4b8f8e40@pyramind.ukuu.org.uk> <4F8568A8.5060206@cam.ac.uk> <20120411133035.25fa00b0@pyramind.ukuu.org.uk>
In-Reply-To: <20120411133035.25fa00b0@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/11/2012 1:30 PM, Alan Cox wrote:
>> needs to be abstracted as well.  Consumers might not care that the gain
>> just doubled because someone else requested it, but I suspect many of them will.
> At the bottom layer I'd expect a second consumer of the same data to get
> -EBUSY, but you are then going to tell me there are ADCs with one gain
> control for several channels no doubt 8)
yup.  If you can think of it, someone hardware guy will have implemented 
it! In this case
often comes down to the fact that most adcs are actually a mux on the 
front of a single
channel and the pga may be before the mux or after it (or for a laugh, 
sometimes both).

A real 'fun' one is devices that do scan reads.  That is you can only 
read certain combinations
of channels at a time and sometimes those combinations are far from 
obvious...
>
>
>> end up with most of IIO.  That's effectively what we did...   It's big
>> because there are
>> actually not that many 'simple' adc's out there.
> Fair enough - you would be the expert there.
I just wish they were all simple!
