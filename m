Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332Ab2HCGtE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 02:49:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:63645 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199Ab2HCGtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 02:49:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="asc'?scan'208";a="175079975"
Message-ID: <1343976814.1730.20.camel@sauron.fi.intel.com>
Subject: Re: R.I.P. pdflush
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Jeff Mahoney <jeffm@suse.de>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>
Date: Fri, 03 Aug 2012 09:53:34 +0300
In-Reply-To: <501AF0CC.6010903@suse.de>
References: <1343229134-29487-1-git-send-email-artem.bityutskiy@linux.intel.com>
	 <501AF0CC.6010903@suse.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-jj+ETEBq4hiTGQjW3GXe"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jj+ETEBq4hiTGQjW3GXe
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-08-02 at 17:27 -0400, Jeff Mahoney wrote:
> On 7/25/12 11:11 AM, Artem Bityutskiy wrote:
> > For example, reiserfs deadlocked quickly when I tested it using
> > xfstests with resierfs quota support enabled. I spend several days
> > trying to fix this, but reiserfs is quite complex and I'd say its
> > locking is crazy (partially because of the BKL push-down). But I
> > gave up after I realized that the dead-lock is related to the quota
> > support. I disabled quotas and xfstests passed.
>=20
> Thanks for mentioning this. This is due to both reiserfs_write_dquot
> and reiserfs_evict_inode taking the reiserfs_write_lock. The old
> reiserfs locking code depended on the recursive locking ability of the
> BKL and the push-down made that a special case. This case isn't
> handled so even though the write lock is supposed to be dropped to
> take the journal lock safely, it's not and we end up with an ABBA case
> there.
>=20
> I'll work up a fix.

Thanks Jeff. Note, I sent the bug-report as well:
http://thread.gmane.org/gmane.linux.file-systems/64794/focus=3D23910

--=20
Best Regards,
Artem Bityutskiy

--=-jj+ETEBq4hiTGQjW3GXe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQG3VuAAoJECmIfjd9wqK0V6gP/jEBlSWNjjkyEluZPauZ/xRI
7Y2LE7CY43F05m2jTY8WmHmiMMhTr5mvMjdNU6ODyTIz6lzD+B5Uz9NeQYExfMQl
Cyv27KVLwqW3gxyWxQNNuOjxhxmZMqtOVPNQ9s16t0jWUabckqgsyieB/Sp4UXs8
JObPFjvf7JN4QRlt5oIQyee5ZCJPt4B1SolVOfRQfO/MvNCouM+yU/9XUORdWi5B
JEobV5JTc7w4ublk8aKRG3n5fygJ04b0GIKATLKcPg3saFSyUxkLH3vxGfwVg+Fe
+3+9yl7eKCrpvmENdn17M+JynZQRxkVOc00m5xjpIjuzqeXOjKBdr3P7e1m/NxlD
1pE+eKoWiV/vtf4UAF/3zrZj1m3JGq+oWwZu7nOfwpds7pHSvxeY0xL8fphR7M1v
8oIw2QOareRzKKvEq9iK8rMom0Bi/olDDUWtnv35dfBO8RWwFIXGrXM38kI4Bjg1
SSscXEbzT9kUpZqbB7PkdeGhPDbnfodGUDlZYbMwFgJvndrnV++aa2AizZohgn+2
J+69OPVYtNkYzR0zcudbzH+/iBfmvwD5EGxw/Co5KrdwHLrxSR9jubjsLkf7UJIl
z1Zy5b3LngUQ+WzfSC8SOMugR3PcTEgYIH2Ot08WUtiJtq6I06kUNXWSusoOkD5+
goMvab2vybf5g0NW8+za
=uOXz
-----END PGP SIGNATURE-----

--=-jj+ETEBq4hiTGQjW3GXe--

