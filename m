Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263Ab0KVVgx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 16:36:53 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:63070 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755610Ab0KVVgw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 16:36:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LTThSGobAe4YtZPJa9BEjc8i8plnDyaAggh6eBwFm9jY1Pd/BYEMnYuKCIvICmJ/t6
         DBxmqVi8PIHsmucELSaYlx01cNaAjXE20qswzALluwpbZCYXLUdyJ82xX0zplZLT+bRA
         DcaeD0zlVE0NCIqdvueomiIgSNJc4ZNPb7Mlk=
MIME-Version: 1.0
In-Reply-To: <20101122124834.74429004.randy.dunlap@oracle.com>
References: <AANLkTikKAO7TMhYgGU=ggWCTXbvABsgjhmQUPRQB35kL@mail.gmail.com>
	<20101122124834.74429004.randy.dunlap@oracle.com>
Date: Mon, 22 Nov 2010 22:36:51 +0100
Message-ID: <AANLkTin7Jynhdsd07JHHeaq34Nn_FMp6w4QWKwymNktc@mail.gmail.com>
Subject: Re: [PATCH] dmar: use function stubs when CONFIG_INTR_REMAP is disabled
From: Fabio Comolli <fabio.comolli@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-and-Tested-by: Fabio Comolli <fabio.comolli@gmail.com>

On Mon, Nov 22, 2010 at 9:48 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> The stubs for CONFIG_INTR_REMAP disabled need to be functions
> instead of values to eliminate build warnings.
>
> arch/x86/kernel/apic/apic.c: In function 'lapic_suspend':
> arch/x86/kernel/apic/apic.c:2060:3: warning: statement with no effect
> arch/x86/kernel/apic/apic.c: In function 'lapic_resume':
> arch/x86/kernel/apic/apic.c:2137:3: warning: statement with no effect
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Reported-by: Fabio Comolli <fabio.comolli@gmail.com>
> ---
>  include/linux/dmar.h |   17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
>
> --- lnx-2637-rc3.orig/include/linux/dmar.h
> +++ lnx-2637-rc3/include/linux/dmar.h
> @@ -175,10 +175,21 @@ static inline int set_msi_sid(struct irt
>        return 0;
>  }
>
> -#define enable_intr_remapping(mode)    (-1)
> -#define disable_intr_remapping()       (0)
> -#define reenable_intr_remapping(mode)  (0)
>  #define intr_remapping_enabled         (0)
> +
> +static inline int enable_intr_remapping(int eim)
> +{
> +       return -1;
> +}
> +
> +static inline void disable_intr_remapping(void)
> +{
> +}
> +
> +static inline int reenable_intr_remapping(int eim)
> +{
> +       return 0;
> +}
>  #endif
>
>  /* Can't use the common MSI interrupt functions
>
