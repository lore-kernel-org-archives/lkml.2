Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903Ab2ECHKK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 03:10:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:45262 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627Ab2ECHKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 03:10:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="161312894"
Message-ID: <1336029206.13013.11.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] vmalloc: add warning in __vmalloc
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Nick Piggin <npiggin@gmail.com>
Cc: Sage Weil <sage@newdream.net>, Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kosaki.motohiro@gmail.com,
        rientjes@google.com, Neil Brown <neilb@suse.de>,
        David Woodhouse <dwmw2@infradead.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        James Morris <jmorris@namei.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Date: Thu, 03 May 2012 10:13:26 +0300
In-Reply-To: <CAPa8GCCzyB7iSX+wTzsqfe7GHvfWT2wT4aQgK30ycRnkc_BNAQ@mail.gmail.com>
References: <1335932890-25294-1-git-send-email-minchan@kernel.org>
	 <20120502124610.175e099c.akpm@linux-foundation.org>
	 <4FA1D93C.9000306@kernel.org>
	 <Pine.LNX.4.64.1205022241560.18540@cobra.newdream.net>
	 <CAPa8GCCzyB7iSX+wTzsqfe7GHvfWT2wT4aQgK30ycRnkc_BNAQ@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-IhXpZohLmfOVPioqd9U9"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-IhXpZohLmfOVPioqd9U9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-05-03 at 16:30 +1000, Nick Piggin wrote:
> Note that in writeback paths, a "good citizen" filesystem should not requ=
ire
> any allocations, or at least it should be able to tolerate allocation fai=
lures.
> So fixing that would be a good idea anyway.

This is a good point, but UBIFS kmallocs(GFP_NOFS) when doing I/O
because it needs to compress/decompress. But I agree that if kmalloc
fails, we should have a fall-back reserve buffer protected by a mutex
for memory pressure situations.

--=20
Best Regards,
Artem Bityutskiy

--=-IhXpZohLmfOVPioqd9U9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPojAWAAoJECmIfjd9wqK0uyoQAIHwcFt6wlnSB89vJSJSz7kh
O+NcHb04TACpGZCPzaST5tWBN3I03h9fyZC4Cyvy5APcLJkMZaV3znP1lBsXTrRT
tUmoxoSirX89ILYyY9Vafc/+TWfe59DV41/XZY13dWqA0X4m5mlDnaZoaadHCO3Z
chcmUSHqMMgpyBTGzOhxlICDY8e/PBKunzvogc2THrHKjYimL+e8MaPJ3suTe3Vm
OhY/zMaaGMANuUsCVJNXpVGMaPolVkxslZbjljgZDCQ7Iwj9W96Km5E+31w8fz5F
edM03z2EH9Cc1yQKqK+pe8URa4V/rJcGMQsh9KFkfSPDLYdUmr/4isNyTzLzp98c
QA4sue8F3/x2hlssCQKEof9MnHSXA45uhf14gL3va8bZ2y0EQPQ02c6g8OsPKb4E
As9To54l9Nb7fSWXnrRpt+V0W7PrDgMLxDdVmWLtrRFfg9MJogbLRiNcwPqWuM3P
+uE1egbi7MXfepH6vx7gpdwnd8YjqwtZZAbXlBaIz6yPbt5cx908lJirftJxOgKs
xNBMsvX+gTZz6/ObxlMFQa86yiPC8pGatT4siKojCgKj+p+DehqK0FP4HHNTzDuH
xeeMC2bhtpZmxX52mlu5KcehRSjJFIrqfPknJQ6i9A158QzIUre3jMUiDrkD0glI
gva38IN4fRPD+21Ct/ly
=luMf
-----END PGP SIGNATURE-----

--=-IhXpZohLmfOVPioqd9U9--

