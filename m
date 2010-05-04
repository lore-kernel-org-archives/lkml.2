Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933500Ab0EDQIt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 12:08:49 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:1848 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932192Ab0EDQIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 12:08:47 -0400
From: Frans Pop <elendil@planet.nl>
To: Valdis.Kletnieks@vt.edu
Subject: Re: git bisect questions...
Date: Tue, 4 May 2010 18:08:44 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <6677.1272983034@localhost>
In-reply-To: <6677.1272983034@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201005041808.44875.elendil@planet.nl>
X-OriginalArrivalTime: 04 May 2010 16:08:45.0774 (UTC) FILETIME=[12E67EE0:01CAEBA4]
X-RecipientDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> 1) I look at 'git bisect visualize', and I see a nice merge point that I
> am fairly sure will (a) bisect as good and (b) trim out a *lot* of
> ancestor commits in one shot.  If I do a 'git reset --hard <merge
> commit>', will that make the next 'git bisect' do what I want?

Yes.

> 2) I'm down to the last 100 or so commits, and I have a at least 3 'git
> bisect skip' in there already because of a (presumably) unrelated oops.
> I'm pretty sure that commit 10fd883ce384706f88554a0b08cc4d63345e7d8b is
> the fix - how do I logically move that commit to right after the commit
> 22dd82a3f5ceef72be19e502418823a2f8801ed0 which introduced the oops, so
> I can bisect through the 70 or so commits in between?  I know it involves
> "git cherrypick", but have no clue how to do it...

One way is, before *each* compilation after a 'git bisect good/bad', to do
a 'git cherry-pick 10fd883ce3847'. This means you don't actually move it 
after the commit that causes the problem, but you do add it on top for 
your compilation.

But that means that after testing the build you can no longer do a simple
'git bisect good/bad' as that would tag the cherry-picked commit instead of 
the one you tested.

So instead you have to do 'git bisect good/bad HEAD^' (assuming you did a 
single cherry-pick) [1].
This will automatically "remove" the cherry-picked commit again, which is 
why you have to add it back for your next iteration.

Cheers,
FJP

[1] Or you can specify the commit ID of the commit you're really testing.
