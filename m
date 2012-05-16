Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966948Ab2EPKHN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 06:07:13 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60999 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966706Ab2EPKHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 06:07:11 -0400
Date: Wed, 16 May 2012 20:06:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: linux-next: build failure after merge of the final tree (staging
 tree related)
Message-Id: <20120516200659.000314e53de07a7a7fda46b8@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__16_May_2012_20_06_59_+1000_kwYeBgqm1q=ZTAuG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__16_May_2012_20_06_59_+1000_kwYeBgqm1q=ZTAuG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/staging/zsmalloc/zsmalloc-main.c: In function 'zs_map_object':
drivers/staging/zsmalloc/zsmalloc-main.c:704:3: error: implicit declaration=
 of function 'set_pte' [-Werror=3Dimplicit-function-declaration]
drivers/staging/zsmalloc/zsmalloc-main.c: In function 'zs_unmap_object':
drivers/staging/zsmalloc/zsmalloc-main.c:738:3: error: implicit declaration=
 of function '__flush_tlb_one' [-Werror=3Dimplicit-function-declaration]

Presumably caused by commit 49b81a3c7415 ("ramster: switch over to
zsmalloc and crypto interface") which now has CONFIG_RAMSTER selecting
CONFIG_ZSMALLOC explicitly which in turn ignores the dependency of
CONFIG_ZSMALLOC on X86 ...

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__16_May_2012_20_06_59_+1000_kwYeBgqm1q=ZTAuG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPs3xDAAoJEECxmPOUX5FEybgQAIVQzjBq89+n8hKiLtmnOI0N
c5llkESn9XbT3rz3c6p6VnD4d080rOYa0hEkxU4W6w1u875pCgMujwu026naK9t5
DQTqsXgzC63byEhdGfGkT2ZqpEUMgYExjv/AGvDd1HMJlqUFUV7RD3aeLi53nIAJ
gJ6k2LqKIcg2tzNEp8SNVKw0aa5DC0YFdWL22xFuSZrEPVLUzOWoirrUo7GRap3j
KuAQaLUYEQGa/tGAMu5zPcDY3Do9RT9t/CsQ8BMAVbepASP4TTtp00RLbbN10+mc
/7k8+9HWIsxBsP0SlFXnGmssdKVDH7UtekfqqhzZnRdiUCOaqpF6Y1J6dkbG1nBO
Td0MByEFCkjtClew0Rzuwn3TacWIU3Ho896fPrVCjiks3rF1dRRcwlIz1BikVEjM
3UdpTIYudqUgJyBLNCA1b5y3bKT4TXSceG7mptjvM+AggeiJYKwF8UNi43c+DC1a
jayiJDjACtq1ix7efDVsH15rKRzdAuokgtbcXAVR8E+/MtP2ssIMsMO8CWe7S/SM
lYLmdN9T6XM5SavpO6FU9hUEkToqkdjid+HrFhNx9QMf5oxJ9tr5U2Xr+n46/K6I
phJnbPHhkDtrbJ3pKwohXKepW8QsdX6XkQviBpL7tCMwuKNblB0q8afWXTs+oias
aQpY3BMBwmX1j+MpBwtR
=mdy7
-----END PGP SIGNATURE-----

--Signature=_Wed__16_May_2012_20_06_59_+1000_kwYeBgqm1q=ZTAuG--
