Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab1K2WFf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 17:05:35 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:51776 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099Ab1K2WFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 17:05:31 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Michael S. Tsirkin" <mst@redhat.com>, Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH-RFC 1/2] tile: don't panic on iomap
Date: Tue, 29 Nov 2011 22:05:11 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Paul Mundt <lethal@linux-sh.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
References: <cover.1322592494.git.mst@redhat.com> <a3bc9cb56040258dabc7b466ea217f4515b68b7d.1322592495.git.mst@redhat.com>
In-Reply-To: <a3bc9cb56040258dabc7b466ea217f4515b68b7d.1322592495.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111292205.11544.arnd@arndb.de>
X-Provags-ID: V02:K0:nbprdxhndoQXeBEl9Gi8Pp7B+umzdbtwxvgjYXWRmOo
 j2feTO/BCWfyYHqUD6xvFHCVAg0Mnyo8jkMp54fNQ1TNuQHZ5D
 DNl7Zft+Zr/voEtQw/RnqNYv+dr78SQwQAmroy79x5E4hCx0wc
 EuK7vb2a+B9O3laMXVRpffkx7mBNmgULoTw4hTFG1qIfe2xDKa
 j6voWghyOORQ+7It5kxecIlPgCbSJR8MajL6Bq1ghOEAOdJVMa
 OV99M4+FEvpNxvG6tvM4F1mmToNpytFlTdFwJBNKSjpnwt0ZwQ
 JUG7au1jtvX+ApUBbFfbaNfEoaBqcOrS/RpCOBLcagZg2PY1ZO
 FCl/C64dZWALPX4uzxkw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 November 2011, Michael S. Tsirkin wrote:
> diff --git a/arch/tile/include/asm/io.h b/arch/tile/include/asm/io.h
> index c9ea165..be6090d 100644
> --- a/arch/tile/include/asm/io.h
> +++ b/arch/tile/include/asm/io.h
> @@ -204,7 +204,8 @@ static inline long ioport_panic(void)
>  
>  static inline void __iomem *ioport_map(unsigned long port, unsigned int len)
>  {
> -       return (void __iomem *) ioport_panic();
> +       pr_info("Trying to map an IO resource - it does not exit on tile.\n");
> +       return NULL;
>  }

Why not just set CONFIG_NO_IOPORT and make this unavailable at compile time?

	Arnd
