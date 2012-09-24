Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab2IXLwh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 07:52:37 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55029 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814Ab2IXLwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 07:52:35 -0400
Date: Mon, 24 Sep 2012 21:52:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Subject: linux-next: manual merge of the userns tree with the security tree
Message-Id: <20120924215222.8933c5557b17239552f0b1d1@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Sep_2012_21_52_22_+1000_OldpizXdwdlhfTP4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Sep_2012_21_52_22_+1000_OldpizXdwdlhfTP4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

Today's linux-next merge of the userns tree got a conflict in
security/integrity/ima/ima_policy.c between commit 07f6a79415d7 ("ima:
add appraise action keywords and default rules") from the security tree
and commit 8b94eea4bfb8 ("userns: Add user namespace support to IMA") from
the userns tree.

I fixed it up (see below) but it probably needs more and can carry the
fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc security/integrity/ima/ima_policy.c
index cda9031,c84df05..0000000
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@@ -45,8 -39,7 +45,8 @@@ struct ima_rule_entry=20
  	enum ima_hooks func;
  	int mask;
  	unsigned long fsmagic;
- 	uid_t uid;
+ 	kuid_t uid;
 +	uid_t fowner;
  	struct {
  		void *rule;	/* LSM file metadata specific */
  		int type;	/* audit type */
@@@ -141,10 -112,8 +141,10 @@@ static bool ima_match_rules(struct ima_
  	if ((rule->flags & IMA_FSMAGIC)
  	    && rule->fsmagic !=3D inode->i_sb->s_magic)
  		return false;
- 	if ((rule->flags & IMA_UID) && rule->uid !=3D cred->uid)
+ 	if ((rule->flags & IMA_UID) && !uid_eq(rule->uid, cred->uid))
  		return false;
 +	if ((rule->flags & IMA_FOWNER) && rule->fowner !=3D inode->i_uid)
 +		return false;
  	for (i =3D 0; i < MAX_LSM_RULES; i++) {
  		int rc =3D 0;
  		u32 osid, sid;
@@@ -336,8 -277,7 +336,8 @@@ static int ima_parse_rule(char *rule, s
 =20
  	ab =3D audit_log_start(NULL, GFP_KERNEL, AUDIT_INTEGRITY_RULE);
 =20
- 	entry->uid =3D -1;
+ 	entry->uid =3D INVALID_UID;
 +	entry->fowner =3D -1;
  	entry->action =3D UNKNOWN;
  	while ((p =3D strsep(&rule, " \t")) !=3D NULL) {
  		substring_t args[MAX_OPT_ARGS];

--Signature=_Mon__24_Sep_2012_21_52_22_+1000_OldpizXdwdlhfTP4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYEl2AAoJEECxmPOUX5FEetoP/i6AS8bAt7eGrh/FywfnCMGN
108MDxtQBdKuBIKvNe+rvWnCuO5xG5IzZVmej196bDSKa1R3k0iD1pN2ob44X/rn
hfGqFAXEWWc1ZSAW58GJfkIEKguXJvEhX2v1S55WgSZPkShf/g2IoJ4X1FF6xnJi
SryuEh4IQslDLQKPLEMcVWQ+6Kg6HkK4brea0kaqH5XsIfSorCggx00qICZH+c1a
+1u8zT06qdB2PZD9Wer909bK2+qR5BG7m0hMzEny6QZubqw9oOnJRSNn9YuLBrOe
se0Mw95TzL3bcJJl1BKNATj4QqJMxNDwBUSyBj5ctbmXHSWOSi84QHUTEKsaWngG
zmlak7EIikvksTg35HRblEtCIrN/Hw0WqxarZ4ckFxOctgKje/C6GKGhjteRwcD3
ALh6d/SXq7RmceOCYmxhcHOH6bGOONYKb0p2tWuPCq/CG8BOrpcPQJm+WgiOE2CY
1sj3mK6g8IN+myV8pHcI5BpULSySz5UvOpP7NH2GVFssCx7jVhnQtctg2ChkdOLu
x2DATXwB6wGEz+LOHOyBFTOYD8nL5aT0rnogVr3mQ+7bk+YhtJU70kLOzW8RjNln
6oF92p4wNZDO8Ui5crIftNizd+N9JXYnU3gTQK4f7FAR3HN4MYWxis0gcZdEueDE
gKFmh2NqpzURqpjwgMrv
=5baR
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Sep_2012_21_52_22_+1000_OldpizXdwdlhfTP4--
