Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662Ab1LPFxO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 00:53:14 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:33278 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198Ab1LPFxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 00:53:12 -0500
Date: Thu, 15 Dec 2011 22:53:11 -0700 (MST)
From: Paul Walmsley <paul@pwsan.com>
To: b-cousson@ti.com
cc: Ming Lei <ming.lei@canonical.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Sylwester Nawrocki <snjw23@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/8] omap4: introduce fdif(face detect module)
 hwmod
In-Reply-To: <1323871214-25435-2-git-send-email-ming.lei@canonical.com>
Message-ID: <alpine.DEB.2.00.1112152252260.12660@utopia.booyaka.com>
References: <1323871214-25435-1-git-send-email-ming.lei@canonical.com> <1323871214-25435-2-git-send-email-ming.lei@canonical.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="155748971-247848974-1324014791=:12660"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--155748971-247848974-1324014791=:12660
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hi Beno=EEt

On Wed, 14 Dec 2011, Ming Lei wrote:

> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
>  arch/arm/mach-omap2/omap_hwmod_44xx_data.c |   81 ++++++++++++++++++++++=
++++++
>  1 files changed, 81 insertions(+), 0 deletions(-)

any comments on this patch?  I'd like to queue it if it looks good to you.

- Paul

>=20
> diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-o=
map2/omap_hwmod_44xx_data.c
> index 6cf21ee..30db754 100644
> --- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
> +++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
> @@ -53,6 +53,7 @@ static struct omap_hwmod omap44xx_dmm_hwmod;
>  static struct omap_hwmod omap44xx_dsp_hwmod;
>  static struct omap_hwmod omap44xx_dss_hwmod;
>  static struct omap_hwmod omap44xx_emif_fw_hwmod;
> +static struct omap_hwmod omap44xx_fdif_hwmod;
>  static struct omap_hwmod omap44xx_hsi_hwmod;
>  static struct omap_hwmod omap44xx_ipu_hwmod;
>  static struct omap_hwmod omap44xx_iss_hwmod;
> @@ -354,6 +355,14 @@ static struct omap_hwmod_ocp_if omap44xx_dma_system_=
_l3_main_2 =3D {
>  =09.user=09=09=3D OCP_USER_MPU | OCP_USER_SDMA,
>  };
> =20
> +/* fdif -> l3_main_2 */
> +static struct omap_hwmod_ocp_if omap44xx_fdif__l3_main_2 =3D {
> +=09.master=09=09=3D &omap44xx_fdif_hwmod,
> +=09.slave=09=09=3D &omap44xx_l3_main_2_hwmod,
> +=09.clk=09=09=3D "l3_div_ck",
> +=09.user=09=09=3D OCP_USER_MPU | OCP_USER_SDMA,
> +};
> +
>  /* hsi -> l3_main_2 */
>  static struct omap_hwmod_ocp_if omap44xx_hsi__l3_main_2 =3D {
>  =09.master=09=09=3D &omap44xx_hsi_hwmod,
> @@ -5444,6 +5453,75 @@ static struct omap_hwmod omap44xx_wd_timer3_hwmod =
=3D {
>  =09.slaves_cnt=09=3D ARRAY_SIZE(omap44xx_wd_timer3_slaves),
>  };
> =20
> +/* 'fdif' class */
> +static struct omap_hwmod_class_sysconfig omap44xx_fdif_sysc =3D {
> +=09.rev_offs=09=3D 0x0000,
> +=09.sysc_offs=09=3D 0x0010,
> +=09.sysc_flags=09=3D (SYSC_HAS_MIDLEMODE | SYSC_HAS_RESET_STATUS |
> +=09=09=09   SYSC_HAS_SIDLEMODE | SYSC_HAS_SOFTRESET),
> +=09.idlemodes=09=3D (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
> +=09=09=09   MSTANDBY_FORCE | MSTANDBY_NO |
> +=09=09=09   MSTANDBY_SMART),
> +=09.sysc_fields=09=3D &omap_hwmod_sysc_type2,
> +};
> +
> +static struct omap_hwmod_class omap44xx_fdif_hwmod_class =3D {
> +=09.name=09=3D "fdif",
> +=09.sysc=09=3D &omap44xx_fdif_sysc,
> +};
> +
> +/*fdif*/
> +static struct omap_hwmod_addr_space omap44xx_fdif_addrs[] =3D {
> +=09{
> +=09=09.pa_start=09=3D 0x4a10a000,
> +=09=09.pa_end=09=09=3D 0x4a10afff,
> +=09=09.flags=09=09=3D ADDR_TYPE_RT
> +=09},
> +=09{ }
> +};
> +
> +/* l4_cfg -> fdif */
> +static struct omap_hwmod_ocp_if omap44xx_l4_cfg__fdif =3D {
> +=09.master=09=09=3D &omap44xx_l4_cfg_hwmod,
> +=09.slave=09=09=3D &omap44xx_fdif_hwmod,
> +=09.clk=09=09=3D "l4_div_ck",
> +=09.addr=09=09=3D omap44xx_fdif_addrs,
> +=09.user=09=09=3D OCP_USER_MPU | OCP_USER_SDMA,
> +};
> +
> +/* fdif slave ports */
> +static struct omap_hwmod_ocp_if *omap44xx_fdif_slaves[] =3D {
> +=09&omap44xx_l4_cfg__fdif,
> +};
> +static struct omap_hwmod_irq_info omap44xx_fdif_irqs[] =3D {
> +=09{ .irq =3D 69 + OMAP44XX_IRQ_GIC_START },
> +=09{ .irq =3D -1 }
> +};
> +
> +/* fdif master ports */
> +static struct omap_hwmod_ocp_if *omap44xx_fdif_masters[] =3D {
> +=09&omap44xx_fdif__l3_main_2,
> +};
> +
> +static struct omap_hwmod omap44xx_fdif_hwmod =3D {
> +=09.name=09=09=3D "fdif",
> +=09.class=09=09=3D &omap44xx_fdif_hwmod_class,
> +=09.clkdm_name=09=3D "iss_clkdm",
> +=09.mpu_irqs=09=3D omap44xx_fdif_irqs,
> +=09.main_clk=09=3D "fdif_fck",
> +=09.prcm =3D {
> +=09=09.omap4 =3D {
> +=09=09=09.clkctrl_offs =3D OMAP4_CM_CAM_FDIF_CLKCTRL_OFFSET,
> +=09=09=09.context_offs =3D OMAP4_RM_CAM_FDIF_CONTEXT_OFFSET,
> +=09=09=09.modulemode   =3D MODULEMODE_SWCTRL,
> +=09=09},
> +=09},
> +=09.slaves=09=09=3D omap44xx_fdif_slaves,
> +=09.slaves_cnt=09=3D ARRAY_SIZE(omap44xx_fdif_slaves),
> +=09.masters=09=3D omap44xx_fdif_masters,
> +=09.masters_cnt=09=3D ARRAY_SIZE(omap44xx_fdif_masters),
> +};
> +
>  static __initdata struct omap_hwmod *omap44xx_hwmods[] =3D {
> =20
>  =09/* dmm class */
> @@ -5593,6 +5671,9 @@ static __initdata struct omap_hwmod *omap44xx_hwmod=
s[] =3D {
>  =09&omap44xx_wd_timer2_hwmod,
>  =09&omap44xx_wd_timer3_hwmod,
> =20
> +=09/* fdif class */
> +=09&omap44xx_fdif_hwmod,
> +
>  =09NULL,
>  };
> =20
> --=20
> 1.7.5.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


- Paul
--155748971-247848974-1324014791=:12660--
