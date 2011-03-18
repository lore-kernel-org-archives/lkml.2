Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347Ab1CRIfF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 04:35:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54694 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab1CRIey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 04:34:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andy Green <andy@warmcat.com>
Subject: Re: [RFC PATCH 2/5] OMAP2+: add cpu id register to MAC address helper
Date: Fri, 18 Mar 2011 09:34:39 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, Andy Green <andy.green@linaro.org>
References: <20110312224440.27728.60593.stgit@otae.warmcat.com> <20110312225047.27728.1835.stgit@otae.warmcat.com>
In-Reply-To: <20110312225047.27728.1835.stgit@otae.warmcat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103180934.39997.arnd@arndb.de>
X-Provags-ID: V02:K0:y1RH449oVHbQFmig2mDrIKkOb5SgUPgft4OODSe+sze
 1mNnn7wl5CC5x45Hm125ctmX9BqW9byJ5i2UVm5inly43SHjlr
 UGMQW5RKYp7Bm0w2LOBbdehX40HqAUBTZYt3RxHbpSGuzSTJBl
 haDB9skAy9F1InW3mW0z8iadAnagws5uqlJI+dbE8trb8Q6ZTX
 mQyGFqnpb0bTSbWLtt4eQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 March 2011, Andy Green wrote:
> Introduce a generic helper function that can set a MAC address using
> data from the OMAP unqiue CPU ID register.
> 
> Signed-off-by: Andy Green <andy.green@linaro.org>
> ---
> 
>  arch/arm/mach-omap2/id.c              |   13 +++++++++++++
>  arch/arm/mach-omap2/include/mach/id.h |    1 +
>  2 files changed, 14 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/id.c b/arch/arm/mach-omap2/id.c
> index 5f9086c..fc69ec5 100644
> --- a/arch/arm/mach-omap2/id.c
> +++ b/arch/arm/mach-omap2/id.c
> @@ -506,3 +506,16 @@ void __init omap2_set_globals_tap(struct omap_globals *omap2_globals)
>         else
>                 tap_prod_id = 0x0208;
>  }
> +
> +
> +void omap2_die_id_to_mac(u8 *mac, int length)
> +{
> +       struct omap_die_id odi;
> +
> +       omap_get_die_id(&odi);
> +       memcpy(mac, &odi.id_0, length);
> +
> +       /* mark it as not multicast and outside official 80211 MAC namespace */
> +
> +       mac[0] = (mac[0] & ~1) | 2;
> +}

This is a pretty clever trick, but it's not an official globally unique MAC
address, right? Maybe we can ask TI to officially request a MAC address range
for OMAP SoCs and document an official procedure to compute it.

	Arnd
