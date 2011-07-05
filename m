Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab1GEOoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 10:44:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:62257 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060Ab1GEOnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 10:43:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linaro-dev@lists.linaro.org, ashish.jangam@kpitcummins.com
Subject: Re: [PATCH 02/11] GPIO: DA9052 GPIO module v2
Date: Tue, 5 Jul 2011 16:43:44 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.37; KDE/4.5.1; x86_64; ; )
Cc: grant@secretlab.ca, Dajun <dajun.chen@diasemi.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, jic23@cam.ac.uk,
        linux-kernel@vger.kernel.org
References: <1309872878.960.106.camel@L-0532.kpit.com>
In-Reply-To: <1309872878.960.106.camel@L-0532.kpit.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107051643.45158.arnd@arndb.de>
X-Provags-ID: V02:K0:fdh/l0zfqcXL1Pi/qDN6kbT3Ui+QM5whZWy3CRDGPm/
 FaXoEDaqVoIpL26c6SLCmLJ5DEJlzQKAfpqYaCYgawab3ItTOg
 OdrWuHazOXWolaOJVIJXRTdcnZOAZqJyc3Xss/ywNJQay7cl3l
 jJwJcw9EjMKIzv+F8DbZ428536/vUpaPmnhfqkE45dxzfcBJZx
 Zs422gjsZvdYO3f32eVJQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 July 2011, ashishj3 wrote:
> DA9052 PMIC has 16 bit GPIO bus for peripheral control.
> 
> This patch add support for the GPIO pins on the DA9052.
> 
> Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
> CC: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
> Changes since v2
> - change of file name
> - correct reference to irq_base in function to_irq()
> - remove pdata dependency
> ---
>  drivers/gpio/Kconfig            |    6 +
>  drivers/gpio/Makefile           |    1 +
>  drivers/gpio/gpio-da9052.c      |  259 +++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/da9052/gpio.h |   47 +++++++
>  4 files changed, 313 insertions(+), 0 deletions(-)

I think I commented on this before, but please remove any header files
in include/linux that are not used as an interface between different
modules. If a header just describes properties of the hardware and is
used by a single source file, move the contents into that source file.

If a header is used by multiple files in one directory, make it a local
header in that directory.

	Arnd
