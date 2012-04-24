Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab2DXEsn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 00:48:43 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41220 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab2DXEsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 00:48:40 -0400
Date: Tue, 24 Apr 2012 14:48:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        John Stultz <john.stultz@linaro.org>
Subject: linux-next: manual merge of the staging tree with the driver-core
 tree
Message-Id: <20120424144837.67a84b1e4e5905de7fd03e67@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__24_Apr_2012_14_48_37_+1000_ULsPxZ+28n6h_da+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__24_Apr_2012_14_48_37_+1000_ULsPxZ+28n6h_da+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got conflicts in
drivers/staging/android/Kconfig and drivers/staging/android/Makefile
between commit 449a2bf5e881 ("Remove "switch" class in
drivers/staging/android/switch") from the driver-core tree and commit
ef2353d26bdc ("android-alarm: Remove unused android alarm in-kernel
interfaces") from the staging tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/android/Kconfig
index c706635,84ac619..0000000
--- a/drivers/staging/android/Kconfig
+++ b/drivers/staging/android/Kconfig
@@@ -53,7 -52,9 +53,7 @@@ config ANDROID_LOW_MEMORY_KILLE
  	---help---
  	  Register processes to be killed when memory is low
 =20
- config ANDROID_INTF_ALARM
 -source "drivers/staging/android/switch/Kconfig"
 -
+ config ANDROID_INTF_ALARM_DEV
  	bool "Android alarm driver"
  	depends on RTC_CLASS
  	default n
diff --cc drivers/staging/android/Makefile
index 045d17b,b4be69f..0000000
--- a/drivers/staging/android/Makefile
+++ b/drivers/staging/android/Makefile
@@@ -6,5 -6,5 +6,4 @@@ obj-$(CONFIG_ANDROID_RAM_CONSOLE)	+=3D ra
  obj-$(CONFIG_ANDROID_TIMED_OUTPUT)	+=3D timed_output.o
  obj-$(CONFIG_ANDROID_TIMED_GPIO)	+=3D timed_gpio.o
  obj-$(CONFIG_ANDROID_LOW_MEMORY_KILLER)	+=3D lowmemorykiller.o
- obj-$(CONFIG_ANDROID_INTF_ALARM)	+=3D alarm.o
 -obj-$(CONFIG_ANDROID_SWITCH)		+=3D switch/
  obj-$(CONFIG_ANDROID_INTF_ALARM_DEV)	+=3D alarm-dev.o

--Signature=_Tue__24_Apr_2012_14_48_37_+1000_ULsPxZ+28n6h_da+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPljClAAoJEECxmPOUX5FEEpIP/1FWsWdUgu2RlJnHIos33MN2
4dowPTI6Q8yOKhl99hnlLEIH9SLPMCgFZ/ROrRPmcPz4iNYJvKwtH27zH/+vEQel
JzQT9DNAcXoGK4bInkIYZyrvvxzg8i4BGgqzCF5/fowHLFl2EVPTW4tODNOpMFf8
mF1gYxrcLAvKQ4+DRcyh4RRbGa+8as9JfbglAYGjco9YQa8EjsyTevGi1wG++kSJ
Elvyp8dqIFc9vsZwQLd24LJncji1kwo9WaKM8cArxtbufHrn83TxgkmDi+G/+Td5
1OGXrEVLlbk9t3Z1dLsu9oJ+8ZuLdCQtN+xGydjKbegV4tsV+fuLZOyHdIv1c7WX
7OScJ8XEd52BDvjYh4dA0zPPMnI82WOTAXkT+ipKHsI3U+A/y08zfwBpjiTzeJQW
5AQ93IonyAsytEVh120igS2rOWHdkCXnryujwsCRjPwW5dpXQ0ChsChfnRAbd23Z
Bl9PXomTr1Uk8+5fR0JLirr9wc90e1trKuGAt92VUL5I7ie1xdtBTJVpjbhog3xp
GSOz3zL8pE0os8ZRdp0WsL2XNCyazuen6sunS2zKXWULb/xXsfPT7wF2YdY7EO1y
W8W9VrzIa9ONmAqvc+E30PacyZ7CKloI0i+nA0k0VyNFpH296zlhIg6D05TH92r5
WKTsNEzME+U9utrvYprT
=2eOc
-----END PGP SIGNATURE-----

--Signature=_Tue__24_Apr_2012_14_48_37_+1000_ULsPxZ+28n6h_da+--
