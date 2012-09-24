Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366Ab2IXLbc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 07:31:32 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:39671 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301Ab2IXLba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 07:31:30 -0400
Date: Mon, 24 Sep 2012 21:31:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Artem Bityutskiy <dedekind1@gmail.com>
Subject: linux-next: manual merge of the userns tree with the ubifs tree
Message-Id: <20120924213127.d4f1ab780b0084ec72f3c576@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Sep_2012_21_31_27_+1000_9M5J6hs31IQSB7qm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Sep_2012_21_31_27_+1000_9M5J6hs31IQSB7qm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

Today's linux-next merge of the userns tree got a conflict in
fs/ubifs/debug.c between commit 6b38d03f48da ("UBIFS: use pr_ helper
instead of printk") from the ubifs tree and commit 39241beb78f6 ("userns:
Convert ubifs to use kuid/kgid") from the userns tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/ubifs/debug.c
index 2714e02,340d1af..0000000
--- a/fs/ubifs/debug.c
+++ b/fs/ubifs/debug.c
@@@ -238,38 -238,38 +238,38 @@@ void ubifs_dump_inode(struct ubifs_inf
  	struct ubifs_dent_node *dent, *pdent =3D NULL;
  	int count =3D 2;
 =20
 -	printk(KERN_ERR "Dump in-memory inode:");
 -	printk(KERN_ERR "\tinode          %lu\n", inode->i_ino);
 -	printk(KERN_ERR "\tsize           %llu\n",
 +	pr_err("Dump in-memory inode:");
 +	pr_err("\tinode          %lu\n", inode->i_ino);
 +	pr_err("\tsize           %llu\n",
  	       (unsigned long long)i_size_read(inode));
 -	printk(KERN_ERR "\tnlink          %u\n", inode->i_nlink);
 -	printk(KERN_ERR "\tuid            %u\n", (unsigned int)i_uid_read(inode)=
);
 -	printk(KERN_ERR "\tgid            %u\n", (unsigned int)i_gid_read(inode)=
);
 -	printk(KERN_ERR "\tatime          %u.%u\n",
 +	pr_err("\tnlink          %u\n", inode->i_nlink);
- 	pr_err("\tuid            %u\n", (unsigned int)inode->i_uid);
- 	pr_err("\tgid            %u\n", (unsigned int)inode->i_gid);
++	pr_err("\tuid            %u\n", (unsigned int)i_uid_read(inode));
++	pr_err("\tgid            %u\n", (unsigned int)i_gid_read(inode));
 +	pr_err("\tatime          %u.%u\n",
  	       (unsigned int)inode->i_atime.tv_sec,
  	       (unsigned int)inode->i_atime.tv_nsec);
 -	printk(KERN_ERR "\tmtime          %u.%u\n",
 +	pr_err("\tmtime          %u.%u\n",
  	       (unsigned int)inode->i_mtime.tv_sec,
  	       (unsigned int)inode->i_mtime.tv_nsec);
 -	printk(KERN_ERR "\tctime          %u.%u\n",
 +	pr_err("\tctime          %u.%u\n",
  	       (unsigned int)inode->i_ctime.tv_sec,
  	       (unsigned int)inode->i_ctime.tv_nsec);
 -	printk(KERN_ERR "\tcreat_sqnum    %llu\n", ui->creat_sqnum);
 -	printk(KERN_ERR "\txattr_size     %u\n", ui->xattr_size);
 -	printk(KERN_ERR "\txattr_cnt      %u\n", ui->xattr_cnt);
 -	printk(KERN_ERR "\txattr_names    %u\n", ui->xattr_names);
 -	printk(KERN_ERR "\tdirty          %u\n", ui->dirty);
 -	printk(KERN_ERR "\txattr          %u\n", ui->xattr);
 -	printk(KERN_ERR "\tbulk_read      %u\n", ui->xattr);
 -	printk(KERN_ERR "\tsynced_i_size  %llu\n",
 +	pr_err("\tcreat_sqnum    %llu\n", ui->creat_sqnum);
 +	pr_err("\txattr_size     %u\n", ui->xattr_size);
 +	pr_err("\txattr_cnt      %u\n", ui->xattr_cnt);
 +	pr_err("\txattr_names    %u\n", ui->xattr_names);
 +	pr_err("\tdirty          %u\n", ui->dirty);
 +	pr_err("\txattr          %u\n", ui->xattr);
 +	pr_err("\tbulk_read      %u\n", ui->xattr);
 +	pr_err("\tsynced_i_size  %llu\n",
  	       (unsigned long long)ui->synced_i_size);
 -	printk(KERN_ERR "\tui_size        %llu\n",
 +	pr_err("\tui_size        %llu\n",
  	       (unsigned long long)ui->ui_size);
 -	printk(KERN_ERR "\tflags          %d\n", ui->flags);
 -	printk(KERN_ERR "\tcompr_type     %d\n", ui->compr_type);
 -	printk(KERN_ERR "\tlast_page_read %lu\n", ui->last_page_read);
 -	printk(KERN_ERR "\tread_in_a_row  %lu\n", ui->read_in_a_row);
 -	printk(KERN_ERR "\tdata_len       %d\n", ui->data_len);
 +	pr_err("\tflags          %d\n", ui->flags);
 +	pr_err("\tcompr_type     %d\n", ui->compr_type);
 +	pr_err("\tlast_page_read %lu\n", ui->last_page_read);
 +	pr_err("\tread_in_a_row  %lu\n", ui->read_in_a_row);
 +	pr_err("\tdata_len       %d\n", ui->data_len);
 =20
  	if (!S_ISDIR(inode->i_mode))
  		return;

--Signature=_Mon__24_Sep_2012_21_31_27_+1000_9M5J6hs31IQSB7qm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYESPAAoJEECxmPOUX5FEBsoP/ArKoSHJWpSZRQU6i8qUEFG1
wrMzP7895zEwcX7bAWLuUYcf6flSKtH8gK8rXQGrkB/DDK+FBlI/BZh85GfYg7jc
lk21MYF4gqjRntslkHRqKyg55PfTmvA9IQu1gc5X5aUcPkPwKs7SKX/stASEPD0B
nHsehbpXeLltamibxrfVkPFq45rv7g3vDDaEhrzDuMJBGssh2papBjRsVwszWdzO
ldPzmwp5iPtdEt2xJSQCQlGPRKb7WVC8+UiQbQ4e8yiFxhT+8x3j+OUhGgjzB0X0
IAOCxFgRdD5adMHEcFxAu06uJYZSETc8ByCbEJaZWQiR7dgQwqsfZsnte0oBdBoZ
E8QdRDegZn4hj74uM4u4jz5fX6QcK8pKDqibOJR8P7nozZ/o9aDolub59S+zuJE9
gUi1YEvOc6o7lVYSQaIxPLkIGQETxlLSeLIodrOlwN+d44BFiE59nHgk/amKNLn4
/O5jJrpkKP8DMRrXEQRKBB5JgDHEjT29RIc/IwEZmsGrShg/el0DmQ+X4v5fpXLS
dQqVFzkgsYRjLmDTqU1kT2MgGl+FbWLjdrZuYHlwbfJgbLXmgvl5yp+7R0Ey5mvh
gJhb67HC99NFYNO39dustMAEJxCL4QA0CoJBEkCdrpq3vD+bzrTi0Qvy0no6OwdU
pAdZsKcoRKGRmWhLkZAo
=vQvG
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Sep_2012_21_31_27_+1000_9M5J6hs31IQSB7qm--
