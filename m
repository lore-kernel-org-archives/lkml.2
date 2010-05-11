Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000Ab0EKVqF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 17:46:05 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:36475 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860Ab0EKVqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 17:46:01 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Huaxu Wan <huaxu.wan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       huaxu.wan@intel.com, Carsten Emde <Carsten.Emde@osadl.org>
Subject: Re: [PATCH 1/2 V3] hwmon: (coretemp) Detect the thermal sensors by CPUID
In-Reply-To: Your message of "Tue, 11 May 2010 16:01:12 +0800."
             <20100511080112.GB19762@owl>
From: Valdis.Kletnieks@vt.edu
References: <20100507095459.GA12190@owl> <20100510033525.GC9181@owl>
            <20100511080112.GB19762@owl>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1273614319_4002P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 11 May 2010 17:45:19 -0400
Message-ID: <31726.1273614319@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020202.4BE9CFF0.01EF,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1273614319_4002P
Content-Type: text/plain; charset=us-ascii

On Tue, 11 May 2010 16:01:12 +0800, Huaxu Wan said:
> The thermal sensors of Intel(R) CPUs can be detected by CPUID instruction,
> indicated by CPUID.06H.EAX[0].
> 
> Signed-off-by: Huaxu Wan <huaxu.wan@linux.intel.com>
> Signed-off-by: Carsten Emde <C.Emde@osadl.org>
> ---
>  drivers/hwmon/coretemp.c |   34 +++++++++++++---------------------
>  1 files changed, 13 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
> index e9b7fbc..be0ddcf 100644
> --- a/drivers/hwmon/coretemp.c
> +++ b/drivers/hwmon/coretemp.c
> @@ -451,28 +451,20 @@ static int __init coretemp_init(void)
> 
>         for_each_online_cpu(i) {
>                 struct cpuinfo_x86 *c = &cpu_data(i);
> +               /*
> +                * CPUID.06H.EAX[0] indicates whether the CPU has thermal
> +                * sensors. We check this bit only, all the early CPUs
> +                * without thermal sensors will be filtered out.
> +                */
> +               if (c->cpuid_level >= 6 && (cpuid_eax(0x06) & 0x01)) {
> +                       err = coretemp_device_add(i);
> +                       if (err)
> +                               goto exit_devices_unreg;

OK, that looks sane. :)  For what it's worth, feel free to stick on a

Reviewed-By: Valdis Kletnieks <valdis.kletnieks@vt.edu>

--==_Exmh_1273614319_4002P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFL6c/vcC3lWbTT17ARAuBfAJ4plHpopKHZq+yHrj5jGUlyfp1tYgCfcVPw
lUkc3KUlaFp0+ACO9iAyEg4=
=vaAT
-----END PGP SIGNATURE-----

--==_Exmh_1273614319_4002P--

