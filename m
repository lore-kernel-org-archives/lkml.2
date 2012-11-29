Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932630Ab2K2D5U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 22:57:20 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:39441 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932504Ab2K2D5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 22:57:18 -0500
Date: Thu, 29 Nov 2012 14:57:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Davide Ciminaghi <ciminaghi@gnudd.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: linux-next: manual merge of the driver-core tree with the mfd tree
Message-Id: <20121129145714.4da1094e1f33ce8db417fa19@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__29_Nov_2012_14_57_14_+1100_n7T8lL3qDkETQ_x5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Nov_2012_14_57_14_+1100_n7T8lL3qDkETQ_x5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
drivers/mfd/sta2x11-mfd.c between various commits from the mfd tree and
commits f791be492f76 ("mfd: remove use of __devinit"), a9e9ce4c4167
("mfd: remove use of __devinitdata") and a73e5df16b52 ("mfd: remove use
of __devinitconst") from the driver-core tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/mfd/sta2x11-mfd.c
index 6fb0938,d6284ca..0000000
--- a/drivers/mfd/sta2x11-mfd.c
+++ b/drivers/mfd/sta2x11-mfd.c
@@@ -76,9 -69,8 +76,9 @@@ static struct sta2x11_mfd *sta2x11_mfd_
  	return NULL;
  }
 =20
- static int __devinit sta2x11_mfd_add(struct pci_dev *pdev, gfp_t flags)
+ static int sta2x11_mfd_add(struct pci_dev *pdev, gfp_t flags)
  {
 +	int i;
  	struct sta2x11_mfd *mfd =3D sta2x11_mfd_find(pdev);
  	struct sta2x11_instance *instance;
 =20
@@@ -458,73 -305,42 +458,73 @@@ enum mfd0_bar1_cells=20
  		.flags =3D IORESOURCE_MEM, \
  		}
 =20
- static const __devinitconst struct resource gpio_resources[] =3D {
+ static const struct resource gpio_resources[] =3D {
  	{
 -		.name =3D "sta2x11_gpio", /* 4 consecutive cells, 1 driver */
 +		/* 4 consecutive cells, 1 driver */
 +		.name =3D STA2X11_MFD_GPIO_NAME,
  		.start =3D 0,
  		.end =3D (4 * 4096) - 1,
  		.flags =3D IORESOURCE_MEM,
  	}
  };
- static const __devinitconst struct resource sctl_resources[] =3D {
+ static const struct resource sctl_resources[] =3D {
 -	CELL_4K("sta2x11-sctl", STA2X11_SCTL),
 +	CELL_4K(STA2X11_MFD_SCTL_NAME, STA2X11_SCTL),
  };
- static const __devinitconst struct resource scr_resources[] =3D {
+ static const struct resource scr_resources[] =3D {
 -	CELL_4K("sta2x11-scr", STA2X11_SCR),
 +	CELL_4K(STA2X11_MFD_SCR_NAME, STA2X11_SCR),
  };
- static const __devinitconst struct resource time_resources[] =3D {
+ static const struct resource time_resources[] =3D {
 -	CELL_4K("sta2x11-time", STA2X11_TIME),
 +	CELL_4K(STA2X11_MFD_TIME_NAME, STA2X11_TIME),
  };
 =20
- static const __devinitconst struct resource apbreg_resources[] =3D {
+ static const struct resource apbreg_resources[] =3D {
 -	CELL_4K("sta2x11-apbreg", STA2X11_APBREG),
 +	CELL_4K(STA2X11_MFD_APBREG_NAME, STA2X11_APBREG),
  };
 =20
  #define DEV(_name, _r) \
  	{ .name =3D _name, .num_resources =3D ARRAY_SIZE(_r), .resources =3D _r,=
 }
 =20
- static __devinitdata struct mfd_cell sta2x11_mfd0_bar0[] =3D {
 -static struct mfd_cell sta2x11_mfd_bar0[] =3D {
 -	DEV("sta2x11-gpio", gpio_resources), /* offset 0: we add pdata later */
 -	DEV("sta2x11-sctl", sctl_resources),
 -	DEV("sta2x11-scr", scr_resources),
 -	DEV("sta2x11-time", time_resources),
++static struct mfd_cell sta2x11_mfd0_bar0[] =3D {
 +	/* offset 0: we add pdata later */
 +	DEV(STA2X11_MFD_GPIO_NAME, gpio_resources),
 +	DEV(STA2X11_MFD_SCTL_NAME, sctl_resources),
 +	DEV(STA2X11_MFD_SCR_NAME,  scr_resources),
 +	DEV(STA2X11_MFD_TIME_NAME, time_resources),
  };
 =20
- static __devinitdata struct mfd_cell sta2x11_mfd0_bar1[] =3D {
 -static struct mfd_cell sta2x11_mfd_bar1[] =3D {
 -	DEV("sta2x11-apbreg", apbreg_resources),
++static struct mfd_cell sta2x11_mfd0_bar1[] =3D {
 +	DEV(STA2X11_MFD_APBREG_NAME, apbreg_resources),
  };
 =20
 +/* Mfd 1 devices */
 +
 +/* Mfd 1, Bar 0 */
 +enum mfd1_bar0_cells {
 +	STA2X11_VIC =3D 0,
 +};
 +
 +/* Mfd 1, Bar 1 */
 +enum mfd1_bar1_cells {
 +	STA2X11_APB_SOC_REGS =3D 0,
 +};
 +
- static const __devinitconst struct resource vic_resources[] =3D {
++static const struct resource vic_resources[] =3D {
 +	CELL_4K(STA2X11_MFD_VIC_NAME, STA2X11_VIC),
 +};
 +
- static const __devinitconst struct resource apb_soc_regs_resources[] =3D {
++static const struct resource apb_soc_regs_resources[] =3D {
 +	CELL_4K(STA2X11_MFD_APB_SOC_REGS_NAME, STA2X11_APB_SOC_REGS),
 +};
 +
- static __devinitdata struct mfd_cell sta2x11_mfd1_bar0[] =3D {
++static struct mfd_cell sta2x11_mfd1_bar0[] =3D {
 +	DEV(STA2X11_MFD_VIC_NAME, vic_resources),
 +};
 +
- static __devinitdata struct mfd_cell sta2x11_mfd1_bar1[] =3D {
++static struct mfd_cell sta2x11_mfd1_bar1[] =3D {
 +	DEV(STA2X11_MFD_APB_SOC_REGS_NAME, apb_soc_regs_resources),
 +};
 +
 +
  static int sta2x11_mfd_suspend(struct pci_dev *pdev, pm_message_t state)
  {
  	pci_save_state(pdev);
@@@ -547,59 -363,7 +547,59 @@@ static int sta2x11_mfd_resume(struct pc
  	return 0;
  }
 =20
 +struct sta2x11_mfd_bar_setup_data {
 +	struct mfd_cell *cells;
 +	int ncells;
 +};
 +
 +struct sta2x11_mfd_setup_data {
 +	struct sta2x11_mfd_bar_setup_data bars[2];
 +};
 +
 +#define STA2X11_MFD0 0
 +#define STA2X11_MFD1 1
 +
 +static struct sta2x11_mfd_setup_data mfd_setup_data[] =3D {
 +	/* Mfd 0: gpio, sctl, scr, timers / apbregs */
 +	[STA2X11_MFD0] =3D {
 +		.bars =3D {
 +			[0] =3D {
 +				.cells =3D sta2x11_mfd0_bar0,
 +				.ncells =3D ARRAY_SIZE(sta2x11_mfd0_bar0),
 +			},
 +			[1] =3D {
 +				.cells =3D sta2x11_mfd0_bar1,
 +				.ncells =3D ARRAY_SIZE(sta2x11_mfd0_bar1),
 +			},
 +		},
 +	},
 +	/* Mfd 1: vic / apb-soc-regs */
 +	[STA2X11_MFD1] =3D {
 +		.bars =3D {
 +			[0] =3D {
 +				.cells =3D sta2x11_mfd1_bar0,
 +				.ncells =3D ARRAY_SIZE(sta2x11_mfd1_bar0),
 +			},
 +			[1] =3D {
 +				.cells =3D sta2x11_mfd1_bar1,
 +				.ncells =3D ARRAY_SIZE(sta2x11_mfd1_bar1),
 +			},
 +		},
 +	},
 +};
 +
- static void __devinit sta2x11_mfd_setup(struct pci_dev *pdev,
++static void sta2x11_mfd_setup(struct pci_dev *pdev,
 +					struct sta2x11_mfd_setup_data *sd)
 +{
 +	int i, j;
 +	for (i =3D 0; i < ARRAY_SIZE(sd->bars); i++)
 +		for (j =3D 0; j < sd->bars[i].ncells; j++) {
 +			sd->bars[i].cells[j].pdata_size =3D sizeof(pdev);
 +			sd->bars[i].cells[j].platform_data =3D &pdev;
 +		}
 +}
 +
- static int __devinit sta2x11_mfd_probe(struct pci_dev *pdev,
+ static int sta2x11_mfd_probe(struct pci_dev *pdev,
  				       const struct pci_device_id *pci_id)
  {
  	int err, i;

--Signature=_Thu__29_Nov_2012_14_57_14_+1100_n7T8lL3qDkETQ_x5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQtt0aAAoJEECxmPOUX5FEAX4P/2DdC/UvJd9nK5fJcJGuTxD9
gsyJaC9MHAOQFRJvkhtqFjlhA02LmyOO0fx1AP4g5fz92r8KvB8nhVQtPHedxURw
B3jshvYxda8dk65tQ23CCr77yCjTRDBcDEZJNa69QH2Ocd/dzyCKYQbfSOVWYhAX
jzy3t33/8ySw2z2uuxHk5THVeB+IAFzE45mH5WTVWnoVrLs5defSFWMNpdevVjWW
SByf8MRPw9zNu08tFzbN5TDUkN0ORFxWRr1zCRRdzsY5a2FSgLLSTAeRmbC5+2Y4
iXn9Ot+r8yEWHSFGWqqU/BrlO4R93HUmmudDffgFMVOizplD2LQiNQr14kiIMjtc
1J+GnnrXi9SeK8sNJoRVpACZXpb7CrfDIA7RtWofZj/ISrBsF3tnq/Mo2koSxcyM
cqV/qBizPyY4hiKp4BOAS9ZHXAAEgP0PBdClVyiByv1JJfQrZr/LFChK+rTVlXd/
yTlWOPRopzJVLsc7NcEucdWYgg+T3IsQvmTbX2IIVzVtDhxfBpPp008MLoVQ2fgK
vxPmz9f+8YLXO1MJdYoXCQ4qHr7Rk+MOFmXkJOQ5aqI8epZZIU+/CXY5sOMbhwCp
6BkGATMR2ya4cEchouQNOowej8YWjRh+BelqSRAEK9caATDoddNquj2N73ltBwA8
DHqLeahqr23SzRzdVm3a
=9T0n
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Nov_2012_14_57_14_+1100_n7T8lL3qDkETQ_x5--
