Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab0IWKTn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 06:19:43 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53853 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481Ab0IWKTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 06:19:41 -0400
Date: Thu, 23 Sep 2010 20:19:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: matt mooney <mfm@muteddisk.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        kernel-janitors@vger.kernel.org, Alexander Graf <agraf@suse.de>,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Avi Kivity <avi@redhat.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 12/20] powerpc: change to new flag variables
Message-Id: <20100923201923.366779a1.sfr@canb.auug.org.au>
In-Reply-To: <1285224669-29865-1-git-send-email-mfm@muteddisk.com>
References: <1285224669-29865-1-git-send-email-mfm@muteddisk.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__23_Sep_2010_20_19_23_+1000_sx+5_UeLEINEpBFJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__23_Sep_2010_20_19_23_+1000_sx+5_UeLEINEpBFJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Matt,

On Wed, 22 Sep 2010 23:51:09 -0700 matt mooney <mfm@muteddisk.com> wrote:
>
> Replace EXTRA_CFLAGS with ccflags-y and EXTRA_AFLAGS with asflags-y.

This looks good.  One comment below ...

> --- a/arch/powerpc/platforms/pseries/Makefile
> +++ b/arch/powerpc/platforms/pseries/Makefile
> @@ -1,10 +1,5 @@
> -ifeq ($(CONFIG_PPC64),y)
> -EXTRA_CFLAGS		+=3D -mno-minimal-toc
> -endif
> -
> -ifeq ($(CONFIG_PPC_PSERIES_DEBUG),y)
> -EXTRA_CFLAGS		+=3D -DDEBUG
> -endif
> +ccflags-$(CONFIG_PPC64)			:=3D -mno-minimal-toc
> +ccflags-$(CONFIG_PPC_PSERIES_DEBUG)	+=3D -DDEBUG
> =20
>  obj-y			:=3D lpar.o hvCall.o nvram.o reconfig.o \
>  			   setup.o iommu.o event_sources.o ras.o \
> @@ -23,7 +18,7 @@ obj-$(CONFIG_MEMORY_HOTPLUG)	+=3D hotplug-memory.o
>  obj-$(CONFIG_HVC_CONSOLE)	+=3D hvconsole.o
>  obj-$(CONFIG_HVCS)		+=3D hvcserver.o
>  obj-$(CONFIG_HCALL_STATS)	+=3D hvCall_inst.o
> -obj-$(CONFIG_PHYP_DUMP)	+=3D phyp_dump.o
> +obj-$(CONFIG_PHYP_DUMP)		+=3D phyp_dump.o
>  obj-$(CONFIG_CMM)		+=3D cmm.o
>  obj-$(CONFIG_DTL)		+=3D dtl.o

This looks like a spurious extra hunk.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__23_Sep_2010_20_19_23_+1000_sx+5_UeLEINEpBFJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMmymrAAoJEDMEi1NhKgbs3pEIAKIWVwdyxN2glmFn2xoe5p0z
pX4OLcx1oFXurmzdbbnjbVH3BDNPhapfoHs3B2iKr+szw0G1hfFDpX5s5ZC2dSEj
w2IhV0gSl27nt2f2HdxbNxSElOTsr/Nb32MVaJBXXoOlrSWb4NVxRCA+VgrJ+dt0
1HbP94xWUIZDrOdojkQScH7SPgjkfMbtAQJfxjLfwAaFPcs9Zpawq3np4VZfGduP
8kCAWZ+aTt+FWfGcW0sM4JeB5mwnrozlHR3SZD6YDRxFob/0HsqJXNkmHaudv+kQ
yKs3sFz4HO3zol75i1yajDDl8GsrPlNQ0GIC2WGxTxSUJ4hJDpMtJmoF12/z1mE=
=uQp9
-----END PGP SIGNATURE-----

--Signature=_Thu__23_Sep_2010_20_19_23_+1000_sx+5_UeLEINEpBFJ--
