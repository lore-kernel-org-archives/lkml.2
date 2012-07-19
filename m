Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669Ab2GSM3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 08:29:13 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:51643 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab2GSM3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 08:29:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Prisk <linux@prisktech.co.nz>
Subject: Re: [PATCH 1/1] Add Wondermedia Technologies (wmt) to docs/devicetree/vendor-bindings.txt
Date: Thu, 19 Jul 2012 12:28:48 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: "vt8500-wm8505-linux-kernel@googlegroups.com" 
	<vt8500-wm8505-linux-kernel@googlegroups.com>,
        Alexey Charkov <alchark@gmail.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <76F764B079F92A4E843589C893D0A022C380F1D4@SERVER.prisktech.co.nz> <201207191116.27273.arnd@arndb.de> <76F764B079F92A4E843589C893D0A022C3811BFD@SERVER.prisktech.co.nz>
In-Reply-To: <76F764B079F92A4E843589C893D0A022C3811BFD@SERVER.prisktech.co.nz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207191228.48809.arnd@arndb.de>
X-Provags-ID: V02:K0:uBirEi6jsG5912mmgtg3kBFf5KTe1Mecs7GO0LHDqVy
 NOpsvTPsUjP8EjE4+l2UkqfLk9NndKW9K2bkTYF1aMo1j9++sy
 +lUdKVrLTWLI5NA+Pg+cuqmkWB8PlMgfDNDrUpWDG17PEanTIK
 LDlRRJZRW5rLW59YcMzj9wmSDOnyNE3bZ6yRaI9NQ2SNA8w65i
 u9NzJcPcGqMsrDRsZoMXvG9ARPxjS/OE5sCrPT+2/qFbAX/W4B
 11yam0nSVweOeloYABULyE/4wFC9KYXdxaREPSj0Xf/eQLeEod
 5qvT3kWx2EQeEyWVqwgMLyzWPay2IL/Jz8pAJjpQ3CNL40p3kF
 C2BKiDJ7A0VPhdEupxSI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
