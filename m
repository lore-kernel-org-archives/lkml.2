Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324Ab2GSMm1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 08:42:27 -0400
Received: from 115-188-14-127.jetstream.xtra.co.nz ([115.188.14.127]:62872
	"EHLO SERVER.prisktech.co.nz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751090Ab2GSMmS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 08:42:18 -0400
From: Tony Prisk <linux@prisktech.co.nz>
To: Arnd Bergmann <arnd@arndb.de>
CC: "vt8500-wm8505-linux-kernel@googlegroups.com" 
	<vt8500-wm8505-linux-kernel@googlegroups.com>,
        Alexey Charkov <alchark@gmail.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 1/1] Add Wondermedia Technologies (wmt) to
 docs/devicetree/vendor-bindings.txt
Thread-Topic: [PATCH 1/1] Add Wondermedia Technologies (wmt) to
 docs/devicetree/vendor-bindings.txt
Thread-Index: AQKYMMxC+/7sfLVv24SJcXAAzrg8wAJQSbLQAtZSvySVcT8RUP//oSgAgADM587//0dRAIAAydF7
Date: Thu, 19 Jul 2012 12:39:51 +0000
Message-ID: <76F764B079F92A4E843589C893D0A022C3812054@SERVER.prisktech.co.nz>
References: <76F764B079F92A4E843589C893D0A022C380F1D4@SERVER.prisktech.co.nz>
 <201207191116.27273.arnd@arndb.de>
 <76F764B079F92A4E843589C893D0A022C3811BFD@SERVER.prisktech.co.nz>,<201207191228.48809.arnd@arndb.de>
In-Reply-To: <201207191228.48809.arnd@arndb.de>
Accept-Language: en-GB, en-NZ, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_______________________________________
From: Arnd Bergmann [arnd@arndb.de]
Sent: 20 July 2012 00:28
To: Tony Prisk
Cc: vt8500-wm8505-linux-kernel@googlegroups.com; Alexey Charkov; devicetree-discuss@lists.ozlabs.org; Russell King; linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/1] Add Wondermedia Technologies (wmt) to docs/devicetree/vendor-bindings.txt

On Thursday 19 July 2012, Tony Prisk wrote:
> I have no issue with that.
>
> I am mainly concerned with the Wondermedia products at the moment.
>
> Adding device tree support for WM8505 (and WM8650) is my main goal as the WM8650
> currently isn't supported and trying to get another board file added seems unlikely with
> everything moving to device tree. The VT8500 requires additional/different patches and
> as I don't have a vt8500 I can't test them.
>
> It does raise the question of applying 'wmt, prizm-pmc' to the vt8500 though. While it's
> fine for the restart patch I submitted, the vt8500 registers are the same but the bit-fields
> are different and therefore not entirely compatible with 'prizm-pmc'.
> When it comes to other PMC-related features, in particular the clocks, the VT8500 is quite
> different in its bit-fields.
>
> The vt8500 isn't technically in the Prizm family, as that is Wondermedia's name for the SoC's.
>

My point is that for each peripheral, we should decide separately what the
most descriptive name for it is. If the pmc is common for all wmt prizm
chips, then using the "wmt,prizm-pmc" string makes sense, and vt8500
can use "via,vt8500-pmc" or something like that.

However for stuff like the rtc that appears to be unchanged between them,
I would use the compatible string of the oldest known chip using it,
so even a wmt8650 should just claim compatibility with vt8500 there and
list both "wmt,wm8650-rtc" and "via,vt8500-rtc" there.

        Arnd

-----

Sounds reasonable. If device tree had been done when VT8500 came out, then the WM8xxx
products would have used the vt8500 compatibilities, so it makes sense to use the same logic
now.

Which brings us back to the original question (and raises another one) - can we assume yet that
'wmt' will be the vendor-binding for Wondermedia? Also, what are we going to use for VIA-based
SoC's given that VIA is the ticker for VIACOM. 

I did do a bit of a search on some stock tickers - 'WM' is Waste Management Inc. on the NYSE.
Presumably this would be as safe, or safer, than WMT (Walmart).
VIACOM, being a media content company, seems unlikely to produce any hardware but its possible
they will rebrand others hardware.

Regards,
Tony P