Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab1LSVsm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 16:48:42 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:38472 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab1LSVsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 16:48:39 -0500
Date: Mon, 19 Dec 2011 14:48:38 -0700 (MST)
From: Paul Walmsley <paul@pwsan.com>
To: "Cousson, Benoit" <b-cousson@ti.com>
cc: Ming Lei <ming.lei@canonical.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Sylwester Nawrocki <snjw23@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/8] omap4: introduce fdif(face detect module)
 hwmod
In-Reply-To: <4EEB5BBC.7050807@ti.com>
Message-ID: <alpine.DEB.2.00.1112191447270.12660@utopia.booyaka.com>
References: <1323871214-25435-1-git-send-email-ming.lei@canonical.com> <1323871214-25435-2-git-send-email-ming.lei@canonical.com> <alpine.DEB.2.00.1112152252260.12660@utopia.booyaka.com> <4EEB5BBC.7050807@ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="155748971-1471173727-1324331318=:12660"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--155748971-1471173727-1324331318=:12660
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hi Beno=EEt,

On Fri, 16 Dec 2011, Cousson, Benoit wrote:

> On 12/16/2011 6:53 AM, Paul Walmsley wrote:
> > Hi Beno=EEt
> >=20
> > On Wed, 14 Dec 2011, Ming Lei wrote:
> >=20
> > > Signed-off-by: Ming Lei<ming.lei@canonical.com>
>=20
> Acked-by: Benoit Cousson <b-cousson@ti.com>
>=20
> > > ---
> > >   arch/arm/mach-omap2/omap_hwmod_44xx_data.c |   81
> > > ++++++++++++++++++++++++++++
> > >   1 files changed, 81 insertions(+), 0 deletions(-)
> >=20
> > any comments on this patch?  I'd like to queue it if it looks good to y=
ou.
>=20
> It looks good to me. The only minor comment is about fdif location in the=
 list
> that should be sorted and thus cannot be after wd_timer2.

Thanks, patch updated to match the script output and queued.  Modified=20
patch follows.


- Paul

From: Ming Lei <ming.lei@canonical.com>
Date: Mon, 19 Dec 2011 14:34:06 -0700
Subject: [PATCH] ARM: OMAP4: hwmod data: introduce fdif(face detect module)
 hwmod

Add hwmod data for the OMAP4 FDIF IP block.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
Acked-by: Beno=EEt Cousson <b-cousson@ti.com>
[paul@pwsan.com: rearranged to match script output; fixed FDIF end address =
to
 match script data; wrote trivial changelog]
Signed-off-by: Paul Walmsley <paul@pwsan.com>
---
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c |   85 ++++++++++++++++++++++++=
++++
 1 files changed, 85 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-oma=
p2/omap_hwmod_44xx_data.c
index daaf165..3ac4bf6 100644
--- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
@@ -53,6 +53,7 @@ static struct omap_hwmod omap44xx_dmm_hwmod;
 static struct omap_hwmod omap44xx_dsp_hwmod;
 static struct omap_hwmod omap44xx_dss_hwmod;
 static struct omap_hwmod omap44xx_emif_fw_hwmod;
+static struct omap_hwmod omap44xx_fdif_hwmod;
 static struct omap_hwmod omap44xx_hsi_hwmod;
 static struct omap_hwmod omap44xx_ipu_hwmod;
 static struct omap_hwmod omap44xx_iss_hwmod;
@@ -346,6 +347,14 @@ static struct omap_hwmod_ocp_if omap44xx_dma_system__l=
3_main_2 =3D {
 =09.user=09=09=3D OCP_USER_MPU | OCP_USER_SDMA,
 };
=20
+/* fdif -> l3_main_2 */
+static struct omap_hwmod_ocp_if omap44xx_fdif__l3_main_2 =3D {
+=09.master=09=09=3D &omap44xx_fdif_hwmod,
+=09.slave=09=09=3D &omap44xx_l3_main_2_hwmod,
+=09.clk=09=09=3D "l3_div_ck",
+=09.user=09=09=3D OCP_USER_MPU | OCP_USER_SDMA,
+};
+
 /* hsi -> l3_main_2 */
 static struct omap_hwmod_ocp_if omap44xx_hsi__l3_main_2 =3D {
 =09.master=09=09=3D &omap44xx_hsi_hwmod,
@@ -1797,6 +1806,79 @@ static struct omap_hwmod omap44xx_dss_venc_hwmod =3D=
 {
 };
=20
 /*
+ * 'fdif' class
+ * face detection hw accelerator module
+ */
+
+static struct omap_hwmod_class_sysconfig omap44xx_fdif_sysc =3D {
+=09.rev_offs=09=3D 0x0000,
+=09.sysc_offs=09=3D 0x0010,
+=09.sysc_flags=09=3D (SYSC_HAS_MIDLEMODE | SYSC_HAS_RESET_STATUS |
+=09=09=09   SYSC_HAS_SIDLEMODE | SYSC_HAS_SOFTRESET),
+=09.idlemodes=09=3D (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
+=09=09=09   MSTANDBY_FORCE | MSTANDBY_NO | MSTANDBY_SMART),
+=09.sysc_fields=09=3D &omap_hwmod_sysc_type2,
+};
+
+static struct omap_hwmod_class omap44xx_fdif_hwmod_class =3D {
+=09.name=09=3D "fdif",
+=09.sysc=09=3D &omap44xx_fdif_sysc,
+};
+
+/* fdif */
+static struct omap_hwmod_irq_info omap44xx_fdif_irqs[] =3D {
+=09{ .irq =3D 69 + OMAP44XX_IRQ_GIC_START },
+=09{ .irq =3D -1 }
+};
+
+/* fdif master ports */
+static struct omap_hwmod_ocp_if *omap44xx_fdif_masters[] =3D {
+=09&omap44xx_fdif__l3_main_2,
+};
+
+static struct omap_hwmod_addr_space omap44xx_fdif_addrs[] =3D {
+=09{
+=09=09.pa_start=09=3D 0x4a10a000,
+=09=09.pa_end=09=09=3D 0x4a10a1ff,
+=09=09.flags=09=09=3D ADDR_TYPE_RT
+=09},
+=09{ }
+};
+
+/* l4_cfg -> fdif */
+static struct omap_hwmod_ocp_if omap44xx_l4_cfg__fdif =3D {
+=09.master=09=09=3D &omap44xx_l4_cfg_hwmod,
+=09.slave=09=09=3D &omap44xx_fdif_hwmod,
+=09.clk=09=09=3D "l4_div_ck",
+=09.addr=09=09=3D omap44xx_fdif_addrs,
+=09.user=09=09=3D OCP_USER_MPU | OCP_USER_SDMA,
+};
+
+/* fdif slave ports */
+static struct omap_hwmod_ocp_if *omap44xx_fdif_slaves[] =3D {
+=09&omap44xx_l4_cfg__fdif,
+};
+
+static struct omap_hwmod omap44xx_fdif_hwmod =3D {
+=09.name=09=09=3D "fdif",
+=09.class=09=09=3D &omap44xx_fdif_hwmod_class,
+=09.clkdm_name=09=3D "iss_clkdm",
+=09.mpu_irqs=09=3D omap44xx_fdif_irqs,
+=09.main_clk=09=3D "fdif_fck",
+=09.prcm =3D {
+=09=09.omap4 =3D {
+=09=09=09.clkctrl_offs =3D OMAP4_CM_CAM_FDIF_CLKCTRL_OFFSET,
+=09=09=09.context_offs =3D OMAP4_RM_CAM_FDIF_CONTEXT_OFFSET,
+=09=09=09.modulemode   =3D MODULEMODE_SWCTRL,
+=09=09},
+=09},
+=09.slaves=09=09=3D omap44xx_fdif_slaves,
+=09.slaves_cnt=09=3D ARRAY_SIZE(omap44xx_fdif_slaves),
+=09.masters=09=3D omap44xx_fdif_masters,
+=09.masters_cnt=09=3D ARRAY_SIZE(omap44xx_fdif_masters),
+};
+
+/*
  * 'gpio' class
  * general purpose io module
  */
@@ -5327,6 +5409,9 @@ static __initdata struct omap_hwmod *omap44xx_hwmods[=
] =3D {
 =09&omap44xx_dss_rfbi_hwmod,
 =09&omap44xx_dss_venc_hwmod,
=20
+=09/* fdif class */
+=09&omap44xx_fdif_hwmod,
+
 =09/* gpio class */
 =09&omap44xx_gpio1_hwmod,
 =09&omap44xx_gpio2_hwmod,
--=20
1.7.7.3

--155748971-1471173727-1324331318=:12660--
