Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab2H0Ivc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 04:51:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:10669 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752898Ab2H0Iva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 04:51:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,318,1344236400"; 
   d="asc'?scan'208";a="214355311"
Date: Mon, 27 Aug 2012 04:49:25 -0400
From: Chen Gong <gong.chen@linux.intel.com>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        PCI <linux-pci@vger.kernel.org>, Jiang Liu <liuj97@gmail.com>,
        Huang Ying <ying.huang@intel.com>, Hanjun Guo <guohanjun@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND BUGFIX PATCH 1/3] PCI/AER: fix pci_ops return NULL when
 hotplug a pci bus which was doing aer error inject
Message-ID: <20120827084924.GB3858@gchen.bj.intel.com>
Mail-Followup-To: Yijing Wang <wangyijing@huawei.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	PCI <linux-pci@vger.kernel.org>, Jiang Liu <liuj97@gmail.com>,
	Huang Ying <ying.huang@intel.com>,
	Hanjun Guo <guohanjun@huawei.com>, linux-kernel@vger.kernel.org
References: <1344685946-8172-1-git-send-email-wangyijing@huawei.com>
 <5038A210.4030005@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v9Ux+11Zm5mwPlX6"
Content-Disposition: inline
In-Reply-To: <5038A210.4030005@huawei.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--v9Ux+11Zm5mwPlX6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 25, 2012 at 05:59:44PM +0800, Yijing Wang wrote:
> Date:	Sat, 25 Aug 2012 17:59:44 +0800
> From: Yijing Wang <wangyijing@huawei.com>
> To: Bjorn Helgaas <bhelgaas@google.com>, Rusty Russell
>  <rusty@rustcorp.com.au>, Mauro Carvalho Chehab <mchehab@redhat.com>
> CC: PCI <linux-pci@vger.kernel.org>, Jiang Liu <liuj97@gmail.com>, Huang
>  Ying <ying.huang@intel.com>, Hanjun Guo <guohanjun@huawei.com>,
>  linux-kernel@vger.kernel.org
> Subject: [RESEND BUGFIX PATCH 1/3] PCI/AER: fix pci_ops return NULL when
>  hotplug a pci bus which was doing aer error inject
> User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:14.0) Gecko/20120713
>  Thunderbird/14.0
>=20
> When we inject aer errors to the target pci device by aer_inject module, =
the pci_ops of pci
> bus which the target device is on will be assign to pci_ops_aer.So if the=
 target pci device
> is a bridge, once we hotplug the pci bus(child bus) which the target devi=
ce bridges to, child
> bus's pci_ops will be assigned to pci_ops_aer too.Now every access to the=
 child bus's device
> will result to system panic, because it return NULL pci_ops in pci_read_a=
er.
> This patch fix this.
>=20
> CallTrace:
> bash[5908]: NaT consumption 17179869216 [1]
> Modules linked in: aer_inject cpufreq_conservative cpufreq_userspace cpuf=
req_pow
> ersave acpi_cpufreq binfmt_misc fuse nls_iso8859_1 loop ipmi_si(+) ipmi_d=
evintf
> ipmi_msghandler dm_mod ppdev iTCO_wdt iTCO_vendor_support sg igb parport_=
pc i2c_
> i801 mptctl i2c_core serio_raw hid_generic lpc_ich mfd_core parport butto=
n conta
> iner usbhid hid uhci_hcd ehci_hcd usbcore usb_common sd_mod crc_t10dif ex=
t3 mbca
> che jbd fan processor ide_pci_generic ide_core ata_piix libata mptsas mpt=
scsih m
> ptbase scsi_transport_sas scsi_mod thermal thermal_sys hwmon
>=20
[...]
>=20
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> Signed-off-by: Jiang Liu <liuj97@gmail.com>
> ---
>  drivers/pci/pcie/aer/aer_inject.c |   21 +++++++++++++++++++++
>  1 files changed, 21 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/pci/pcie/aer/aer_inject.c b/drivers/pci/pcie/aer/aer=
_inject.c
> index 5222986..fc28785 100644
> --- a/drivers/pci/pcie/aer/aer_inject.c
> +++ b/drivers/pci/pcie/aer/aer_inject.c
> @@ -109,6 +109,19 @@ static struct aer_error *__find_aer_error_by_dev(str=
uct pci_dev *dev)
>  	return __find_aer_error((u16)domain, dev->bus->number, dev->devfn);
>  }
>=20
> +static bool pci_is_upstream_bus(struct pci_bus *bus, struct pci_bus *up_=
bus)
> +{
> +	struct pci_bus *pbus =3D bus->parent;
> +
> +	while (pbus) {
> +		if (pbus =3D=3D up_bus)
> +			return true;
> +		pbus =3D pbus->parent;
> +	}
> +
> +	return false;
> +}
> +
>  /* inject_lock must be held before calling */
>  static struct pci_ops *__find_pci_bus_ops(struct pci_bus *bus)
>  {
> @@ -118,6 +131,13 @@ static struct pci_ops *__find_pci_bus_ops(struct pci=
_bus *bus)
>  		if (bus_ops->bus =3D=3D bus)
>  			return bus_ops->ops;
>  	}
> +
> +	/* here can't find bus_ops, fall back to get bus_ops of upstream bus */
> +	list_for_each_entry(bus_ops, &pci_bus_ops_list, list) {
> +		if (pci_is_upstream_bus(bus, bus_ops->bus))
> +			return bus_ops->ops;
> +	}
> +
>  	return NULL;
>  }
>=20
At least, when returning NULL, a proper check and protection is needed.


--v9Ux+11Zm5mwPlX6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQOzSUAAoJEI01n1+kOSLH6xoP/jDEP7vhCQNeWiZACgTzZfIZ
D500HSN10ADoBUn0aiL+mOhJcEGVzL04F2i52R+HBDDC9gwbtRXtZfDh+01o+tOl
SxJTLP1jn6zSE6OHqE/Fm3OJwm/Bh21AEGp0VTpu80ET6BjlwK3egIE9CwSE1C/0
J93ZY1WEPuckGchpRLlYSJebCHehsgVodIiCkb/YtWrr6tyq26lzWnb0PFO1bDmg
+MKfbWUglm4FZr6DCRmhKP/sSmO2MhcVzzC2Bt2FGNmMB7utARhK6uEybz+avEKI
SGzEwUWslA+oR2kkvnmGYtYuD3E1FTZNU4RhPmF6Kf/q84G0cNx2YLAdW5HkXLiB
VYPBOa68J78lS99huAGS9BhgwX2h3XIrvGpfgecZdItX0TDkrNE7i+FtjXN5SiBE
PjIVVuADZ9dnO6rkARXD9G1m+7FuodmLKEacW6bfJBal/yway13iItMicK9ZhxqP
09QSAjY9KF0SUmd570kIygAlLJaCRRkZWI49m6NklfkYgjK+Q6k+h5gJ+elmWbW6
sYnGomZN9lE0NjW8O9YCfsD+5zv+E6oajjMkjTeEW1qjWUkNYzHp7MV65Prc+tWy
SLw71rG3QW31EPusQJcEWO8Z1V6lV9w+ZuJm2KZK8IDFEnh50eedgt3z+PEXrDOA
b/+BcwVGC6b4Sxna0zkk
=APX6
-----END PGP SIGNATURE-----

--v9Ux+11Zm5mwPlX6--
