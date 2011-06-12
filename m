Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab1FLXIr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 19:08:47 -0400
Received: from straum.hexapodia.org ([207.7.131.186]:59251 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630Ab1FLXIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 19:08:46 -0400
Date: Sun, 12 Jun 2011 16:09:01 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: Jean Sacren <sakiwit@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] kernel/sched.c: Fix array initialization typo
Message-ID: <20110612230901.GB11580@hexapodia.org>
References: <20110612213107.GA12816@mail.gmail.com> <20110612213549.GA21620@p183.telecom.by> <20110612220116.GB12311@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110612220116.GB12311@mail.gmail.com>
X-Old-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Fingerprint: A5FC 6141 F76D B6B1 C81F  0FB7 AFA0 A45F ED3D 116D
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 12, 2011 at 04:01:16PM -0600, Jean Sacren wrote:
> From: Alexey Dobriyan <adobriyan@gmail.com>
> Date: Mon, 13 Jun 2011 00:35:49 +0300
> >
> > On Sun, Jun 12, 2011 at 03:31:07PM -0600, Jean Sacren wrote:
> > > The fix makes certain so that the size of the initialized arrays doesn't
> > > go beyond the boundary set by the array size of 40.
> > 
> > Why would it possibly do that?
> 
> With that ',' comma, doesn't it imply there might be the 41st element in
> the array?

No, that's not how C works.

> Despite the fact that that element is bogus.

It's not bogus, it's utterly cromulent.  Trailing comma on array
initializer was mentioned in the original K&R and is explicitly endorsed
by ISO/IEC 9899:1999 6.7.8 paragraph 1.

> Further, if the comma is there, what's the benefit? I know you're cool,
> but is it cool in code that way as well?
> > 
> > And it's not a typo.
> 
> What is it then?

It is a standard C idiom for defining array contents.  If you write
int x[] = {
    1,
    2,
    3
};

then when I add a fourth element to your array, I have to modify two
lines, and the diff will say
-    3
+    3,
+    4
 };

whereas if you wrote "3," as the last line of the initializer, the diff
would be one line long.

Furthermore, spot the error in this diff:

@@ -3,4 +3,5 @@ char *x[] = {
     "quick",
     "brown",
     "fox"
+    "jumped"
 };

HTH, HAND,
-andy
