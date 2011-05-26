Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758431Ab1EZURK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 16:17:10 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:42747 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758135Ab1EZURI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 16:17:08 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, davej@redhat.com,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        torvalds@linux-foundation.org, adobriyan@gmail.com, penberg@kernel.org,
        hpa@zytor.com, Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        pageexec@freemail.hu
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
In-Reply-To: Your message of "Thu, 26 May 2011 16:01:21 EDT."
             <20110526200121.GG29496@redhat.com>
From: Valdis.Kletnieks@vt.edu
References: <1306269105.21443.20.camel@dan>
            <20110526200121.GG29496@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1306440965_8338P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 26 May 2011 16:16:05 -0400
Message-ID: <26081.1306440965@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail: UCE(50)
X-Junkmail-Status: score=50/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=bulk(0),
	refid=str=0001.0A020205.4DDEB50A.0070,ss=3,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1306440965_8338P
Content-Type: text/plain; charset=us-ascii

On Thu, 26 May 2011 16:01:21 EDT, Vivek Goyal said:

> Also randomization of kernel load address at run time will probably have
> some issues with crashkernel=X@Y address syntax. So far user knew what
> address first kernel is booting from and user could speicy where to 
> reserve memory. Now it might happen that user specified some memory
> to reserve and kernel decided to occupy that space resulting in failed
> memory reservation for crash kernel.

That is however fixable - the randomizer just needs to make sure it doesn't
overlay the crashkernel= space, and the crashkernel needs to be started with a
'norandomize' parameter.  If your threat model includes attacks on the
crashkernel that randomizing will help with, you got bigger problems. ;)


--==_Exmh_1306440965_8338P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFN3rUFcC3lWbTT17ARAueeAKDRpW+QeeHoNcrfRR8K1iqOG4nT3gCfRtmF
HLRf0l1y9u3J0GvJ4hfpM+4=
=DkgC
-----END PGP SIGNATURE-----

--==_Exmh_1306440965_8338P--

