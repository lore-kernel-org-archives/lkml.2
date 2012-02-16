Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab2BPXj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 18:39:29 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:44819 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755037Ab2BPXj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 18:39:27 -0500
Date: Fri, 17 Feb 2012 10:39:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Konrad Wilk <konrad.wilk@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: linux-next: build failure after merge of the staging tree
Message-Id: <20120217103917.36721f3e8f75c35092c2dce2@canb.auug.org.au>
In-Reply-To: <be7afe58-43f1-4f69-b0ae-89dd7607355b@default>
References: <20120216152316.821ac82e04a5ee30327b81c3@canb.auug.org.au>
	<20120216051552.GA5676@kroah.com>
	<c6634d7c-b264-4a87-bab1-74408341dab0@default>
	<20120217082559.6a094265da2d5c203bfc445f@canb.auug.org.au>
	<be7afe58-43f1-4f69-b0ae-89dd7607355b@default>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__17_Feb_2012_10_39_17_+1100_SJd_VGTLk3OsbdWD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__17_Feb_2012_10_39_17_+1100_SJd_VGTLk3OsbdWD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dan,

On Thu, 16 Feb 2012 13:49:53 -0800 (PST) Dan Magenheimer <dan.magenheimer@o=
racle.com> wrote:
>
> Huh?  Do you do allyesconfig/allmodconfig build testing after you pull
> each individual tree or only after all trees are pulled?  (Apparently
> the former, as otherwise the ordering shouldn't matter, right?)

=46rom my daily release note:

"Between each merge, the tree was built with
a ppc64_defconfig for powerpc and an allmodconfig for x86_64. After the
final fixups (if any), it is also built with powerpc allnoconfig (32 and
64 bit), ppc44x_defconfig and allyesconfig (minus
CONFIG_PROFILE_ALL_BRANCHES - this fails its final link) and i386, sparc
and sparc64 defconfig. These builds also have
CONFIG_ENABLE_WARN_DEPRECATED, CONFIG_ENABLE_MUST_CHECK and
CONFIG_DEBUG_INFO disabled when necessary."

So yes, I build between each merge.  It allows me to isolate where
problems are occurring so that they can be easily fixed in isolation.

> If you are doing the after-every-individual-tree build testing,
> yes, if you could pull konrad's tmem tree first, that would
> solve this problem I believe.**

Yes, I can do that (and will for today).  However, it does mean that the
staging tree now cannot be merged into Linus' tree until after the tmem
tree has been merged.   And if Linus decides not to take it, then Greg
will have to remove these commits from his tree (or revert them) before
he can get all the rest of the staging tree into Linus' tree.

> I suspect unit testing doesn't make much as much sense in staging
> as it does in the core kernel.  I did testing of ramster in my

Of course it makes sense - at least at the "make sure it builds" level.

> public git tree (which includes the tmem patchset coming to you via
> konrad) but, since it is a staging driver, the bits have to go
> through Greg.

Maybe you should seek a dispensation from Greg to allow your ramster tree
to exist independently in linux-next and be merged independently by
Linus'.  Greg may want to keep watch in your tree, but that should not be
much more effort than reviewing and applying your patches to the staging
tree.

> Yes, there are a number of parts from different companies/timezones
> now flying in close formation.  The name change (flush->invalidate)
> causing this problem was insisted upon by Andrew Morton (and has been
> in linux-next for several months), otherwise it wouldn't have happened
> and wouldn't be causing these issues :-(  But better to work through
> them in -next than in Linus' merge window I guess.

Definitely.

I do realise that the staging tree is "special", but I am trying to deal
with this in a generic manner (as I would for dependencies between any
other two trees).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__17_Feb_2012_10_39_17_+1100_SJd_VGTLk3OsbdWD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPPZOlAAoJEECxmPOUX5FER4cQAIvQVVtaeRd/yarwrOIcOGfA
cwlbfTvofpVarDO8+ncxaZzlAUEY8Oul1yO4kJ9gtEE12mnknVXLWegA4mLOQqL1
18b+A5qCUIlv1J1TAEFmccgk7/fsE0i1zlOBqWCCk+CRHlEBml9djJzDYgH4Cjm7
zUXiLFlRRp5oUv073n81CeMOlcskKtLErZA/eOGbYE5Z1QpHKx6qpRJKtoyj5QA2
ouwfImLusIE2ghcWPdJOWJrftU1nEHB+9sYZCUCJCDvHGrHoFaBbPPo2K4V+/l0v
BGHlocnEcDevbnMdWWmgIqMgIbGaSU6UsHanEhwpmK5zHw8je8J3uV3Ek3V8MTX+
IdlmigbKZa5qIARqR3HtRG7k1E3IdkKBYiqnZrrYO53s/wp3taAZu2MMPFhm3+UZ
SSvMqsdavAEjWk4XZsJOltGR3u+s2kPiHXm1X33gptLzYdqY4V6IRWXTXpcDrPkI
4UY59ABmg/UvGZPsrYE/A83WKHO7xNgYQfdqOpYCmJdp0xd/XU7yAmCesKkawPkx
I8LX7DnpgYngZbbmjw/iz/K56yTp8piwSAMsY9Qy469TN1glLkzXyEmsM8kFrIyx
Lwo0QdV9jaMpmDeuEUXQLlyqwy+YvyzWYBqkwnIh60HEDQRcBhYPbpYP++oH9o3D
JZnnQMD7B8OpB2xsj4Da
=5QWX
-----END PGP SIGNATURE-----

--Signature=_Fri__17_Feb_2012_10_39_17_+1100_SJd_VGTLk3OsbdWD--
