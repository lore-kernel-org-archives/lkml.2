Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab3AHDCQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 22:02:16 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:33097 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057Ab3AHDCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 22:02:14 -0500
Date: Tue, 8 Jan 2013 14:01:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: James Morris <jmorris@namei.org>,
        LSM <linux-security-module@vger.kernel.org>,
        LKLM <linux-kernel@vger.kernel.org>, SE Linux <selinux@tycho.nsa.gov>,
        John Johansen <john.johansen@canonical.com>,
        Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v12 0/9] LSM: Multiple concurrent LSMs
Message-Id: <20130108140159.83c07fa6a680e355f024970f@canb.auug.org.au>
In-Reply-To: <50EB7C50.3070605@schaufler-ca.com>
References: <50EB7C50.3070605@schaufler-ca.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__8_Jan_2013_14_01_59_+1100_n/JjKLTVP1o=F9dS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__8_Jan_2013_14_01_59_+1100_n/JjKLTVP1o=F9dS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Casey,

On Mon, 07 Jan 2013 17:54:24 -0800 Casey Schaufler <casey@schaufler-ca.com>=
 wrote:
>
> Subject: [PATCH v12 0/9] LSM: Multiple concurrent LSMs
>=20
> Change the infrastructure for Linux Security Modules (LSM)s
> from a single vector of hook handlers to a list based method
> for handling multiple concurrent modules.=20
>=20
> A level of indirection has been introduced in the handling of
> security blobs. LSMs no longer access ->security fields directly,
> instead they use an abstraction provided by lsm_[gs]et field
> functions.=20
>=20
> The XFRM hooks are only used by SELinux and it is not clear
> that they can be shared. The First LSM that registers using
> those hooks gets to use them. Any subsequent LSM that uses
> those hooks is denied registration.=20
>=20
> Secids have not been made shareable. Only one LSM that uses
> secids (SELinux and Smack) can be used at a time. The first
> to register wins.
>=20
> The "security=3D" boot option takes a comma separated list of
> LSMs, registering them in the order presented. The LSM hooks
> will be executed in the order registered. Hooks that return
> errors are not short circuited. All hooks are called even
> if one of the LSM hooks fails. The result returned will be
> that of the last LSM hook that failed.
>=20
> Some hooks don't fit that model. setprocattr, getprocattr,
> and a few others are special cased. All behavior from
> security/capability.c has been moved into the hook handling.
> The security/commoncap functions used to get called from
> the LSM specific code. The handling of the capability
> functions has been moved out of the LSMs and into the
> hook handling.
>=20
> The /proc/*/attr interfaces are given to one LSM. This
> can be done by setting CONFIG_SECURITY_PRESENT. Additional
> interfaces have been created in /proc/*/attr so that
> each LSM has its own named interfaces.
>=20
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

Let me ask Andrew's question:  Why do you want to do this (what is the
use case)?  What does this gain us?

Also, you should use unique subjects for each of the patches in the
series.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__8_Jan_2013_14_01_59_+1100_n/JjKLTVP1o=F9dS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ64wnAAoJEECxmPOUX5FEt8EP/2oUttEX3DYPGXD9xW6WdAJ2
H42CtYaOv2zwlu0/8rVD/DVY0OZy1wN27s5lkyt9NsRFjynPJ3w51AUU29yL4zWY
Bx6IQk7TQKC3B+QIUThxTKsiA3vCFQgbHmfNHNV16UELOu90yW8HNUpBw4Wxjtt7
90HBfLKAQQ9i/3In/3mW9Hz5kRtmNqPq9myUMFFUVeuFMHBRhcmqjQ2HVrW1qhzK
+cYY/ST1QJFI0j9y1G1R8RQyxFdwAhSlLwbKhpTfCNiB9BIK+r3Gkb+d0t8xtGoP
NjRHjYcUl1jLNuv6/vp8qpK8AKxYrRueK3YAxSpwGRV3t6ItEMwX+b5JvcClAPLp
kjhczpb9SW0FJZZGsUVAqTF3EJO9chBm+banuoF7B0AzdeHkOwANyG8hlInU2xnu
pgHzxaWBr8MiKRy5XZY6muSAAASCqc/n1CW2f1Ax/HHNU59z2l6rgyi2w+9VJJVv
9WsbIp5pgguz0ZAlKM8PWtTe+I07w0kOP584gqyBlhrjJolqTmIQ1V23pTGp/pVE
5osioWiTdEf/6Of4H6v566BQGinqwtaw1W16K4GZxRPcnSOMvJMCBLaIfiNvByd+
uk7UzjrzvaPYemop1aLSEH6uk1X/4SRpN7jxyZuGUeDtCPt3v0swJAEHMNQuhZgi
NB5tn3hbn4riniRuJy3U
=/Pji
-----END PGP SIGNATURE-----

--Signature=_Tue__8_Jan_2013_14_01_59_+1100_n/JjKLTVP1o=F9dS--
