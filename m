Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab2GPVDg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 17:03:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:25792 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476Ab2GPVDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 17:03:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="193579467"
Date: Tue, 17 Jul 2012 00:05:15 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@openvz.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Dmitry V. Levin" <ldv@altlinux.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Doug Ledford <dledford@redhat.com>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: [PATCH v2] ns: do not block exit_task_namespaces() for a long
 time
Message-ID: <20120716210515.GA17813@otc-wbsnb-06>
References: <20120713140806.b3d0fda8.akpm@linux-foundation.org>
 <1342451364-14787-1-git-send-email-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
In-Reply-To: <1342451364-14787-1-git-send-email-kirill.shutemov@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 16, 2012 at 06:09:24PM +0300, Kirill A. Shutemov wrote:
> I also move synchronize_rcu() inside free_nsproxy(). It fixes racy
> put_nsproxy() which calls free_nsproxy() without synchronize_rcu().
> I guess it was missed during switch to RCU (see cf7b708).

I was wrong here. No races. RCU protects task->ns_proxy, not ns_proxy
itself.
Sorry for misleading.

--=20
 Kirill A. Shutemov

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQBIILAAoJEAd+omnVudOM0JAQAM5ZT5sbZGDBWZlH0re17ha6
YrmbapIDQQVnucZfgibtWnQFPxE03AxoMX2JKYha+8CFSOVD52LEFlHW790nPEhb
v1b0LbVINI/FH/Wl0F/ot4STQWZBueNGyHLRe1YHzktNf45ghRBxQfjzyMLa63rw
PTdjWM2r/IGhk4Bpb20bHJqJUzUv1pcdhWAbleXPbOCyy8g8orprfbXTGqLUBZun
XkwloEStjtpanv5Nkq7eR0pSKwmJsVXXKYGn9t850Wz3bMairwSI5GQdhjWM3Fhy
0aLRZUgwA03PN2oi7Ycclg4y2gJo08KWUUDDZFW54EltFAbyUrVB9kV0N0rT1ohf
4OMKbMEvRflAfmA8s6NYGjX49wFbX/fGOxi5lLvVsouwrVeV2iikfjs+Sq73CeYe
9vBDyI+UBCgsREtokpIqzCZNtMwlrHxw2jq4sWCQ8aUWt7DmKXymJMxXoS/8eOoa
I73+CwqLpY1Vc3iIqOnq5HQdrVqulFcqsE++hQ3f7vSoHi6g2DbiKOsXRvKlM/DI
nEW94j5cRNeKwUrqDkfWAt0BrSczaXGk6emy+4R73f/qwvgpbz6omazXIwdgTe24
ax0cAxd8qPcywRaQOKODP8bhlbIf9CspJcjHRvbVVhWQMr45vxyH+7rWF93kY2fU
+7kvzCIfzOIAoMWZN3re
=jMa7
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
