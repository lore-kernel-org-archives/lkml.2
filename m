Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528Ab0EFOAI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 10:00:08 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:34713 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab0EFOAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 10:00:06 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: git bisect questions...
In-Reply-To: Your message of "Tue, 04 May 2010 18:08:44 +0200."
             <201005041808.44875.elendil@planet.nl>
From: Valdis.Kletnieks@vt.edu
References: <6677.1272983034@localhost>
            <201005041808.44875.elendil@planet.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1273154402_3911P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 06 May 2010 10:00:03 -0400
Message-ID: <24885.1273154403@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020205.4BE2CB64.001E,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1273154402_3911P
Content-Type: text/plain; charset=us-ascii

On Tue, 04 May 2010 18:08:44 +0200, Frans Pop said:
> Valdis.Kletnieks@vt.edu wrote:
> > 1) I look at 'git bisect visualize', and I see a nice merge point that I
> > am fairly sure will (a) bisect as good and (b) trim out a *lot* of
> > ancestor commits in one shot.  If I do a 'git reset --hard <merge
> > commit>', will that make the next 'git bisect' do what I want?
> 
> Yes.
> 
> > 2) I'm down to the last 100 or so commits, and I have a at least 3 'git
> > bisect skip' in there already because of a (presumably) unrelated oops.
> > I'm pretty sure that commit 10fd883ce384706f88554a0b08cc4d63345e7d8b is
> > the fix - how do I logically move that commit to right after the commit
> > 22dd82a3f5ceef72be19e502418823a2f8801ed0 which introduced the oops, so
> > I can bisect through the 70 or so commits in between?  I know it involves
> > "git cherrypick", but have no clue how to do it...
> 
> One way is, before *each* compilation after a 'git bisect good/bad', to do
> a 'git cherry-pick 10fd883ce3847'. This means you don't actually move it 
> after the commit that causes the problem, but you do add it on top for 
> your compilation.
> 
> But that means that after testing the build you can no longer do a simple
> 'git bisect good/bad' as that would tag the cherry-picked commit instead of 
> the one you tested.
> 
> So instead you have to do 'git bisect good/bad HEAD^' (assuming you did a 
> single cherry-pick) [1].
> This will automatically "remove" the cherry-picked commit again, which is 
> why you have to add it back for your next iteration.

Thanks muchly - after 2 well-chosen 'git resets' and 3 cherry-picks, I'm now
well on my way to bisect down to the offending commit with no further issues
(other than getting interrupted by other tasks, but that's my problem not
lkml's). If you're ever in this corner of rural Virginia, I owe you a
beverage-of-choice. ;)



--==_Exmh_1273154402_3911P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFL4sticC3lWbTT17ARAnbcAKDkRZvwtqHfW2LIpopWpK+1c+plTQCeKJEL
xMOcN+wGLkSn03f0j1WcRFQ=
=zCMQ
-----END PGP SIGNATURE-----

--==_Exmh_1273154402_3911P--

