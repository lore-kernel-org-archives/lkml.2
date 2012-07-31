Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab2GaUuW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 16:50:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:65211 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754Ab2GaUuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 16:50:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 5/6] ARM: ux500: Enable HIGHMEM on all mop500 platforms
Date: Tue, 31 Jul 2012 20:50:02 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, linus.walleij@stericsson.com,
        broonie@opensource.wolfsonmicro.com, olalilja@yahoo.se,
        STEricsson_nomadik_linux@list.st.com, lrg@ti.com
References: <1343741493-17671-1-git-send-email-lee.jones@linaro.org> <5017EBDC.6010005@linaro.org> <20120731143732.GS6802@n2100.arm.linux.org.uk>
In-Reply-To: <20120731143732.GS6802@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207312050.03113.arnd@arndb.de>
X-Provags-ID: V02:K0:9N3PmFfIvQdns1NDrqm/hdvArEzVgRIDqDgxhlh33Z4
 KfJrji3QLsZ9ca0j9Miy6osruXJdAQfIIo0LYeXsA6R4fq/J63
 KMldS5PO11a3ymdPXIHnANtggGlVeqgxSch5ZqIGh+sBv/ggVf
 FIfEEpUKw5qdcZMYrAAz4Kdh8KMIdUeKSNzoLrRFQY+dJARlWC
 64hBlx2SzX7SQUW8xl+KX02NaRJ7Ur8qENfcw3kk4VJK+cuuep
 dhCzQN553RdZ6yCbdL62wxoUKb7S0rnaxTeW3SNv3zF+2+GkbE
 x2OuqQN/kNubLDIpfh1MdqiZY+V2txsuRwTBGxKrf+UBtVL9G8
 +ZOMXG7ExusZ9P+Do2C4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 31 July 2012, Russell King - ARM Linux wrote:
> I still fail to see how not having highmem enabled would ever cause memory
> corruption errors (unless something dealing with memory in a very very
> wrong way - iow, not using one of the reservation or memory allocation
> methods provided by the kernel.)

The problem is that all users of ux500 systems pass a command line like

vmalloc=256M mem=128M@0 mali.mali_mem=32M@128M hwmem=168M@160M mem=48M@328M mem_issw=1M@383M mem=640M@384M

This is of course totally bogus and should not be done. If I understand
Lee correctly, one of the issues resulting from passing a command
line like this without enabling highmem is memory corruption.

"Doctor it hurts when I do this ..."

	Arnd
