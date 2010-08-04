Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934826Ab0HDUiT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 16:38:19 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:50371 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934829Ab0HDUfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 16:35:11 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>,
        Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org,
        xfs@oss.sgi.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: Re: How to track down abysmal performance ata - raid1 - crypto - vg/lv - xfs
In-Reply-To: Your message of "Wed, 04 Aug 2010 12:25:26 +0200."
             <20100804102526.GB13766@isilmar-3.linta.de>
From: Valdis.Kletnieks@vt.edu
References: <20100804073546.GA7494@comet.dominikbrodowski.net> <20100804085039.GA11671@infradead.org> <20100804091317.GA27779@isilmar-3.linta.de> <20100804092122.GA2998@infradead.org> <20100804073546.GA7494@comet.dominikbrodowski.net> <201008041116.09822@zmi.at>
            <20100804102526.GB13766@isilmar-3.linta.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1280953986_3909P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 04 Aug 2010 16:33:06 -0400
Message-ID: <15446.1280953986@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020207.4C59CE83.0142,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1280953986_3909P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <15440.1280953986.1@localhost>

On Wed, 04 Aug 2010 12:25:26 +0200, Dominik Brodowski said:

> The "good" news: it also happens on my notebook, even though it has a
> different setup (no raid, disk -> lv/vg -> crypt). On my notebook, I'm
> more than happy to test out different kernel versions, patches etc.
> 
> /dev/sd*                17.7 MB/s       (100 %)
> /dev/mapper/vg1-*       16.2 MB/s       ( 92 %)
> /dev/mapper/*_crypt      3.1 MB/s       ( 18 %)

Unfortunately, on my laptop with a similar config, I'm seeing this:

# dd if=/dev/sda bs=8k count=1000000 of=/dev/null
1000000+0 records in
1000000+0 records out
8192000000 bytes (8.2 GB) copied, 108.352 s, 75.6 MB/s
# dd if=/dev/sda2 bs=8k count=1000000 of=/dev/null
1000000+0 records in
1000000+0 records out
8192000000 bytes (8.2 GB) copied, 105.105 s, 77.9 MB/s
# dd if=/dev/mapper/vg_blackice-root bs=8k count=100000 of=/dev/null
100000+0 records in
100000+0 records out
819200000 bytes (819 MB) copied, 11.6469 s, 70.3 MB/s

The raw disk, the LUKS-encrypted partition that's got a LVM on it, and a
crypted LVM partition. The last run spikes both CPUs up to about 50%CPU each.
So whatever it is, it's somehow more subtle than that.  Maybe the fact that
in my case, it's disk, crypto, and LVM on the crypted partition, rather than
crypted filesystems on an LVM volume?


--==_Exmh_1280953986_3909P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMWc6CcC3lWbTT17ARAiAuAKCfL5NTEQUgaL9kVy6x0SN/ryDfbgCg9vhS
WfKyIOBnRrmDh2eZQDebem0=
=iHTW
-----END PGP SIGNATURE-----

--==_Exmh_1280953986_3909P--

