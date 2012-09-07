Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933255Ab2IGMfq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 08:35:46 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56096 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933091Ab2IGMfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 08:35:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 15/19] mfd: Don't convert just one IRQ using irqdomain if a range is provided
Date: Fri, 7 Sep 2012 12:35:41 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        Samuel Ortiz <sameo@linux.intel.com>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org> <1347016499-29354-16-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1347016499-29354-16-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201209071235.41785.arnd@arndb.de>
X-Provags-ID: V02:K0:caKlor2BtXsOVdtPH3IQAPf/F/Xq7fXD2qz+pCa0tTD
 Y3WlViP6DlQM9fwgg9gtHzqk7taTj01NeM8H4+rpCNSzH4wxKM
 lfz41CUD178aVVEsrnS7ON6ngod1K4Gm/WRURNqOUuveotjfK0
 rgIDqZP1iJylVC+G4q4TwznEHFvDNEp5e2+rjrQHEK30e7F0dm
 UVqu1I6J8PoO+vTtjPUEGVvEFmP3ccdVrKIdK7SFdA7DgRM2F7
 TxIaj+77P/1CTDvrDX5ZbJHEQ5UrjXamqczv2ivqhmDwK2jg/K
 MLhsnA7OiszpNuNzjJKj8O36DsM61397PEFqJTSVUmfOwMemth
 XPzX4J41kFMG7ZW0uYEs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 September 2012, Lee Jones wrote:
> MFD core code attempts to convert specified hardware (local) IRQ
> numbers to virtual-IRQs, which something Linux can understand. This
> works great when only one IRQ is specified. However, converting
> entire ranges is currently unsupported. If this occurs we issue a
> kernel warning to inform the user of this, but we continue to
> convert the first specified IRQ anyway and replace the range. This
> is not the correct behaviour. This patch ensures that if a range
> is specified, it is left untouched.
> 
> CC: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

I don't see the advantage of the change. The warning already tells
us that the input to mfd_add_device was incorrect, so nothing the
function does can reliably fix it. Leaving the resource empty
is just as wrong as listing only the first interrupt.

	Arnd
