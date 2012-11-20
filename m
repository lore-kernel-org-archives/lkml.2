Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab2KTBpB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 20:45:01 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:35695 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913Ab2KTBo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 20:44:59 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Josh Boyer <jwboyer@gmail.com>, Mel Gorman <mgorman@suse.de>,
        Zdenek Kabelac <zkabelac@redhat.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Jiri Slaby <jslaby@suse.cz>, Jiri Slaby <jirislaby@gmail.com>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: Re: [PATCH] Revert "mm: remove __GFP_NO_KSWAPD"
In-Reply-To: Your message of "Fri, 16 Nov 2012 11:51:24 -0800."
             <20121116115124.c2981abc.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20121012135726.GY29125@suse.de> <507BDD45.1070705@suse.cz> <20121015110937.GE29125@suse.de> <5093A3F4.8090108@redhat.com> <5093A631.5020209@suse.cz> <509422C3.1000803@suse.cz> <509C84ED.8090605@linux.vnet.ibm.com> <509CB9D1.6060704@redhat.com> <20121109090635.GG8218@suse.de> <509F6C2A.9060502@redhat.com> <20121112113731.GS8218@suse.de> <CA+5PVA75XDJjo45YQ7+8chJp9OEhZxgPMBUpHmnq1ihYFfpOaw@mail.gmail.com>
            <20121116115124.c2981abc.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1353375823_1855P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 19 Nov 2012 20:43:43 -0500
Message-ID: <45635.1353375823@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020204.50AAE050.00E2,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1353375823_1855P
Content-Type: text/plain; charset=us-ascii

On Fri, 16 Nov 2012 11:51:24 -0800, Andrew Morton said:
> On Fri, 16 Nov 2012 14:14:47 -0500
> Josh Boyer <jwboyer@gmail.com> wrote:
>
> > > The temptation is to supply a patch that checks if kswapd was woken for
> > > THP and if so ignore pgdat->kswapd_max_order but it'll be a hack and not
> > > backed up by proper testing. As 3.7 is very close to release and this is
> > > not a bug we should release with, a safer path is to revert "mm: remove
> > > __GFP_NO_KSWAPD" for now and revisit it with the view to ironing out the
> > > balance_pgdat() logic in general.
> > >
> > > Signed-off-by: Mel Gorman <mgorman@suse.de>
> >
> > Does anyone know if this is queued to go into 3.7 somewhere?  I looked
> > a bit and can't find it in a tree.  We have a few reports of Fedora
> > rawhide users hitting this.
>
> Still thinking about it.  We're reverting quite a lot of material
> lately.
> mm-revert-mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures.patch
> and revert-mm-fix-up-zone-present-pages.patch are queued for 3.7.
>
> I'll toss this one in there as well, but I can't say I'm feeling
> terribly confident.  How is Valdis's machine nowadays?

I admit possibly having lost the plot.  With the two patches you mention stuck
on top of next-20121114, I'm seeing less kswapd issues but am still tripping
over them on occasion.  It seems to be related to uptime - I don't see any for
a few hours, but they become more frequent.  I was seeing quite a few of them
yesterday after I had a 30-hour uptime.

I'll stick Mel's "mm: remove __GFP_NO_KSWAPD" patch on this evening and let you
know what happens (might be a day or two before I have definitive results, as
usualally my laptop gets rebooted twice a day).


--==_Exmh_1353375823_1855P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUKrgTgdmEQWDXROgAQIlPw/+O72fn1X2bl4WGFjrOWRpJj0rwxAmGh5F
DHQDXO0ddBRnK2myFab16ISrDuU11+tP+ygRgepOYyBZ6sBL6EneIIc0Wzvpih6G
eB0rvgKeWox2xk0LEcghxP8mgV3umAmyD4lrhZrxot4jzmiVqZu/57jmubZjzT0j
eqxLZ+KU23WGHkiRN94kKZehElf+Jw0N9cmKZTB2I5HkIEzx7gvkHzSXD6s112bC
9l4Jq5eToQA+lc12314gr9PWzXGkYlarftXgly23cHUk/m055mG80BOZWXj/hglF
cOmj+EwOWg76+rb7o+L3Z0JIlV4ol0bdXQwlXtx9/ePo0q12ENgXCJLUpVcutMfd
C8cf6RVG1b0OPKDjT60Igq9NBVHTSTB2T0EH0wdBs6knLRDljehzNpQ1TxVEOlVg
bTq2jPN7sa+e+izKdcj27QwAHYZ7A0GxoMwvEIs6efFE2Ps3vci64ZkaJzfgts3Z
3+oSuYciLjzoLzlQ/+xtu3+LkzRZD66WQHi792nW8JRHrGhOJPAN+REyMPrLsu18
gp8umUDkTtqMEUIr9feGnKlSlIFLRMClAyrsTuMC6dvQgykNAHKG32IZYFHJjY9M
HUestGffH807rrmjl8SUFk/EM31gpCCXxdQMVkZNaMdkuJ90G0hW0OzHXfON2++o
15InbL4Up8E=
=frhe
-----END PGP SIGNATURE-----

--==_Exmh_1353375823_1855P--

