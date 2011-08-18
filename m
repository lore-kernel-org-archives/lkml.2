Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775Ab1HRO1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 10:27:23 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:44521 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755658Ab1HRO1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 10:27:21 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Johannes Weiner <jweiner@redhat.com>
Cc: Greg Thelen <gthelen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH] memcg: remove unneeded preempt_disable
In-Reply-To: Your message of "Thu, 18 Aug 2011 11:38:00 +0200."
             <20110818093800.GA2268@redhat.com>
From: Valdis.Kletnieks@vt.edu
References: <1313650253-21794-1-git-send-email-gthelen@google.com>
            <20110818093800.GA2268@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1313677618_2646P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 18 Aug 2011 10:26:58 -0400
Message-ID: <96939.1313677618@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020203.4E4D2138.00AE,ss=1,fgs=0,
	ip=71.62.120.57,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1313677618_2646P
Content-Type: text/plain; charset=us-ascii

On Thu, 18 Aug 2011 11:38:00 +0200, Johannes Weiner said:

> Note that on non-x86, these operations themselves actually disable and
> reenable preemption each time, so you trade a pair of add and sub on
> x86
> 
> -	preempt_disable()
> 	__this_cpu_xxx()
> 	__this_cpu_yyy()
> -	preempt_enable()
> 
> with
> 
> 	preempt_disable()
> 	__this_cpu_xxx()
> +	preempt_enable()
> +	preempt_disable()
> 	__this_cpu_yyy()
> 	preempt_enable()
> 
> everywhere else.

That would be an unexpected race condition on non-x86, if you expected _xxx and
_yyy to be done together without a preempt between them. Would take mere
mortals forever to figure that one out. :)


--==_Exmh_1313677618_2646P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOTSEycC3lWbTT17ARAu4ZAJwJY9zOTyoMHoaP1AEBeEbLV7ts/gCfdoVm
jvD0MeR2VgZciqe/gYUOqxE=
=TMnA
-----END PGP SIGNATURE-----

--==_Exmh_1313677618_2646P--

