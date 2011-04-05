Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab1DEXbJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 19:31:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51900 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab1DEXbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 19:31:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Thilo-Alexander Ginkel" <thilo@ginkel.com>
Subject: Re: Soft lockup during suspend since ~2.6.36 [bisected]
Date: Wed, 6 Apr 2011 01:28:33 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
References: <BANLkTi=kQgS62c7HwwFGhNCQzWr2N6kZjA@mail.gmail.com>
In-Reply-To: <BANLkTi=kQgS62c7HwwFGhNCQzWr2N6kZjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104060128.33887.arnd@arndb.de>
X-Provags-ID: V02:K0:PO81qNn3zyFM8H5PpTmP0wk7dw0Mh3rWqzzMKhSG86O
 EJ/EOeApyEBaBjkgSdSgWwYKpNqjzpXT8OU8R0W/Ok01VS2zJD
 bq5cOdj5z3n7AH8fi9gp0iyXHreG1JnTtwoQAUg1VjIeKPBil1
 9WLToewKETjpRq7n+e4rlOMlbYqPGzHzjnjVnsKKrzn7wkl6vw
 PZZ+s4+z0lebGM/bF/YQA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 April 2011, Thilo-Alexander Ginkel wrote:
> On Mon, Apr 4, 2011 at 17:32, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Monday 04 April 2011, Thilo-Alexander Ginkel wrote:
> >> ACK. I see two possibilities:
> >> a) The bug was introduced after the bisected bug was fixed
> >> b) The bug was already present earlier, but was masked by the bug from
> >> the bisected change
> >>
> >> I hope for a) as that would open the possibility to bisect this new bug.
> >
> > In case of b), you can still bisect it when you either apply the later fix
> > or revert the original patch whenever you build a kernel. Or you can try
> > to avoid using the usb-hid driver during bisect.
> 
> Thanks, that worked pretty well. A bisect with eleven builds later I
> have now identified the following candidate commit, which may have
> introduced the bug:
> 
> dcd989cb73ab0f7b722d64ab6516f101d9f43f88 is the first bad commit
> commit dcd989cb73ab0f7b722d64ab6516f101d9f43f88
> Author: Tejun Heo <tj@kernel.org>
> Date:   Tue Jun 29 10:07:14 2010 +0200

Sorry, but looking at the patch shows that it can't possibly have introduced
the problem, since all the code that is modified in it is new code that
is not even used anywhere at that stage.

As far as I can tell, you must have hit a false positive or a false negative
somewhere in the bisect.

	Arnd
