Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751244Ab0DIAvn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 20:51:43 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:49525 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab0DIAvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 20:51:39 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Patrick McHardy <kaber@trash.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: mmotm 2010-04-05-16-09 uploaded
In-Reply-To: Your message of "Thu, 08 Apr 2010 17:36:07 +0200."
             <4BBDF7E7.708@trash.net>
From: Valdis.Kletnieks@vt.edu
References: <201004052336.o35NaeSE015814@imap1.linux-foundation.org> <13074.1270663309@localhost> <4BBDC0CC.7080305@trash.net> <6795.1270740197@localhost>
            <4BBDF7E7.708@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1270774206_4354P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 08 Apr 2010 20:50:06 -0400
Message-ID: <8356.1270774206@localhost>
X-Mirapoint-Received-SPF: 128.173.34.98 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020203.4BBE79C0.00F6,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1270774206_4354P
Content-Type: text/plain; charset=us-ascii

On Thu, 08 Apr 2010 17:36:07 +0200, Patrick McHardy said:

> Valdis.Kletnieks@vt.edu wrote:

> > Well, it *changed* it.  Does the rcu_defererence_check() only fire on the
> > first time it hits something, so we've fixed the first one and now we get to
> > see the second one?
> 
> It appears that way, otherwise you should have seen a second warning in
> nf_conntrack_ecache the last time.
> 
> > (For what it's worth, if this is going to be one-at-a-time whack-a-mole, I'm
> > OK on that, just want to know up front.)
> 
> I went through the other files and I believe this should be it.
> We already removed most of these incorrect rcu_dereference()
> calls a while back.

Confirming - the second version of the patch fixes all the network-related
RCU complaints I've been able to trigger...

--==_Exmh_1270774206_4354P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLvnm+cC3lWbTT17ARAlV4AJ9LeqKJxNKJHopdR6TZztZiQKqb6wCfXlAs
6+jWKabDR4mVLHFUHMYljSA=
=guT+
-----END PGP SIGNATURE-----

--==_Exmh_1270774206_4354P--

