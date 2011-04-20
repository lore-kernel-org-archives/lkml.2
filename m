Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586Ab1DTTSF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 15:18:05 -0400
Received: from wnohang.net ([178.79.154.173]:42783 "EHLO mail.wnohang.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114Ab1DTTSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 15:18:04 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 mail.wnohang.net 9FAB640202
X-DKIM: Sendmail DKIM Filter v2.8.3 mail.wnohang.net 9FA7C40200
Date: Thu, 21 Apr 2011 00:47:57 +0530
From: Raghavendra D Prabhu <rprabhu@wnohang.net>
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: linux-mm@kvack.org, Jens Axboe <jaxboe@fusionio.com>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Add check for dirty_writeback_interval in
 bdi_wakeup_thread_delayed
Message-ID: <20110420191757.GA5169@Xye>
References: <20110417162308.GA1208@Xye>
 <1303111152.2815.29.camel@localhost>
 <20110418091609.GC5143@Xye>
 <1303129589.8589.5.camel@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
In-Reply-To: <1303129589.8589.5.camel@localhost>
X-Operating-System: Arch linux x86_64 2.6.38.3-ck3-bldit-db-FAE
X-Editor: VIM - Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

* On Mon, Apr 18, 2011 at 03:26:29PM +0300, Artem Bityutskiy <Artem.Bityutskiy@nokia.com> wrote:
>On Mon, 2011-04-18 at 14:46 +0530, Raghavendra D Prabhu wrote:
>> I have set it to 500 centisecs as that is the default value of
>> dirty_writeback_interval. I used this logic for following reason: the
>> purpose for which dirty_writeback_interval is set to 0 is to disable
>> periodic writeback
>> (http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/fs/fs-writeback.c#L818)
>> , whereas here (in bdi_wakeup_thread_delayed) it is being used for a
>> different purpose -- to delay the bdi wakeup in order to reduce context
>> switches for  dirty inode writeback.
>
>But why it wakes up the bdi thread? Exactly to make sure the periodic
>write-back happen.
I checked the callgraph of bdi_wakeup_thread_delayed and found out that
even though it may be called in the aftermath of wb_do_writeback(), it
is certainly called in the call-chain of sync. So effectively making
that function do nothing when dirty_writeback_interval is unset will
also make sync do nothing. On the other hand, not applying the original
change at all will make it run instantly (jiffies + 0, 0 being the
writeback interval in this case ) thus reversing the benefits of
d7dd01adc098eadc5d5fb07a7d2bf942d09b15df.

--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNrzFlAAoJEKYW3KHXK+l3UF8IAKjhFw7kqDwwaTP5A8HVXyaE
J1Q4bjTpGWqRCnzUlu9VxrofeWT9eXkWhvP7szG9lPEQf+FE+EIP5l15CjvxGIOg
GKVp+HZjVLnD9vqp4BP3qOF/7vVuZOBuk7Rvsa/WpAOm+wgjGwyI+KFoJ3BFiKAC
wsoe33lNrAHSgvb+j2lsWD8G9QjpNNDghTdBYpCQsAoIANQ5UxsCzjfkuxSJ4ygZ
KLhBKC7p1ilZiSnntB4pJF5PY3+MvI9a6TQXSA/SwUWg6rRVFZKH8MeZZklrGfiS
Ngl567bJbKdPNRoQCQj8GPMo3tip9CKBRL78aAO8733IqXOazrAq40cdIzIzPz4=
=D+0j
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--
