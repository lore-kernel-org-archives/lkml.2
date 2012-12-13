Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab2LMAub (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 19:50:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54964 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754908Ab2LMAu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 19:50:29 -0500
Message-ID: <50C925F5.7030703@zytor.com>
Date: Wed, 12 Dec 2012 16:48:53 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Davide Ciminaghi <ciminaghi@gnudd.com>
CC: jaswinder.singh@linaro.org, will.deacon@arm.com, linux@arm.linux.org.uk,
        tglx@linutronix.de, mingo@redhat.com, djbw@fb.com,
        vinod.koul@intel.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, rubini@gnudd.com, wim@iguana.be,
        cjb@laptop.org, davidb@codeaurora.org, nico@fluxnic.net,
        ben-linux@fluff.org, viresh.linux@gmail.com, rajeev-dlh.kumar@st.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        giancarlo.asnaghi@st.com
Subject: Re: [PATCH v4 7/7] x86: add CONFIG_ARM_AMBA, selected by STA2X11
References: <1355146956-6009-1-git-send-email-ciminaghi@gnudd.com> <1355146956-6009-8-git-send-email-ciminaghi@gnudd.com>
In-Reply-To: <1355146956-6009-8-git-send-email-ciminaghi@gnudd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2012 05:42 AM, Davide Ciminaghi wrote:
> From: Alessandro Rubini <rubini@gnudd.com>
>
> The sta2x11 I/O Hub is a bridge from PCIe to AMBA. It reuses a number
> of amba drivers and needs to activate core bus support.
>
> Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
> Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
> ---
>   arch/x86/Kconfig |    4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 5f67642..0659e7b 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -521,6 +521,7 @@ config STA2X11
>   	select SWIOTLB
>   	select MFD_STA2X11
>   	select ARCH_REQUIRE_GPIOLIB
> +	select ARM_AMBA
>   	default n
>   	---help---
>   	  This adds support for boards based on the STA2X11 IO-Hub,
> @@ -2237,6 +2238,9 @@ config GEOS
>
>   endif # X86_32
>
> +config ARM_AMBA
> +        bool
> +
>   config AMD_NB
>   	def_bool y
>   	depends on CPU_SUP_AMD && PCI
>

I would be happier if instead we made this match PCI and made this a 
depends on, but I'm not sure if it is worth holding up the patchset over.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

