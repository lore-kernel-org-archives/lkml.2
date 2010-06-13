Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab0FMUa2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 16:30:28 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58705 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612Ab0FMUa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 16:30:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=fGGfiJc7dWUjtuKLaEzxTMelOpNME8DctbOq0OLq/RU6JqAD6WKmUSDXqZofRvMxFO
         2CMUCGmiTmjKICjHhN9AVw4vz0AnWRaOJwx+IwfOZyd6+9N7KMCIJ+g9yVOnJD13zJk2
         R4noK593A2XLnKg7Mvv293+fp08jMx0iltLdk=
Date: Sun, 13 Jun 2010 23:33:52 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: BUG: using smp_processor_id() in preemptible code: s2disk
Message-ID: <20100613203352.GA3577@swordfish>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

.35-rc3, x86

Hit the following error today:

kernel: [   94.817525] CPU1: Thermal monitoring handled by SMI
kernel: [   94.951454] BUG: using smp_processor_id() in preemptible [00000000] code: s2disk/3392
kernel: [   94.951462] caller is nr_iowait_cpu+0xe/0x1e
kernel: [   94.951466] Pid: 3392, comm: s2disk Not tainted 2.6.35-rc3-dbg-00106-ga75e02b #2
kernel: [   94.951469] Call Trace:
kernel: [   94.951478]  [<c1184c55>] debug_smp_processor_id+0xa5/0xbc
kernel: [   94.951484]  [<c10282a5>] nr_iowait_cpu+0xe/0x1e
kernel: [   94.951489]  [<c104ab7c>] update_ts_time_stats+0x32/0x6c
kernel: [   94.951494]  [<c104ac73>] get_cpu_idle_time_us+0x36/0x58
kernel: [   94.951500]  [<c124229b>] get_cpu_idle_time+0x12/0x74
kernel: [   94.951505]  [<c1242963>] cpufreq_governor_dbs+0xc3/0x2dc
kernel: [   94.951511]  [<c1240437>] __cpufreq_governor+0x51/0x85
kernel: [   94.951515]  [<c1241190>] __cpufreq_set_policy+0x10c/0x13d
kernel: [   94.951520]  [<c12413d3>] cpufreq_add_dev_interface+0x212/0x233
kernel: [   94.951526]  [<c1241b1e>] ? handle_update+0x0/0xd
kernel: [   94.951533]  [<c1241a18>] cpufreq_add_dev+0x34b/0x35a
kernel: [   94.951538]  [<c103c973>] ? schedule_delayed_work_on+0x11/0x13
kernel: [   94.951544]  [<c12c14db>] cpufreq_cpu_callback+0x59/0x63
kernel: [   94.951550]  [<c1042f39>] notifier_call_chain+0x26/0x48
kernel: [   94.951555]  [<c1042f7d>] __raw_notifier_call_chain+0xe/0x10
kernel: [   94.951560]  [<c102efb9>] __cpu_notify+0x15/0x29
kernel: [   94.951564]  [<c102efda>] cpu_notify+0xd/0xf
kernel: [   94.951568]  [<c12bfb30>] _cpu_up+0xaf/0xd2
kernel: [   94.951574]  [<c12b3ad4>] enable_nonboot_cpus+0x3d/0x94
kernel: [   94.951580]  [<c1055eef>] hibernation_snapshot+0x104/0x1a2
kernel: [   94.951585]  [<c1058b49>] snapshot_ioctl+0x24b/0x53e
kernel: [   94.951589]  [<c1028ad1>] ? sub_preempt_count+0x7c/0x89
kernel: [   94.951595]  [<c10ab91d>] vfs_ioctl+0x2e/0x8c
kernel: [   94.951599]  [<c10588fe>] ? snapshot_ioctl+0x0/0x53e
kernel: [   94.951604]  [<c10ac2c7>] do_vfs_ioctl+0x42f/0x45a
kernel: [   94.951609]  [<c10a0ba5>] ? fsnotify_modify+0x4f/0x5a
kernel: [   94.951615]  [<c11e9dc3>] ? tty_write+0x0/0x1d0
kernel: [   94.951619]  [<c10a12d6>] ? vfs_write+0xa2/0xda
kernel: [   94.951623]  [<c10ac333>] sys_ioctl+0x41/0x62
kernel: [   94.951629]  [<c10027d3>] sysenter_do_call+0x12/0x2d
kernel: [   94.954195] CPU1 is up
kernel: [   94.954862] ACPI: Waking up from system sleep state S4


	Sergey

--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkwVQLAACgkQfKHnntdSXjRQeAQAjMf4Ffq1X1ghBJPQSoeSZXWt
/l+JoXcDow1wFMn6pa8G8248h8HWcg2A21WmKdd6iQUko0FE7JvyHsACFP4Atxdg
oaAXS/4Kxk9eQeVN2m5IeRE2Ty7fYyfQ8CP9LfxPyzTCFlw6ScTduSWAavLx3C5h
TZqGONiiWDpLzfGmWGg=
=ia5c
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--
