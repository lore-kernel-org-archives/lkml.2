Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab1ELBIy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 21:08:54 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:47865 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab1ELBIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 21:08:53 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: mmotm 2011-04-29 - wonky VmRSS and VmHWM values after swapping
In-Reply-To: Your message of "Tue, 10 May 2011 18:04:45 +0200."
             <1305043485.2914.110.camel@laptop>
From: Valdis.Kletnieks@vt.edu
References: <201104300002.p3U02Ma2026266@imap1.linux-foundation.org> <49683.1304296014@localhost> <8185.1304347042@localhost> <20110502164430.eb7d451d.akpm@linux-foundation.org>
            <1305043485.2914.110.camel@laptop>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1305162521_2485P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 11 May 2011 21:08:41 -0400
Message-ID: <3313.1305162521@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020201.4DCB331D.00C8,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1305162521_2485P
Content-Type: text/plain; charset=us-ascii

On Tue, 10 May 2011 18:04:45 +0200, Peter Zijlstra said:

> I haven't quite figured out how to reproduce, but does the below cure
> things? If so, it should probably be folded into the first patch
> (mm-mmu_gather-rework.patch?) since that is the one introducing this.
> 
> ---
> Subject: mm: Fix RSS zap_pte_range() accounting
> 
> Since we update the RSS counters when breaking out of the loop and
> release the PTE lock, we should start with fresh deltas when we
> restart the gather loop.

Confirming this patch makes the numbers look sane and plausible again, so
feel free to stick a Tested-By: to match the Reported-By:.

--==_Exmh_1305162521_2485P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNyzMZcC3lWbTT17ARApyMAKCJfiHzhEgR8XwpgnhK12nzEBoNUgCgpXah
1caMfu6xRn68C2XkrP7CCMI=
=lTLb
-----END PGP SIGNATURE-----

--==_Exmh_1305162521_2485P--

