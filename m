Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135Ab2FTHuZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 03:50:25 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:50736 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978Ab2FTHuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 03:50:23 -0400
Date: Wed, 20 Jun 2012 17:50:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: linux-next: build failure after merge of the final tree (powerpc
 related)
Message-Id: <20120620175014.a822a766e0f91f7b44f48fa0@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta8 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__20_Jun_2012_17_50_14_+1000_267of1xduDZ4C/IM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__20_Jun_2012_17_50_14_+1000_267of1xduDZ4C/IM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

powerpc64-linux-ld: arch/powerpc/net/built-in.o: In function `bpf_slow_path=
_word':
(.text+0x90): sibling call optimization to `skb_copy_bits' does not allow a=
utomatic multiple TOCs; recompile with -mminimal-toc or -fno-optimize-sibli=
ng-calls, or make `skb_copy_bits' extern
powerpc64-linux-ld: arch/powerpc/net/built-in.o: In function `bpf_slow_path=
_half':
(.text+0xe0): sibling call optimization to `skb_copy_bits' does not allow a=
utomatic multiple TOCs; recompile with -mminimal-toc or -fno-optimize-sibli=
ng-calls, or make `skb_copy_bits' extern
powerpc64-linux-ld: arch/powerpc/net/built-in.o: In function `bpf_slow_path=
_byte':
(.text+0x130): sibling call optimization to `skb_copy_bits' does not allow =
automatic multiple TOCs; recompile with -mminimal-toc or -fno-optimize-sibl=
ing-calls, or make `skb_copy_bits' extern
powerpc64-linux-ld: arch/powerpc/net/built-in.o: In function `bpf_slow_path=
_byte_msh':
(.text+0x180): sibling call optimization to `skb_copy_bits' does not allow =
automatic multiple TOCs; recompile with -mminimal-toc or -fno-optimize-sibl=
ing-calls, or make `skb_copy_bits' extern
powerpc64-linux-ld: arch/powerpc/net/built-in.o: In function `sk_load_word_=
negative_offset':
(.text+0x1dc): sibling call optimization to `bpf_internal_load_pointer_neg_=
helper' does not allow automatic multiple TOCs; recompile with -mminimal-to=
c or -fno-optimize-sibling-calls, or make `bpf_internal_load_pointer_neg_he=
lper' extern
powerpc64-linux-ld: arch/powerpc/net/built-in.o: In function `sk_load_half_=
negative_offset':
(.text+0x238): sibling call optimization to `bpf_internal_load_pointer_neg_=
helper' does not allow automatic multiple TOCs; recompile with -mminimal-to=
c or -fno-optimize-sibling-calls, or make `bpf_internal_load_pointer_neg_he=
lper' extern
powerpc64-linux-ld: arch/powerpc/net/built-in.o: In function `sk_load_byte_=
negative_offset':
(.text+0x294): sibling call optimization to `bpf_internal_load_pointer_neg_=
helper' does not allow automatic multiple TOCs; recompile with -mminimal-to=
c or -fno-optimize-sibling-calls, or make `bpf_internal_load_pointer_neg_he=
lper' extern
powerpc64-linux-ld: arch/powerpc/net/built-in.o: In function `sk_load_byte_=
msh_negative_offset':
(.text+0x2f0): sibling call optimization to `bpf_internal_load_pointer_neg_=
helper' does not allow automatic multiple TOCs; recompile with -mminimal-to=
c or -fno-optimize-sibling-calls, or make `bpf_internal_load_pointer_neg_he=
lper' extern
powerpc64-linux-ld: final link failed: Bad value

I started building with gcc 4.6.3/binutils 2.22 today.  gcc
4.6.0/binutils 2.21 do not produce this error, it produces this instead
(which has been happening for a long time):

powerpc64-linux-ld: TOC section size exceeds 64k

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__20_Jun_2012_17_50_14_+1000_267of1xduDZ4C/IM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP4YC2AAoJEECxmPOUX5FEJQQP/ivHbYTDlx+67ASMOUaoCXT4
eUEdWbgFVOs7JS8QCJdu/kYUWrxnny3gtcgmZH3tzkC74z0mgHe/MFciHAFh7OmY
YkdMwh5nApiaBoTH00P/f3jCaOVlj7MS4JHq0iVaMhZDVSq4/ti1RrjhclLfRdKU
865WfyWQBZPYf5AWuSMozx6wupOilXsWjE28TYAeu2prq9MHfw+JncAN75UaffDA
IVtv8rskdOb6s3LFfdtDJhAKCIsg3ZWj8tqa1OQ4+q77DKjfVgrfZFOcDWBE9VQr
2OsjNkWnuOHMZCGxcZNA0dKlFz+om2KuberiMIHenTv5/AqOPTtw+ujZI1VjWoy7
zol94kuRMz+nPyNPn+3Q35lrQOQUw4vMWFAWxkv+t35cHTkoOJQdPVXOiYKqSsmA
Mjn1HNoiBn8YFiNCFM9/Q378hc7la63v9wBpfXSZaFlR5G3ZzgKwyFAql9NAnbuP
3cOs3Kkf3T5lJma88DNBZ2HHnPmcjoufm6sorZvTe6ntK+kiErDP44oYKqZbjeNk
L+9XNDm9MEgZfCMO5ZGsZYIDMQ2iln42yysk36chmgbncGJtN+ZtxuApBotV3Ynh
AgZh7sgQXbdnA/XZMxlu2DKTy9a5NDDnqKWTDWMd7bgum8qaUEgby7giwS4QdnzB
HlzCQPV8QC19/GfH5qOK
=qpp2
-----END PGP SIGNATURE-----

--Signature=_Wed__20_Jun_2012_17_50_14_+1000_267of1xduDZ4C/IM--
