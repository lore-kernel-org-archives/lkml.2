Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599Ab2BXP6M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 10:58:12 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:43731 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757149Ab2BXP6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 10:58:11 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Jidong Xiao <jidong.xiao@gmail.com>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>
Subject: Re: Can we move device drivers into user-space?
In-Reply-To: Your message of "Fri, 24 Feb 2012 10:19:36 EST."
             <CAG4AFWZD8LeFkidnESCMfYFVFbjekAMJ_OZCTc2NRKJsvN3Qjw@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <CAG4AFWb0iG_t+Ps2isC_DF=f3WfVKyL+H-=ybKCtRP=ZmAAUUA@mail.gmail.com>
            <CAG4AFWZD8LeFkidnESCMfYFVFbjekAMJ_OZCTc2NRKJsvN3Qjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1330099086_3564P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 24 Feb 2012 10:58:06 -0500
Message-ID: <37448.1330099086@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020209.4F47B390.0090,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1330099086_3564P
Content-Type: text/plain; charset=us-ascii

On Fri, 24 Feb 2012 10:19:36 EST, Jidong Xiao said:

> Actually, my major concern is, since UIO has been accepted, then why
> don't we move all the rest device drivers into user space as well. As
> I understand, currently, some of device drivers are running on user
> space, while the other (or say the majority of) device drivers are
> running on kernel space, so why don't we maintain a consistent device
> drivers infrastructure, say, either all in user space, or all in
> kernel space. (Sure some critical device drivers still need to be kept
> in kernel space.)

Sure we could do that, if you deal with all of the following issues:
1) All I/O would take a lot more CPU, due to the additional context switching
that would be required to start an I/O and handle the completion interrupt.
2) It makes it a lot harder to do zero-copy I/O.
3) Once we push the API to userspace, we're stuck with it.  See
Documentation/stable_api_nonsense.txt for the details.

And finally:

4) -ENOPATCH.  You think it's a good idea, do up a patch that works at
least as well as what we have now...

--==_Exmh_1330099086_3564P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBT0ezjgdmEQWDXROgAQK1/w/9E9ZIYDs0XrumalffCBqzJ6D3zNDkkvon
ZBNX4vTA39nqEk2e7ddDi8SvPNMENMVTKI8QxGpDTIEb8IlxzYDNphYla/eJ7o4c
jasdvufD6g5bc1WbK345rhPLLoHSh/dCwOC220xezcOG5RG6G1C1iCfcCkq0jg7h
g1NDUe1pR8LR6u2ycYhBVBkrBqGkTIR/0HGdZPJAXmyjVu+3/hCbOn+4g89okDsd
0cIiqPcReTc/CgdsIziKbBLwIvMehgS2D/mGTTY464+bdJQKy0yd1gg0KLNwqX4o
C99trSw4GmwLcIN41jRHP3Yx4OkfbkronuzFqK5jODS90Jscn4pHvTF/r/++FFSJ
2Z1z+mj/RtKSeg9QI0UWPUulZlKCIAPJtHfpeHBtA54S7VubiFmdrY/FCmEyqqZx
T8ITlLETAKGIcxPK+Qd6xFCgF5asafk3OX82gBuvPoXzwqeOvEjsPRpS0y9iojxk
juHlHAxlkfz7jWXNUTxKx4PwcxnPQJAFWYGfBZG/AHb0AyeJltwzps1aY/q95bPr
8GCunReXC1gZdz64sYLbj8AMbveJ4s503/r0uyjZ7yRWGIS/7KbNf2MYmOCcJT0h
QsCQJDAzHcdIFeTlAEnC2W1H9pqmv+QxUTtq+fjA0ua1sZ8j/qgtGPQ0DdWdkU3G
2fZ2dePb4fc=
=6Pyr
-----END PGP SIGNATURE-----

--==_Exmh_1330099086_3564P--

