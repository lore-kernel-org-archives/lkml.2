Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719Ab0LPP5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 10:57:32 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:51347 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756276Ab0LPP53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 10:57:29 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH V7 5/8] ptp: Added a brand new class driver for ptp clocks.
Date: Thu, 16 Dec 2010 16:57:23 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Christoph Lameter <cl@linux.com>, David Miller <davem@davemloft.net>,
        John Stultz <johnstul@us.ibm.com>, Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
References: <cover.1292512461.git.richard.cochran@omicron.at> <55b3188e735c3ce51608eef7926136d789182aa3.1292512461.git.richard.cochran@omicron.at>
In-Reply-To: <55b3188e735c3ce51608eef7926136d789182aa3.1292512461.git.richard.cochran@omicron.at>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012161657.24058.arnd@arndb.de>
X-Provags-ID: V02:K0:vpwz5kIIILbEM/C6hMaQRsG1Qrnna8fW47y7Hf6h1fs
 enSofF46KJaJnW2VMjytUJVmvsCmQCfihZtsZR/XWBcy7deOEB
 5aO6MVVI4JZ19kXMeG2EJ/Lu99AR04LJX4+AQ8+GLvKaXvfmmY
 5WS79g0UH9gRPZ+yWGptfn9OOMqAt5jR8Kv+MfCEMsP1cpJp2E
 O5Lwdu53p5R2uKKGv1p9g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 December 2010, Richard Cochran wrote:
> This patch adds an infrastructure for hardware clocks that implement
> IEEE 1588, the Precision Time Protocol (PTP). A class driver offers a
> registration method to particular hardware clock drivers. Each clock is
> presented as a standard POSIX clock.
> 
> The ancillary clock features are exposed in two different ways, via
> the sysfs and by a character device.
> 
> Signed-off-by: Richard Cochran <richard.cochran@omicron.at>

Looks fine to me, with one tiny comment:

> +
> +/* private globals */
> +
> +extern struct device_attribute ptp_dev_attrs[]; /* see ptp_sysfs.c */

The declaration is in a C file, better move it into a header in order
to make sure the definition matches the declaration.

	Arnd
