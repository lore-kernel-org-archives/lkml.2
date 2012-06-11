Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab2FKOJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 10:09:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61192 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717Ab2FKOJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 10:09:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Subject: Re: [PATCH 1/4] drivers/net/ethernet/sfc: Add efx_ prefix to set_bit_le()
Date: Mon, 11 Jun 2012 14:09:15 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: bhutchings@solarflare.com, grundler@parisc-linux.org, avi@redhat.com,
        mtosatti@redhat.com, linux-net-drivers@solarflare.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, kvm@vger.kernel.org,
        takuya.yoshikawa@gmail.com
References: <20120611212735.f92ea521.yoshikawa.takuya@oss.ntt.co.jp> <20120611212901.2b4d0a17.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20120611212901.2b4d0a17.yoshikawa.takuya@oss.ntt.co.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206111409.16093.arnd@arndb.de>
X-Provags-ID: V02:K0:e8K5KCwtgYGvQ+3v/2p9ON7x8SpbOt4pXHMhojTb0Is
 OuG2ARqiXF+Ak84K0G69gtRKS+dX6vRsnqiLFyHnepEnfmu6Jj
 CnO/Btd0Y3YDbSdNYw9GOC8YiC/rqlXw1+LbHH1ZA9bbuiM3hH
 kmhLy/oHxLFPfM0DSY0l5Sf1ohakjXxdJjAcpfEsNX0pYhkzwI
 slXKrcsOUT4hz3G5G3mVgwyXZV8vprF3oPJ+uLffVi9bqK9+bn
 8wcUsQSJeGpUvsj07zMXIXbbIsml7GD8TOfl44UG1wOhCSHvXn
 Q96NT9Tnc5/lK4wjq7EYvXe1JqollSyq3WmkpGnU1LKdqtFhhp
 JKKOYpeLqe3roGzP/m/U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 June 2012, Takuya Yoshikawa wrote:
> 
>  /* Set bit in a little-endian bitfield */
> -static inline void set_bit_le(unsigned nr, unsigned char *addr)
> +static inline void efx_set_bit_le(unsigned nr, unsigned char *addr)
>  {
>         addr[nr / 8] |= (1 << (nr % 8));
>  }
>  
>  /* Clear bit in a little-endian bitfield */
> -static inline void clear_bit_le(unsigned nr, unsigned char *addr)
> +static inline void efx_clear_bit_le(unsigned nr, unsigned char *addr)
>  {
>         addr[nr / 8] &= ~(1 << (nr % 8));
>  }

Hmm, any reason why we're not just using the existing non-atomic
__set_bit_le() here? I think the helpers in sfc and tulip can
just get removed if you use those.

	Arnd
