Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909Ab0GIOV3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 10:21:29 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:11806 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab0GIOV2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 10:21:28 -0400
To: Christoph Egger <siccegge@cs.fau.de>,
       "Zhang, Sonic" <Sonic.Zhang@analog.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Mike Frysinger <vapier@gentoo.org>,
       Graf Yang <graf.yang@analog.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-IronPort-AV: E=Sophos;i="4.53,563,1272859200"; 
   d="scan'208";a="18673494"
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
CC: "vamos-dev@i4.informatik.uni-erlangen.de" 
	<vamos-dev@i4.informatik.uni-erlangen.de>
Date: Fri, 9 Jul 2010 15:21:23 +0100
Subject: RE: [Uclinux-dist-devel] [PATCH 09/11] Removing dead
 SERIAL_BFIN_{HARD_,	}CTSRTS
Thread-Topic: [Uclinux-dist-devel] [PATCH 09/11] Removing dead
 SERIAL_BFIN_{HARD_,	}CTSRTS
Thread-Index: AcsfbcDS8oOi1n7MQLiTFIjXK3rZpAAA+Bqg
Message-ID: <544AC56F16B56944AEC3BD4E3D5917712E7EA59857@LIMKCMBX1.ad.analog.com>
References: <cover.1278682302.git.siccegge@cs.fau.de>
 <2c4cc1817c05dad1183df108c35ae2e164638fc1.1278682303.git.siccegge@cs.fau.de>
In-Reply-To: <2c4cc1817c05dad1183df108c35ae2e164638fc1.1278682303.git.siccegge@cs.fau.de>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Egger wrote on 2010-07-09:
> SERIAL_BFIN_{HARD_,}CTSRTS doesn't exist in Kconfig, therefore
> removing all references for it from the source code.

Right it doesn't exist in Kconfig - however it gets defined in bfin_serial.h.

#if defined(CONFIG_BFIN_UART0_CTSRTS) || \
    defined(CONFIG_BFIN_UART1_CTSRTS) || \
    defined(CONFIG_BFIN_UART2_CTSRTS) || \
    defined(CONFIG_BFIN_UART3_CTSRTS)
# ifdef BFIN_UART_BF54X_STYLE
#  define CONFIG_SERIAL_BFIN_HARD_CTSRTS
# else
#  define CONFIG_SERIAL_BFIN_CTSRTS
# endif
#endif

I guess we shouldn't prefix those defines with CONFIG_

Greetings,
Michael

Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft Muenchen, Registergericht Muenchen HRB 4036 Geschaeftsfuehrer Thomas Wessel, William A. Martin, Margaret Seif


