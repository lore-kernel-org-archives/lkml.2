Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab2JDMDJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 08:03:09 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62805 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773Ab2JDMDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 08:03:07 -0400
MIME-Version: 1.0
In-Reply-To: <1348497799-32143-2-git-send-email-ulf.hansson@stericsson.com>
References: <1348497799-32143-1-git-send-email-ulf.hansson@stericsson.com>
	<1348497799-32143-2-git-send-email-ulf.hansson@stericsson.com>
Date: Thu, 4 Oct 2012 14:03:05 +0200
Message-ID: <CAPDyKFr+Eb5=Cz5jHpyVmpX_-v9i8R6-qmK6ZfX75jw218S46g@mail.gmail.com>
Subject: Re: [PATCH 1/3] mfd: dbx500: Export prmcu_request_ape_opp_100_voltage
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-arm-kernel@lists.infradead.org, Mike Turquette <mturquette@ti.com>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Philippe Begnic <philippe.begnic@st.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam and Linus,

Do you see any issues with this patch? Can we advise Mike to merge it
though his clock tree?

Kind regards
Ulf Hansson

On 24 September 2012 16:43, Ulf Hansson <ulf.hansson@stericsson.com> wrote:
> From: Ulf Hansson <ulf.hansson@linaro.org>
>
> This function needs to be exported to let clients be able to
> request the ape opp 100 voltage.
>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> ---
>  drivers/mfd/db8500-prcmu.c       |    4 ++--
>  include/linux/mfd/db8500-prcmu.h |    4 ++--
>  include/linux/mfd/dbx500-prcmu.h |   10 ++++++++++
>  3 files changed, 14 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
> index e7f9539..0b8e0a0 100644
> --- a/drivers/mfd/db8500-prcmu.c
> +++ b/drivers/mfd/db8500-prcmu.c
> @@ -1167,12 +1167,12 @@ int db8500_prcmu_get_ape_opp(void)
>  }
>
>  /**
> - * prcmu_request_ape_opp_100_voltage - Request APE OPP 100% voltage
> + * db8500_prcmu_request_ape_opp_100_voltage - Request APE OPP 100% voltage
>   * @enable: true to request the higher voltage, false to drop a request.
>   *
>   * Calls to this function to enable and disable requests must be balanced.
>   */
> -int prcmu_request_ape_opp_100_voltage(bool enable)
> +int db8500_prcmu_request_ape_opp_100_voltage(bool enable)
>  {
>         int r = 0;
>         u8 header;
> diff --git a/include/linux/mfd/db8500-prcmu.h b/include/linux/mfd/db8500-prcmu.h
> index b82f6ee..6ee4247 100644
> --- a/include/linux/mfd/db8500-prcmu.h
> +++ b/include/linux/mfd/db8500-prcmu.h
> @@ -515,7 +515,6 @@ enum romcode_read prcmu_get_rc_p2a(void);
>  enum ap_pwrst prcmu_get_xp70_current_state(void);
>  bool prcmu_has_arm_maxopp(void);
>  struct prcmu_fw_version *prcmu_get_fw_version(void);
> -int prcmu_request_ape_opp_100_voltage(bool enable);
>  int prcmu_release_usb_wakeup_state(void);
>  void prcmu_configure_auto_pm(struct prcmu_auto_pm_config *sleep,
>         struct prcmu_auto_pm_config *idle);
> @@ -564,6 +563,7 @@ int db8500_prcmu_set_arm_opp(u8 opp);
>  int db8500_prcmu_get_arm_opp(void);
>  int db8500_prcmu_set_ape_opp(u8 opp);
>  int db8500_prcmu_get_ape_opp(void);
> +int db8500_prcmu_request_ape_opp_100_voltage(bool enable);
>  int db8500_prcmu_set_ddr_opp(u8 opp);
>  int db8500_prcmu_get_ddr_opp(void);
>
> @@ -610,7 +610,7 @@ static inline int db8500_prcmu_get_ape_opp(void)
>         return APE_100_OPP;
>  }
>
> -static inline int prcmu_request_ape_opp_100_voltage(bool enable)
> +static inline int db8500_prcmu_request_ape_opp_100_voltage(bool enable)
>  {
>         return 0;
>  }
> diff --git a/include/linux/mfd/dbx500-prcmu.h b/include/linux/mfd/dbx500-prcmu.h
> index c410d99..c202d6c 100644
> --- a/include/linux/mfd/dbx500-prcmu.h
> +++ b/include/linux/mfd/dbx500-prcmu.h
> @@ -336,6 +336,11 @@ static inline int prcmu_get_ape_opp(void)
>         return db8500_prcmu_get_ape_opp();
>  }
>
> +static inline int prcmu_request_ape_opp_100_voltage(bool enable)
> +{
> +       return db8500_prcmu_request_ape_opp_100_voltage(enable);
> +}
> +
>  static inline void prcmu_system_reset(u16 reset_code)
>  {
>         return db8500_prcmu_system_reset(reset_code);
> @@ -507,6 +512,11 @@ static inline int prcmu_get_ape_opp(void)
>         return APE_100_OPP;
>  }
>
> +static inline int prcmu_request_ape_opp_100_voltage(bool enable)
> +{
> +       return 0;
> +}
> +
>  static inline int prcmu_set_arm_opp(u8 opp)
>  {
>         return 0;
> --
> 1.7.10
>
