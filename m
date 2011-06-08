Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801Ab1FHDeG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 23:34:06 -0400
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:49840 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751688Ab1FHDeE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 23:34:04 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Jun 2011 23:34:04 EDT
X-AuditID: 1209190d-b7bdeae0000004f8-fd-4deeec390861
Subject: Re: XFS problem in 2.6.32
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <4DEE9EDA.90001@profihost.ag>
Date: Tue, 7 Jun 2011 23:28:59 -0400
Cc: david@lang.hm, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <C4F797E7-3B2F-4BAD-BF69-2182DEA775A5@mit.edu>
References: <4DEE1D96.6020208@profihost.ag> <6D8DA3D2-D90B-4D82-BDC9-C3F0264A68BF@mit.edu> <4DEE2C70.8060301@profihost.ag> <alpine.DEB.2.02.1106071239530.28905@asgard.lang.hm> <4DEE9EDA.90001@profihost.ag>
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
X-Mailer: Apple Mail (2.1084)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42IR4hTV1rV8887XYMkzGYu2vlusFpd3zWGz
	2DN/C7sDs8ePZyfYPT50vmT0+LxJLoA5issmJTUnsyy1SN8ugStj4uYTrAXbRCr+ds5hb2Cc
	INDFyMkhIWAicfDPZGYIW0ziwr31bF2MXBxCAvsYJW49Wc8I4axnlOic/w/KOcUkMf/5K3aQ
	FmEBJYnWeX8ZQWxeAUOJpZvaweLMAloSN/69ZAKx2YBq7nzazwJicwLFP8+5AFbPIqAi8fTH
	ZFaIen2Jex+2s0HY2hLLFr5mhphpJXFn/zwWiMVnGSWezX0ONkhEwEJix57FQA0cQHfLSjQt
	y5jAKDgLyRmzkJwxC8nYBYzMqxhlU3KrdHMTM3OKU5N1i5MT8/JSi3SN9HIzS/RSU0o3MYKD
	WpJ3B+O7g0qHGAU4GJV4eNND3vkKsSaWFVfmHmKU5GBSEuWNeAkU4kvKT6nMSCzOiC8qzUkt
	PsQowcGsJML7cx9QjjclsbIqtSgfJiXNwaIkzjtTUt1XSCA9sSQ1OzW1ILUIJivDwaEkwTv5
	NVCjYFFqempFWmZOCUKaiYMTZDgP0PB7r0CGFxck5hZnpkPkTzEqSonz7gJpFgBJZJTmwfXC
	ks4rRnGgV4R57R4BVfEAExZc9yugwUxAg0/1gA0uSURISTUwGmTo7b7DF73anetMjmBbotcB
	a6G/yx8eu+G20bZi6vE33KsmMgm+s/+6mn2F3XSjeak2vprRE38+WHp5ZavO8Tb+0mz9zVaG
	7JNXvSprSpXpr6/l2FBjm/2vZv1127wq1j8majMTw37fvFadullYlr9Gu+VXD9ssBfmtR3Uf
	HbqocDkqVIpdiaU4I9FQi7moOBEAAjLUYxUDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 7, 2011, at 5:57 PM, Stefan Priebe - Profihost AG wrote:

>> whoever the maintainer of the -stable/-longterm tree is (be it an
>> individual or a team employeed by some comapny) then looks at the patch
>> and considers backporting it (if it's too hard, or to intrusive, they
>> may decide not to).
> So i have to contact Greg Kohan from SUSE directly?

Only if you can identity a specific patch you want backported to 2.6.32.

It's not the responsibility of the long-term stable tree maintainer to go looking through potentially tens of thousands of commits to find the one that should be backported.  And if the code has changed too much since .2.6.32, and requires detailed reworking before the patch can get integrated into 2.6.32, then a subsystem developer will have to do that work.

> 
>> the idea of the lonterm kernels is that organizations need to maintain a
>> kernel for a long time due to commitments that they have made (Debian
>> doesn't want to change the kernel it ships in a stable version, RedHat
>> doesn't want to change the kernel version in a RHEL release, etc), and
>> so they publicly announce this so that anyone else wanting to use the
>> same kernel version can share in the work (and therefor everyone can
>> benifit from each other's work)
> That was what i thoght. So a bug like this should get fixed right? Otherwise this makes no sense. Sadly Redhat has ported the fix back in his RHEL 6 2.6.32 kernel but they haven't send the patch to stable / vanilla team.

Not all distributions will participate in the maintenance stable tree.  Red Hat for example is probably worried about people  (specifically, Oracle) taking their kernel expertise "for free" and bidding it against them.  So it doesn't surprise me that they aren't submitting patches to the stable tree.  After all, they would like you to purchase a support contract if you want to get high quality, supported kernel.   Why should they give that work away for free?  After all, their salaried developers have to get paid somehow.  Others will contribute work in the hopes that other people will also contribute fixes back, but of course nothing forces Red Hat to do this.

The thing that you have to understand that this is all a volunteer effort, and a few of your messages sound like you are expecting people to do the work for you.   It doesn't work that way.  If you ask nicely, maybe one of the XFS developers will help you.  But please don't expect free support.  That will just annoy people.

-- Ted


