Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab1L1E5W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 23:57:22 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:38836 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279Ab1L1E5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 23:57:20 -0500
Date: Wed, 28 Dec 2011 15:57:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: linux-next: manual merge of the driver-core tree with the tip tree
Message-Id: <20111228155707.f4554d3d6b624189e4216aed@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__28_Dec_2011_15_57_07_+1100_g06U9F01McEfOIj1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Dec_2011_15_57_07_+1100_g06U9F01McEfOIj1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
include/linux/cpu.h between commit 2987557f52b9 ("driver-core/cpu: Expose
hotpluggability to the rest of the kernel") from the tip tree and commit
8a25a2fd126c ("cpu: convert 'cpu' and 'machinecheck' sysdev_class to a
regular subsystem") from the driver-core tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/cpu.h
index 305c263,fc3da0d..0000000
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@@ -26,16 -26,15 +26,16 @@@ struct cpu=20
  };
 =20
  extern int register_cpu(struct cpu *cpu, int num);
- extern struct sys_device *get_cpu_sysdev(unsigned cpu);
+ extern struct device *get_cpu_device(unsigned cpu);
 +extern bool cpu_is_hotpluggable(unsigned cpu);
 =20
- extern int cpu_add_sysdev_attr(struct sysdev_attribute *attr);
- extern void cpu_remove_sysdev_attr(struct sysdev_attribute *attr);
+ extern int cpu_add_dev_attr(struct device_attribute *attr);
+ extern void cpu_remove_dev_attr(struct device_attribute *attr);
 =20
- extern int cpu_add_sysdev_attr_group(struct attribute_group *attrs);
- extern void cpu_remove_sysdev_attr_group(struct attribute_group *attrs);
+ extern int cpu_add_dev_attr_group(struct attribute_group *attrs);
+ extern void cpu_remove_dev_attr_group(struct attribute_group *attrs);
 =20
- extern int sched_create_sysfs_power_savings_entries(struct sysdev_class *=
cls);
+ extern int sched_create_sysfs_power_savings_entries(struct device *dev);
 =20
  #ifdef CONFIG_HOTPLUG_CPU
  extern void unregister_cpu(struct cpu *cpu);

--Signature=_Wed__28_Dec_2011_15_57_07_+1100_g06U9F01McEfOIj1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO+qGjAAoJEECxmPOUX5FEn4sQAKbatvQ7xRx7jH7W/9RR0zsv
1WTuL1//YeLDjXTHi0Axfe0Wqy+yC19kHvKhmESkcLseF3Wc5Uojyy8m6bvUbUIZ
Fdew9C7pRvaTLv4EOd6seWxknpN9IuNKbxxVXSMXxrMDW/hs2pt1e/E3T1fi0uNS
DAqK4lUnKrzpmw4l8RZ/Fi9BDcxAj1/zBVHt7DOlTdEfe5q/WGx4Rksqy2Mvt5M8
cNMkvyA8YsrCwXXgBqkvEwQP5fo6uGh2iDv2a8z//EqNLyLhj54kkJyhDNhI+mu7
nb+CEaJrrDnklaJGsaC4w7f7JG7Yebvs8t4prxr75+Ot/j9TgbNzr4jyIo+hyGkU
Azcq8BCTk464CHSMmpFnpI5rUznjQrfYwJY0y8XDMvojLQGv3OwBtCbjzpHfZZ+9
vjVHARDCvKv+vDPVXRBsRpQra/h6PoPjwdqljmEshUQ9lcALSK0+/QKsTSc5SgJG
+Y/obYfgalx64bogLSQtm3ikYDwGveVaNcF90VocljIcKlHh8IKm2p6Z9BSlXgM5
0vfXOPmXMgFWIDrD8n0/JDqLuVzGYODHEusrBvqrjFQLoaw6KUT+KnTPDmiUuDT0
IhWRdPDguK8K1Quvx4pybwBfnmXf4MMFQKB2Iru7jPi8FtubTCtxWhGxY9PqZ0Aj
/5hghTubFMNUlByN8AYq
=hf8g
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Dec_2011_15_57_07_+1100_g06U9F01McEfOIj1--
