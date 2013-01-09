Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592Ab3AILwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 06:52:45 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:62070 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756635Ab3AILwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 06:52:43 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 1/4] gpiolib: introduce descriptor-based GPIO interface
Date: Wed, 9 Jan 2013 11:52:29 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Guenter Roeck <linux@roeck-us.net>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1357629535-26033-1-git-send-email-acourbot@nvidia.com> <20130109104414.GF3931@n2100.arm.linux.org.uk> <20130109111055.GG3931@n2100.arm.linux.org.uk>
In-Reply-To: <20130109111055.GG3931@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301091152.30047.arnd@arndb.de>
X-Provags-ID: V02:K0:HFvceo0na2soxdJzeKL0G6faZlH2a/WPHZSyuYObpUM
 Lz9iz+ohWnqwSYukC/B42iPhE0cBnUMzW98zSKHSe41A2prav4
 wT6613jGnxJt9MCKyQaJbqVbRsyWrj/Vk0HdC/pgQbrKVB7g6j
 YHnNUrZ3ueo5gn+rt2M0mQ1P1U7xsrQBEl1HfHr1iaHnHk0FbX
 ZBYEbSnhIXf5Rr/FmrvIpQNeIHA82UkJRuwu9WHjgOh5Bnf4+0
 FC9kEqARspR9aottGRlrHw8BWsVNOXUJf4J0WVGWllBBQYaimk
 ODi5fVmikrBh2zDb5jM2m5Nj8B4RO6uRRbWUPKmQ4YWNpoicMM
 jbkmcQrTzPjFC8MhQWUs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 January 2013, Russell King - ARM Linux wrote:
>         d = debugfs_create_dir("pm_debug", NULL);
>         if (IS_ERR_OR_NULL(d))
>                 return PTR_ERR(d);
> 
> Well, covered above.  NULL is success here.

This one is actually worse, because in case of debugfs_create_dir,
a negative error code is documented to mean "success": The debugfs
functions intentionally return ERR_PTR(-ENODEV) when debugfs is
disabled so that any code checking for NULL pretends it is a valid
pointer, but that code is only allowed to pass this pointer into
other debugfs functions that are also stubbed out and never
dereference it.

	Arnd
