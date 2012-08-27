Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab2H0J3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 05:29:23 -0400
Received: from bosmailout14.eigbox.net ([66.96.185.14]:51997 "EHLO
	bosmailout14.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897Ab2H0J3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 05:29:22 -0400
X-Greylist: delayed 2443 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Aug 2012 05:29:22 EDT
X-Authority-Analysis: v=2.0 cv=AakG6QrG c=1 sm=1
 a=OWwsRfqG41DA94+gJvZMBg==:17 a=bc2JKO6qiGsA:10 a=kfTud4QeKxsA:10
 a=6_yu9_eKWJgA:10 a=8nJEP1OIZ-IA:10 a=gHsnk5GASbAA:10
 a=bJ0fqD8TFZgqkSadqForXVIPBlU=:19 a=QX3aAzGngiwP8rsU0S4A:9 a=wPNLvfGTeEIA:10
 a=2OW49aEHms2tn/AeNJ+rfA==:117
X-EN-OrigOutIP: 10.20.18.16
X-EN-IMPSID: rkoe1j0040LoEWa01koeNQ
Message-ID: <503B342C.9060300@yahoo.es>
Date: Mon, 27 Aug 2012 16:47:40 +0800
From: Hein Tibosch <hein_tibosch@yahoo.es>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>
CC: viresh kumar <viresh.kumar@linaro.org>,
        spear-devel <spear-devel@list.st.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [PATCH 1/2] dw_dmac: make driver endianness configurable
References: <503A8CAE.6050606@yahoo.es> <20120827070323.GC28721@samfundet.no>
In-Reply-To: <20120827070323.GC28721@samfundet.no>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 3946c951b80c12a8be5482963a0b1232:e0ae43bc192b431f8b69f09a37527cbc
X-EN-AuthUser: hein@htibosch.net
X-EN-OrigIP: 114.79.63.241
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/27/2012 3:03 PM, Hans-Christian Egtvedt wrote:
> I think the English in kconfig could use some brushing up.
>  
>> +config DW_DMAC_BE
>
>
> This name isn't that long, so we could skip the abbreviation of big endian;
> DW_DMAC_BIG_ENDIAN_IO or something similar?
>
>> +	bool "Synopsys DesignWare AHB DMA needs big endian access"
>>
> bool "Use big endian I/O register access"

Brushing up the config items:

+config DW_DMAC_BIG_ENDIAN_IO
+	bool "Use big endian I/O register access"
+	default y if AVR32
+	depends on DW_DMAC
+	help
+	  Say yes here to use big endian I/O access when reading and writing
+	  to the DMA controller registers. This is needed on some platforms,
+	  like the Atmel AVR32 architecture.
+
+	  If unsure, use the default setting.

And as I'd like to define the maximum memory transfer width in the same
Kconfig:

+config DW_DMAC_MEM_64_BIT
+	bool "Allow 64-bit memory transfers"
+	default y if !AVR32
+	depends on DW_DMAC
+	help
+	  Say yes if the DMA controller may do 64-bit memory transfers
+	  For AVR32, say no because only up to 32-bit transfers are
+	  defined

Would this be better?

Thanks, Hein
