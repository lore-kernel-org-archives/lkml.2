Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367Ab0FOTEs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 15:04:48 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47076 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189Ab0FOTEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 15:04:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type;
        b=nAfqjdhMwL9JxkQlCoXDFcJ8sAwJ8pBH8xKl6NxcU4RGhTYKmhAnPqD3U1lgZGXgHY
         JWh3llAXwigC7RMw1313X5i8yC4qy/Sx6J9+yMDIkdr0fAwaxbRPMBgL+BBUwUofEiKi
         fTX+9eaV2WAhcKt4eBfAdD6b3WAE4mBnHsEcc=
Date: Tue, 15 Jun 2010 22:04:42 +0300
From: Sergei Trofimovich <slyich@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: v2.6.35-rc3: BUG: using smp_processor_id() in preemptible
 [00000000] code: modprobe/1255
Message-ID: <20100615220442.55b5271e@mosly>
In-Reply-To: <20100613124246.07f98bd7@mosly>
References: <20100613124246.07f98bd7@mosly>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/g7vE4KQg3iVTwSoL_Xbol89"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/g7vE4KQg3iVTwSoL_Xbol89
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

> [    7.582027] BUG: using smp_processor_id() in preemptible [00000000] co=
de: modprobe/1255
> [    7.582038] caller is nr_iowait_cpu+0x15/0x2b
> [    7.582044] Pid: 1255, comm: modprobe Not tainted 2.6.35-rc3 #87
> [    7.582048] Call Trace:
> [    7.582059]  [<ffffffff81185470>] debug_smp_processor_id+0xc4/0xe0
> [    7.582067]  [<ffffffff810265cd>] nr_iowait_cpu+0x15/0x2b
> [    7.582075]  [<ffffffff81053b78>] update_ts_time_stats+0x37/0x72
> [    7.582083]  [<ffffffff8104f5b5>] ? ktime_get+0x60/0xb9
> [    7.582089]  [<ffffffff81053d2d>] get_cpu_idle_time_us+0x44/0x63
> [    7.582100]  [<ffffffff8126f516>] cpufreq_governor_dbs+0xe1/0x3cf
> [    7.582109]  [<ffffffff8104bb5e>] ? notifier_call_chain+0x32/0x5e
> [    7.582116]  [<ffffffff8126c87e>] __cpufreq_governor+0xc7/0x105
> [    7.582124]  [<ffffffff8126d66c>] __cpufreq_set_policy+0x1a8/0x222
> [    7.582131]  [<ffffffff8126d977>] cpufreq_add_dev_interface+0x291/0x2ac
> [    7.582139]  [<ffffffff8126e22e>] ? handle_update+0x0/0x33
> [    7.582147]  [<ffffffff8126e107>] cpufreq_add_dev+0x4b9/0x4c9
> [    7.582157]  [<ffffffff811ff373>] sysdev_driver_register+0xbf/0x119
> [    7.582164]  [<ffffffff8126c9a8>] cpufreq_register_driver+0xb9/0x1a5
> [    7.582174]  [<ffffffffa02e40d7>] acpi_cpufreq_init+0xd7/0x10d [acpi_c=
pufreq]
> [    7.582183]  [<ffffffffa02e4000>] ? acpi_cpufreq_init+0x0/0x10d [acpi_=
cpufreq]
> [    7.582191]  [<ffffffff810001ef>] do_one_initcall+0x59/0x149
> [    7.582199]  [<ffffffff8105cced>] sys_init_module+0x9c/0x1db
> [    7.582206]  [<ffffffff81001eeb>] system_call_fastpath+0x16/0x1b
>=20
> Attached whole config and dmesg.

It seems to be reproducible on each boot. Today's one:
[   20.242755] BUG: using smp_processor_id() in preemptible [00000000] code=
: modprobe/1462
[   20.242765] caller is nr_iowait_cpu+0x15/0x2b
[   20.242770] Pid: 1462, comm: modprobe Not tainted 2.6.35-rc3 #87
[   20.242774] Call Trace:
[   20.242784]  [<ffffffff81185470>] debug_smp_processor_id+0xc4/0xe0
[   20.242790]  [<ffffffff810265cd>] nr_iowait_cpu+0x15/0x2b
[   20.242798]  [<ffffffff81053b78>] update_ts_time_stats+0x37/0x72
[   20.242805]  [<ffffffff8104f5b5>] ? ktime_get+0x60/0xb9
[   20.242811]  [<ffffffff81053d2d>] get_cpu_idle_time_us+0x44/0x63
[   20.242820]  [<ffffffff8126f516>] cpufreq_governor_dbs+0xe1/0x3cf
[   20.242828]  [<ffffffff8104bb5e>] ? notifier_call_chain+0x32/0x5e
[   20.242835]  [<ffffffff8126c87e>] __cpufreq_governor+0xc7/0x105
[   20.242842]  [<ffffffff8126d66c>] __cpufreq_set_policy+0x1a8/0x222
[   20.242848]  [<ffffffff8126d977>] cpufreq_add_dev_interface+0x291/0x2ac
[   20.242855]  [<ffffffff8126e22e>] ? handle_update+0x0/0x33
[   20.242863]  [<ffffffff8126e107>] cpufreq_add_dev+0x4b9/0x4c9
[   20.242871]  [<ffffffff811ff373>] sysdev_driver_register+0xbf/0x119
[   20.242878]  [<ffffffff8126c9a8>] cpufreq_register_driver+0xb9/0x1a5
[   20.242887]  [<ffffffffa02e40d7>] acpi_cpufreq_init+0xd7/0x10d [acpi_cpu=
freq]
[   20.242894]  [<ffffffffa02e4000>] ? acpi_cpufreq_init+0x0/0x10d [acpi_cp=
ufreq]
[   20.242902]  [<ffffffff810001ef>] do_one_initcall+0x59/0x149
[   20.242909]  [<ffffffff8105cced>] sys_init_module+0x9c/0x1db
[   20.242915]  [<ffffffff81001eeb>] system_call_fastpath+0x16/0x1b

--=20

  Sergei

--Sig_/g7vE4KQg3iVTwSoL_Xbol89
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEARECAAYFAkwXzsoACgkQcaHudmEf86qX6ACfc2u4TFkIi5n5jhG5bCXj+s8u
cPQAnRwDZKB3s4v6tH/vY8Zk9rowxl7g
=toS5
-----END PGP SIGNATURE-----

--Sig_/g7vE4KQg3iVTwSoL_Xbol89--
