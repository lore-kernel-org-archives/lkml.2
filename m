Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab1CWBPJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 21:15:09 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54494 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752660Ab1CWBPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 21:15:06 -0400
Date: Wed, 23 Mar 2011 12:14:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Cc: arjan@linux.intel.com, peterz@infradead.org, lenb@kernel.org,
        suresh.b.siddha@intel.com, benh@kernel.crashing.org, venki@google.com,
        ak@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH V4 5/5] cpuidle: cpuidle driver for apm
Message-Id: <20110323121458.ec7cdaf9.sfr@canb.auug.org.au>
In-Reply-To: <20110322123336.28725.29810.stgit@tringupt.in.ibm.com>
References: <20110322123208.28725.30945.stgit@tringupt.in.ibm.com>
	<20110322123336.28725.29810.stgit@tringupt.in.ibm.com>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__23_Mar_2011_12_14_58_+1100__+rdUlcY+DXTi+Op"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_Mar_2011_12_14_58_+1100__+rdUlcY+DXTi+Op
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, 22 Mar 2011 18:03:40 +0530 Trinabh Gupta <trinabh@linux.vnet.ibm.co=
m> wrote:
>
> +static int apm_setup_cpuidle(int cpu)
> +{
> +	struct cpuidle_device *dev =3D kzalloc(sizeof(struct cpuidle_device),
> +					GFP_KERNEL);

Same as xen comments: no NULL check.

> +	int count =3D CPUIDLE_DRIVER_STATE_START;
> +	dev->cpu =3D cpu;
> +	dev->drv =3D &apm_idle_driver;

Also wondering why you would ever have a different idle routine on
different cpus?

> +
> +	dev->states[count] =3D state_apm_idle;
> +	count++;
> +
> +	dev->state_count =3D count;
> +
> +	if (cpuidle_register_device(dev))
> +		return -EIO;

And we leak dev.

> +static void apm_idle_exit(void)
> +{
> +	cpuidle_unregister_driver(&apm_idle_driver);

Do we leak the per cpu device structure here?

> +	return;

Unnecessary return statement.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__23_Mar_2011_12_14_58_+1100__+rdUlcY+DXTi+Op
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNiUmSAAoJEDMEi1NhKgbs9iQH/1zTzYvuM36C7wzTgUpGdqxo
SdkdPUh7Q1w7l6qjz/LpXH7ndaw7i1VJGoPr1/sdFpw6do4MtnN1D2bEEaL1w73i
tl16pEHq5ni0R9hFUXBvDQ3Dxa/U5/1wNLmiEsBgM3shTsGvjevdHbfhh0rOdAM9
AH+P0CutCUjJTGyY83sCyxfyaxJt14U1vYYsJsS91JoCGk/1tFwCT5SLnRZ6NWQb
UMBVpovPz+tXbaS7hYl/kNXG7zKcSki+wH66Ly1Q6SjQ618jINR79xU34HAfy1wG
OnvFPozpEjmpR3VloRsFw3jJ3L9FkZqrMNnkWbtaZYLQX5aUpI07B8XNSL2oQaM=
=8G0A
-----END PGP SIGNATURE-----

--Signature=_Wed__23_Mar_2011_12_14_58_+1100__+rdUlcY+DXTi+Op--
