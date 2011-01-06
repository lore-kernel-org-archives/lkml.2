Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547Ab1AFORd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 09:17:33 -0500
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:59538 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751861Ab1AFORc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 09:17:32 -0500
From: Carmelo AMOROSO <carmelo.amoroso@st.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "vapier@gentoo.org" <vapier@gentoo.org>,
        "nico@fluxnic.net" <nico@fluxnic.net>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Filippo ARCIDIACONO <filippo.arcidiacono@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 6 Jan 2011 15:16:25 +0100
Subject: Re: [PATCH 1/2] stackprotector: add stack smashing protector
	generic implementation
Thread-Topic: [PATCH 1/2] stackprotector: add stack smashing protector
	generic implementation
Thread-Index: AcutrE4WYhI4FV1vSoeQSI1+XUwXXw==
Message-ID: <4D25CEB9.7090205@st.com>
References: <1293111851-7175-1-git-send-email-filippo.arcidiacono@st.com>
 <4D245D16.5010702@st.com> <20110106093940.GA31708@n2100.arm.linux.org.uk>
In-Reply-To: <20110106093940.GA31708@n2100.arm.linux.org.uk>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-enigmail-version: 1.1.1
user-agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13)
 Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 1/6/2011 10:39 AM, Russell King - ARM Linux wrote:
> On Wed, Jan 05, 2011 at 12:59:18PM +0100, Carmelo AMOROSO wrote:
>  > Is someone interested into this stuff ?
> 
> Looking at the CC list, you're asking the people who already have the
> support in the kernel. I suspect they don't have that much of an
> interest in it.
> 
> Maybe you should try asking other architecture maintainers who don't
> support this yet? Not every architecture maintainer is subscribed to,
> or reads LKML...
> 

Hi Russel, thanks for your feedback.
Well, SH (in CC) does not have this support. Indeed we posted it
initially to linux-sh only. We got useful feedback from Paul, Mike and
Nicolas suggesting to promote the ARM/SH solution based on the global
__stack_chk_guard variable as a generic solution for all other
architectures. This is why I thought to post to the LKML instead of each
linux-<arch> list.
The code is able to detect if the arch implementation is based on the
global (if so the generic implementation should work cleanly), otherwise
it will fail to compile when trying to include the
linux/asm/stackprotector.h. This is an easy way to detect the lack of an
arch specific implementation (but likely only x86 needs it... I don't know).

So the idea is to use the ARM code as generic's one (tested on SH
kernel). Mike Frysinger volunteered to try on blackfin for example.

cheers
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk0lzrkACgkQoRq/3BrK1s/JhACdERr4TFBaGmf4XuQEUA/9X/Kt
lz4An0fctncE+n9fhHvvZEbIZEilJKNO
=5yFm
-----END PGP SIGNATURE-----
