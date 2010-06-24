Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab0FXWGj convert rfc822-to-quoted-printable (ORCPT
	<rfc822;w@1wt.eu>); Thu, 24 Jun 2010 18:06:39 -0400
Received: from wdscspam2.wdc.com ([129.253.170.131]:25763 "EHLO
	wdscspam2.wdc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024Ab0FXWGP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 18:06:15 -0400
X-IronPort-AV: E=Sophos;i="4.53,476,1272870000"; 
   d="scan'208";a="112238286"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Subject: RE: Btrfs: broken file system design (was Unbound(?) internal fragmentation in Btrfs)
Date: Thu, 24 Jun 2010 15:06:03 -0700
Message-ID: <469D2D911E4BF043BFC8AD32E8E30F5B24AEBB@wdscexbe07.sc.wdc.com>
In-Reply-To: <AANLkTil5Gl0-rWClRsLZby_c37bQu5RB_tCgHsxTFshO@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Btrfs: broken file system design (was Unbound(?) internal fragmentation in Btrfs)
Thread-Index: AcsTWOMivVY/QmR7TuS+ofSXimlFogAjwrcg
References: <4C07C321.8010000@redhat.com><AANLkTilKw2onQkdNlZjg7WVnPu2dsNpDSvoxrO_FA2z_@mail.gmail.com><4C1B7560.1000806@gmail.com><AANLkTilQm8VGAvc1XNW4EaHd1FLd6dXIXwJ9-yT-joQ8@mail.gmail.com><4C1BA3E5.7020400@gmail.com><20100623234031.GF7058@shareable.org><469D2D911E4BF043BFC8AD32E8E30F5B24AEBA@wdscexbe07.sc.wdc.com> <AANLkTil5Gl0-rWClRsLZby_c37bQu5RB_tCgHsxTFshO@mail.gmail.com>
From: "Daniel Taylor" <Daniel.Taylor@wdc.com>
To: "Mike Fedyk" <mfedyk@mikefedyk.com>
Cc: "Daniel J Blueman" <daniel.blueman@gmail.com>,
       "Mat" <jackdachef@gmail.com>, "LKML" <linux-kernel@vger.kernel.org>,
       <linux-fsdevel@vger.kernel.org>, "Chris Mason" <chris.mason@oracle.com>,
       "Ric Wheeler" <rwheeler@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "The development of BTRFS" <linux-btrfs@vger.kernel.org>
X-OriginalArrivalTime: 24 Jun 2010 22:06:12.0154 (UTC) FILETIME=[7501A1A0:01CB13E9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

=20

> -----Original Message-----
> From: mikefedyk@gmail.com [mailto:mikefedyk@gmail.com] On=20
> Behalf Of Mike Fedyk
> Sent: Wednesday, June 23, 2010 9:51 PM
> To: Daniel Taylor
> Cc: Daniel J Blueman; Mat; LKML;=20
> linux-fsdevel@vger.kernel.org; Chris Mason; Ric Wheeler;=20
> Andrew Morton; Linus Torvalds; The development of BTRFS
> Subject: Re: Btrfs: broken file system design (was Unbound(?)=20
> internal fragmentation in Btrfs)
>=20
> On Wed, Jun 23, 2010 at 8:43 PM, Daniel Taylor=20
> <Daniel.Taylor@wdc.com> wrote:
> > Just an FYI reminder. =A0The original test (2K files) is utterly
> > pathological for disk drives with 4K physical sectors, such as
> > those now shipping from WD, Seagate, and others. =A0Some of the
> > SSDs have larger (16K0 or smaller blocks (2K). =A0There is also
> > the issue of btrfs over RAID (which I know is not entirely
> > sensible, but which will happen).
> >
> > The absolute minimum allocation size for data should be the same
> > as, and aligned with, the underlying disk block size. =A0If that
> > results in underutilization, I think that's a good thing for
> > performance, compared to read-modify-write cycles to update
> > partial disk blocks.
>=20
> Block size =3D 4k
>=20
> Btrfs packs smaller objects into the blocks in certain cases.
>=20

As long as no object smaller than the disk block size is ever
flushed to media, and all flushed objects are aligned to the disk
blocks, there should be no real performance hit from that.

Otherwise we end up with the damage for the ext[234] family, where
the file blocks can be aligned, but the 1K inode updates cause
the read-modify-write (RMW) cycles and and cost >10% performance
hit for creation/update of large numbers of files.

An RMW cycle costs at least a full rotation (11 msec on a 5400 RPM
drive), which is painful.
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
