Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab1CYRqQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 13:46:16 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:41393 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753110Ab1CYRqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 13:46:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=QGakrY7vGw+/DJbNdhklGMOfAiruVS2dm0AYmhFF3OYg56aCTaVFkxHnEhvcihGJVkV1I62c55My+yLkmmgbIE8dSd4gN9t/A8X8zqbhhDLQzQBG0bRzxezbjTR75em5;
Date: Fri, 25 Mar 2011 10:46:09 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jerome Glisse <j.glisse@gmail.com>
Cc: Dave Airlie <airlied@gmail.com>,
        Michel =?ISO-8859-1?B?RORuemVy?= <michel@daenzer.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: Re: [git pull] drm fixes
Message-ID: <20110325104609.2380f08e@jbarnes-desktop>
In-Reply-To: <AANLkTi=etKQPyGw-hrddy4aatEYg5boONZ2T1z4tKGZH@mail.gmail.com>
References: <alpine.DEB.2.00.1103230417270.29019@skynet.skynet.ie>
	<1300864998.3522.71.camel@thor.local>
	<AANLkTimg4n3Bb=XQYCPLGcCrC5NEQWjfzn-RHu2ZfW=h@mail.gmail.com>
	<1300868532.3522.81.camel@thor.local>
	<AANLkTi=mFKBqF48DwGsQL278grJChCVzw==D7vr49n09@mail.gmail.com>
	<Pine.GSO.4.62.1103230633160.12612@umail>
	<1300880747.16522.13.camel@thor.local>
	<AANLkTik=GH8tGMjeKVfsmvX5WeX+4avnYan_nkGcCx20@mail.gmail.com>
	<Pine.GSO.4.62.1103240628490.1156@umail>
	<AANLkTimZWtOLiDT3KoUKZtsKfj4Aeu+XMF+rLc0wCSYk@mail.gmail.com>
	<AANLkTimrHa-Fb=3HN68OML7RddsX_8rrJV_YOK3H6xST@mail.gmail.com>
	<AANLkTi=x0ZZNfzCpKURXMCaiEncsFNQ2tg1zbARnJjx1@mail.gmail.com>
	<AANLkTikti-xUYO_S-ipHzXeNsPtwD1kaLuHbGDMMTXev@mail.gmail.com>
	<AANLkTik1HCrAus2Rv29EK_vGDf9d2m0E=cAuvF6LEQiQ@mail.gmail.com>
	<AANLkTim4jYfAFHkaHAWRU2uAzgRJLP1p1=5dugZgYkhS@mail.gmail.com>
	<AANLkTi=etKQPyGw-hrddy4aatEYg5boONZ2T1z4tKGZH@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Mar 2011 10:04:10 -0400
Jerome Glisse <j.glisse@gmail.com> wrote:

> My feeling on that is that maybe too much code sharing accross gpu of
> different generation hurt more than it helps. I have got the feeling
> that some of the newer Intel asic share some of the bit of older one
> and that intel is focusing there attention on newer one and obviously
> doesn't have time or resource to check that change they do don't
> impact older hw (i don't think such testing is doable without massive
> investment which is very very unlikely to happen given size of linux
> market).

God yes.  The mantra of "code sharing is always good" sounds nice, but
in my experience it's very often not true, especially when you're still
trying to get things to work.

We've been slowly splitting code out to make it more robust against
changes to different generations, but we still have a little ways to
go.  And of course, such splitting introduces problems in itself.

But as a policy going forward, I'll advocate splitting code whenever a
new generation requires something slightly different than an old one.
As an example, rather than adding a few conditionals to our FDI
training code to support newer chips, I've split it into separate
functions entirely, leaving the old one alone.  If, after awhile we've
decided that they really are mostly the same and we have things working
well, we can consider merging them again, but only after extensive
testing across generations.

-- 
Jesse Barnes, Intel Open Source Technology Center
