Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328Ab1CBNWs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 08:22:48 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:58318 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab1CBNWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 08:22:47 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Pratheesh Gangadhar <pratheesh@ti.com>
Subject: Re: [PATCH v8 1/1] PRUSS UIO driver support
Date: Wed, 2 Mar 2011 14:22:26 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, hjk@hansjkoch.de, gregkh@suse.de,
        tglx@linutronix.de, sshtylyov@mvista.com, amit.chatterjee@ti.com,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org
References: <1299065886-30099-1-git-send-email-pratheesh@ti.com> <1299065886-30099-2-git-send-email-pratheesh@ti.com>
In-Reply-To: <1299065886-30099-2-git-send-email-pratheesh@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201103021422.27094.arnd@arndb.de>
X-Provags-ID: V02:K0:2p4y5GhkMz1XvlNtw0ZRVXeNVAH7HXbZgBsM453J5gN
 vXIZffgM1ZMxAiOwD77/qwRGkX6Ena8coaIfaM6+ZUb9+9+x5J
 izkA4g69MJhL8YWLo8H2bZHIQTPoeCQ3EUbUAkzJ0Eh0z1fyZN
 nFXkTPrsW0HuEe6U5tXiodSuA5pLK4LmTpz7UzLRtccrMj0T0k
 PLkzIJ9MQFfGSiT1drbGg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 March 2011, Pratheesh Gangadhar wrote:
> +
> +static struct clk *pruss_clk;
> +static struct uio_info *info;
> +static dma_addr_t sram_paddr, ddr_paddr;
> +static void *prussio_vaddr, *sram_vaddr, *ddr_vaddr;
> +

To my initial comment about these being single-instance
variables, you said you'd change that, which has not happened
yet.

Also, I now noticed that the types are wrong, you are
missing __iomem annotations for MMIO ranges. Please make
sure that the code builds fine with sparse and "make C=1",
which will tell you about these problems.

	Arnd
