Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933254Ab2K0EbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 23:31:19 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:49479 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878Ab2K0EbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 23:31:17 -0500
Date: Tue, 27 Nov 2012 15:31:06 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Bhavna Yadav <bhavna.yadav@st.com>, Deepak Sikri <deepak.sikri@st.com>,
        Rajeev Kumar <rajeev-dlh.kumar@st.com>,
        Vijay Kumar Mishra <vijay.kumar@st.com>,
        Vipin Kumar <vipin.kumar@st.com>,
        Vipul Kumar Samar <vipulkumar.samar@st.com>
Subject: linux-next: manual merge of the arm-soc tree with the slave-dma
 tree
Message-Id: <20121127153106.6e2a6c4bc100bcd4a1306740@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__27_Nov_2012_15_31_06_+1100_K+WrY+NQ221S7=rH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Nov_2012_15_31_06_+1100_K+WrY+NQ221S7=rH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/boot/dts/spear1340.dtsi between commit b47394911c26 ("ARM:
SPEAr13xx: Pass DW DMAC platform data from DT") from the slave-dma tree
and commit 8113ba917dfa ("ARM: SPEAr: DT: Update device nodes") from the
arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/boot/dts/spear1340.dtsi
index d487556,34da11a..0000000
--- a/arch/arm/boot/dts/spear1340.dtsi
+++ b/arch/arm/boot/dts/spear1340.dtsi
@@@ -24,25 -38,28 +38,47 @@@
  			status =3D "disabled";
  		};
 =20
 +		dma@ea800000 {
 +			slave_info {
 +				uart1_tx {
 +					bus_id =3D "uart1_tx";
 +					cfg_hi =3D <0x6000>;	/* 0xC << 11 */
 +					cfg_lo =3D <0>;
 +					src_master =3D <0>;
 +					dst_master =3D <1>;
 +				};
 +				uart1_tx {
 +					bus_id =3D "uart1_tx";
 +					cfg_hi =3D <0x680>;	/* 0xD << 7 */
 +					cfg_lo =3D <0>;
 +					src_master =3D <1>;
 +					dst_master =3D <0>;
 +				};
 +			};
 +		};
 +
+ 		i2s-play@b2400000 {
+ 			compatible =3D "snps,designware-i2s";
+ 			reg =3D <0xb2400000 0x10000>;
+ 			interrupt-names =3D "play_irq";
+ 			interrupts =3D <0 98 0x4
+ 				      0 99 0x4>;
+ 			play;
+ 			channel =3D <8>;
+ 			status =3D "disabled";
+ 		};
+=20
+ 		i2s-rec@b2000000 {
+ 			compatible =3D "snps,designware-i2s";
+ 			reg =3D <0xb2000000 0x10000>;
+ 			interrupt-names =3D "record_irq";
+ 			interrupts =3D <0 100  0x4
+ 				      0 101 0x4>;
+ 			record;
+ 			channel =3D <8>;
+ 			status =3D "disabled";
+ 		};
+=20
  		pinmux: pinmux@e0700000 {
  			compatible =3D "st,spear1340-pinmux";
  			reg =3D <0xe0700000 0x1000>;

--Signature=_Tue__27_Nov_2012_15_31_06_+1100_K+WrY+NQ221S7=rH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQtEIKAAoJEECxmPOUX5FEo/AQAJBpZJngfvf/K7hY4mfWdbMO
UFIcYncfC7Y7byw9W079vlK8s5FCRRLJ4XVznJiVWD6V/yCcrp2PfHKJDVxqPJoT
ktt0RtZal4qKC17EP+L6DTG/qv1+k+6De5jnvMVyMFqDRBlgsB5Ec5H6ZANnyP3l
qWpwthQ1DqT43IPMmbg7JlGUx63djQFkNddkHXKTRhE3F4x6hvK/iTdlcodGt0+f
kD4ZFJCdYVKeCpuw2qwq1mNs5O9L58dDMHpRYoeHTSmofVDDks0TopretUY2z5c6
BbKbogU28KHWPRY1bfAJ3eZ3Z/AfrtCadDv7BrIb5Ih5g8lgehAbCgPcmqchOn7U
iv5Pf5BulVatX9TDnG7X4A/yASxneLUfi1CPW7+lJmdS17HS2d6uthpUIn91TD2s
rJPrJErjliPKXsYpx+MKdepdRQZl/OHP5XvFLTsgTZObBBi3K8zaz00+lIrd6sl7
yI13oMrnP+GR+JS9TX4lHWy7vW0TaVvTvh8haRrbk9xyL79r0v+ujIWEg9uyX1ls
tJNLY9Wh6I6NkexfK26qJCChpq8VlQvS6zv9o7taN2gu7S2bp+OxP2YLwmWqZHv7
cy0C2uJXReSp/3HvGmz2vFmcChXnU8/6bOm4xkB31d9tpuQG4ZKK/vkUbAXFScnE
v5ETghvOWZLJ8jX+NSQy
=hVCj
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Nov_2012_15_31_06_+1100_K+WrY+NQ221S7=rH--
