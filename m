Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508Ab0DGGkl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 02:40:41 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40695 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932071Ab0DGGke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 02:40:34 -0400
Date: Wed, 7 Apr 2010 16:40:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Avi Kivity <avi@qumranet.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alexander Graf <agraf@suse.de>
Subject: linux-next: build failure after merge of the final tree (kvm tree
 related)
Message-Id: <20100407164027.deda6daf.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.18.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__7_Apr_2010_16_40_27_+1000_FtHSZ5dMBOuWUPTn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__7_Apr_2010_16_40_27_+1000_FtHSZ5dMBOuWUPTn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc ppc44x_defc=
onfig)
failed like this:

arch/powerpc/kvm/built-in.o: In function `kvm_vcpu_ioctl_interrupt':
(.text+0x4840): undefined reference to `kvmppc_core_dequeue_external'

Caused by commit 6fc1eb3ee0ad1667b217d993e9bd26089f2b0b32 ("KVM: PPC:
Allow userspace to unset the IRQ line") from the kvm tree.  I guess an
implementation was forgotten.

I reverted the whole kvm tree for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__7_Apr_2010_16_40_27_+1000_FtHSZ5dMBOuWUPTn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAku8KNsACgkQjjKRsyhoI8yNogCfborwRwW0c7oO36IZr5AJn4on
YooAmwSpcH9n+CPHmmetocYQyjEPXuB1
=Y5cZ
-----END PGP SIGNATURE-----

--Signature=_Wed__7_Apr_2010_16_40_27_+1000_FtHSZ5dMBOuWUPTn--
