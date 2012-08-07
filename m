Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab2HGTrC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 15:47:02 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:56758 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857Ab2HGTq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 15:46:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 1/7] mfd: max8925: Move _IO resources out of ioport_ioresource
Date: Tue, 7 Aug 2012 19:46:52 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Russell King <rmk@arm.linux.org.uk>, "v3.4+" <stable@vger.kernel.org>
References: <1344364969-32489-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1344364969-32489-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201208071946.52211.arnd@arndb.de>
X-Provags-ID: V02:K0:I39EVw7cNUoWFNo8F3115TuLBcMCRul6jmjZD1j3757
 kZQtJ904VesBoRII8g44NJwSfK2NFJQOArtez7CWaBbq7+Fn1r
 Gd0qcqU7+Svy+X8b4VsU3/jJYKmYv+AlKpFXLX+K0wG519A9MZ
 16GBDNY2cEmpJw4aRh88V41C93PV+KxN1okkdKiwek1m+329i4
 oqWt6f/YVocY+JgesoBSzWO2/J35SvHWRe6zNgJx8PKMSc6iLa
 qBYz5KblY+i4kBVcqniYW6/9UcMP1cYs6atSlVUUZMgfWagCJJ
 h8ZKNY1MZrfpyF3GoX+JDjrVeXufqTjc3EY1y8AdHM9k2iwKaB
 DWOXocUzPo8CNcW/z+XQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 August 2012, Mark Brown wrote:
> The removal of mach/io.h from most ARM platforms also set the range of
> valid IO ports to be empty for most platforms when previously any 32
> bit integer had been valid. This makes it impossible to add IO resources
> as the added range is smaller than that of the root resource for IO ports.
> 
> Since we're not really using IO memory at all fix this by defining our
> own root resource outside the normal tree and make that the parent of
> all IO resources. This also ensures we won't conflict with read IO ports
> if we ever run on a platform which happens to use them.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: stable@vger.kernel.org (v3.4+)

(whole series)

Acked-by: Arnd Bergmann <arnd@arndb.de>

Thanks a lot for following through with this series! I would have
preferred to have the second step in stable as Russell suggested,
but since you did all the work, I'm not going to complain about it ;-)

	Arnd
