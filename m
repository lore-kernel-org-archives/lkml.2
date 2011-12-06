Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932911Ab1LFBmb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 20:42:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:63111 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932809Ab1LFBmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 20:42:25 -0500
X-Authority-Analysis: v=2.0 cv=Xd0LPfF5 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=EYO6vQuAaOcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=63xn6-QBRweX3glTVUoA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=jviTgBqhR1iXBv9GQ3EA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111206014222.808638750@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 05 Dec 2011 20:41:14 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jason Baron <jbaron@redhat.com>, Gleb Natapov <gleb@redhat.com>
Subject: [PATCH 4/6] jump_label: jump_label_inc may return before the code is patched
References: <20111206014110.079874115@goodmis.org>
Content-Disposition: inline; filename=0004-jump_label-jump_label_inc-may-return-before-the-code.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Gleb Natapov <gleb@redhat.com>

If cpu A calls jump_label_inc() just after atomic_add_return() is
called by cpu B, atomic_inc_not_zero() will return value greater then
zero and jump_label_inc() will return to a caller before jump_label_update()
finishes its job on cpu B.

Link: http://lkml.kernel.org/r/20111018175551.GH17571@redhat.com

Cc: stable@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Jason Baron <jbaron@redhat.com>
Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/jump_label.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index bbdfe2a..66ff710 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -66,8 +66,9 @@ void jump_label_inc(struct jump_label_key *key)
 		return;
=20
 	jump_label_lock();
-	if (atomic_add_return(1, &key->enabled) =3D=3D 1)
+	if (atomic_read(&key->enabled) =3D=3D 0)
 		jump_label_update(key, JUMP_LABEL_ENABLE);
+	atomic_inc(&key->enabled);
 	jump_label_unlock();
 }
=20
--=20
1.7.7.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO3XL/AAoJEIy3vGnGbaoAgd0QAIsffRY/SBfbOq8fGdw2/09g
bQ/m7/QzgcDQUuXkcHl85mJbiSF6sz+7Y4pdnRD/4iGfxskLPxoVrbqjN0HpinwR
285dkAtuh89b7g+LulKPPxaHuWNC1enOgQ5zNgOXuIGhwTc6GIxZyXXoYQFR1tJH
kq3OiYMb/Bpm0Fa4CO6TWllqgD2FroxiO2uUYX8X3yNr9RFoT90Ct64ehdsvgHtm
YTDRHg1pstagBF0lbjMB448Cs+Oi4llDRJH+7KFKQ2Bbx5j9z8aNO1Bi8D1MLG3e
ASJtjOleG0bWQoamb3jhHprJbwP+A9LENPXLlys/kZHBRl7IMzNPP11Qn4Ejf84W
LDJZb4io757ug86T8EW1yBl8HRM9t72yssWPgLqZd/LJfFDPKO2Kf2nVEv5cAU/4
s+bRvOdpUDg+qGA1PnNbb5U2EQpfIHYHXwQx+Mok4kEYwX7klLG8WWg5218JRx6d
DlOcELDDiRzvpD4GDZmFlpAm+TJfUPkXtHrTBt+oFWzEMRsXQppqj3k+He2dLems
3rH42AqJaM/ZYjLDBXEdh3kJgOWc19TnpbDIiEirzq3ZSAe8ImLlzEKXLN0PYEKo
3dkswfHY3tNtQbjkKOcbqwV0XdZmfO2gZDybycehXuFCrr3NKjQT0uV51NQcAj7c
iweolK71YeLX/SYcjU5x
=DlTs
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
