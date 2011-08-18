Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894Ab1HRS2L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 14:28:11 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:37823 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab1HRS2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 14:28:10 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Johannes Weiner <jweiner@redhat.com>
Cc: Greg Thelen <gthelen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH] memcg: remove unneeded preempt_disable
In-Reply-To: Your message of "Thu, 18 Aug 2011 16:41:53 +0200."
             <20110818144153.GA19920@redhat.com>
From: Valdis.Kletnieks@vt.edu
References: <1313650253-21794-1-git-send-email-gthelen@google.com> <20110818093800.GA2268@redhat.com> <96939.1313677618@turing-police.cc.vt.edu>
            <20110818144153.GA19920@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1313692071_2611P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 18 Aug 2011 14:27:51 -0400
Message-ID: <8365.1313692071@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A090202.4E4D59AB.002A,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1313692071_2611P
Content-Type: text/plain; charset=us-ascii

On Thu, 18 Aug 2011 16:41:53 +0200, Johannes Weiner said:
> On Thu, Aug 18, 2011 at 10:26:58AM -0400, Valdis.Kletnieks@vt.edu wrote:
> > On Thu, 18 Aug 2011 11:38:00 +0200, Johannes Weiner said:
> > 
> > > Note that on non-x86, these operations themselves actually disable and
> > > reenable preemption each time, so you trade a pair of add and sub on
> > > x86
> > > 
> > > -	preempt_disable()
> > > 	__this_cpu_xxx()
> > > 	__this_cpu_yyy()
> > > -	preempt_enable()
> > > 
> > > with
> > > 
> > > 	preempt_disable()
> > > 	__this_cpu_xxx()
> > > +	preempt_enable()
> > > +	preempt_disable()
> > > 	__this_cpu_yyy()
> > > 	preempt_enable()
> > > 
> > > everywhere else.
> > 
> > That would be an unexpected race condition on non-x86, if you expected _xxx and
> > _yyy to be done together without a preempt between them. Would take mere
> > mortals forever to figure that one out. :)
> 
> That should be fine, we don't require the two counters to be perfectly
> coherent with respect to each other, which is the justification for
> this optimization in the first place.

I meant the general case - when reviewing code, I wouldn't expect 2 lines of code
wrapped in preempt disable/enable to have a preempt window in the middle. ;)

--==_Exmh_1313692071_2611P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOTVmncC3lWbTT17ARAsAVAKC1b5V9INlQmsHK6z1zZvAMTcqa4ACfTcSs
GPK+HdG6a1iJ24jq/1lhWGs=
=bIfE
-----END PGP SIGNATURE-----

--==_Exmh_1313692071_2611P--

