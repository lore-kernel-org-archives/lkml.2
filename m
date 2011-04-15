Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681Ab1DOITu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 04:19:50 -0400
Received: from mail32.mimecast.co.za ([41.208.19.110]:40852 "EHLO
	mail32.mimecast.co.za" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab1DOITs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 04:19:48 -0400
X-Greylist: delayed 1520 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Apr 2011 04:19:47 EDT
Message-Id: <4DA815B6020000AC0004595E@CLU_MAIL.BANKSERV.CO.ZA>
X-Mailer: Novell GroupWise Internet Agent 8.0.1
Date: Fri, 15 Apr 2011 09:53:58 +0200
From: "Bongani Hlope" <bonganih@bankservafrica.com>
To: <torvalds@linux-foundation.org>
Cc: <arnd@arndb.de>, <npiggin@kernel.dk>, <greg@kroah.com>, <hch@lst.de>,
        <bonganilinux@mweb.co.za>, <rjw@sisk.pl>,
        <bernd.feige@uniklinik-freiburg.de>, <petr@vandrovec.name>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [Regression] 2.6.38 ncpfs
Mime-Version: 1.0
X-MC-Unique: 111041509541702801
Content-Type: multipart/mixed; boundary="=__PartFDD11A86.9__="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME message. If you are reading this text, you may want to 
consider changing to a mail reader or gateway that understands how to 
properly handle MIME multipart messages.

--=__PartFDD11A86.9__=
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Linus

On Thu, 2011-04-14 at 13:22 -0700, Linus Torvalds wrote:
> On Thu, Apr 14, 2011 at 1:17 PM, Bongani Hlope
<bonganilinux@mweb.co.za> wrote:
> >
> > Looking at the changes,  you are right. The BUG_ON() seems to be
what is not
> > suppose to be there. The attached patch only removes the BUG_ON().
I'll test
> > on my work PC tomorrow and see if that also fixes the bug.
>=20
> You might also try to replace it with
>=20
>     BUG_ON(!mutex_is_locked(&dentry->d_parent->d_inode->i_mutex))
>=20
> ie add that "d_parent" there. Just for testing - I think the real fix
> really is to remove it, but I'd personally be happier knowing that
> _if_ it were to have that d_parent there, it would have worked.

I've made that change and ncpfs works fine with it. I've attached a
patch that changes the BUG_ON to look at the parent.

>=20
> It would also be interesting to hear if that name length could
> possibly ever change, and we'd hit that test too. It looks like the
> original code actually checked that the length was the same before
> doing the overwrite.
>=20
> ncpfs doesn't seem to be very actively maintained, I suspect Petr
> isn't really using it any more.
>=20
>                    Linus
>=20
>                 Linus
> --
> To unsubscribe from this list: send the line "unsubscribe
linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>=20



=20
=20
This e-mail and its attachments, if any, are subject to BankservAfrica's
e-mail disclaimer which is available on
http://www.bankservafrica.com/Contactus/EmailDisclaimer.aspx.
=20
Please consider the environment before printing this e-mail!
--=__PartFDD11A86.9__=
Content-Type: text/plain; name=ncpfs.patch
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="ncpfs.patch"

--- linux-2.6.33/fs/dcache.c.org=092011-04-04 08:20:20.382107296 +0200=0A++=
+ linux-2.6.33/fs/dcache.c=092011-04-15 08:23:45.530530995 +0200=0A@@ -2123=
,7 +2123,7 @@=0A  */=0A void dentry_update_name_case(struct dentry *dentry,=
 struct qstr *name)=0A {=0A-=09BUG_ON(!mutex_is_locked(&dentry->d_inode->i_=
mutex));=0A+=09BUG_ON(!mutex_is_locked(&dentry->d_parent->d_inode->i_mutex)=
);=0A =09BUG_ON(dentry->d_name.len !=3D name->len); /* d_lookup gives this =
*/=0A=20=0A =09spin_lock(&dentry->d_lock);=0A
--=__PartFDD11A86.9__=--

