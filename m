Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760963Ab2EQVZD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 17:25:03 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:36719 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759935Ab2EQVY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 17:24:59 -0400
Message-ID: <1337289897.8872.8.camel@joe2Laptop>
Subject: Re: [PATCH 1/1] checkpatch: don't fake typedefs with #define
From: Joe Perches <joe@perches.com>
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: linux-kernel@vger.kernel.org, apw@canonical.com
Date: Thu, 17 May 2012 14:24:57 -0700
In-Reply-To: <20120517211641.GC27953@pcarmody2.research.nokia.com>
References: <1337259132-28774-1-git-send-email-ext-phil.2.carmody@nokia.com>
	 <1337288048.17726.64.camel@joe2Laptop>
	 <20120517211641.GC27953@pcarmody2.research.nokia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-18 at 00:16 +0300, Phil Carmody wrote:
> On 17/05/12 13:54 -0700, ext Joe Perches wrote:
> > > +# check for deliberate avoidance of the above anti-typedef rule
> > > +		if ($line =~ /#\s*define\s+$Ident\s+$Type\b/) {
> > > +			WARN("NEW_TYPEDEFS",
> > > +			     "do not fake typedefs using #define\n" . $herecurr);
> > > +		}
> > > +
> > 
> > I think the false positive rate is pretty high.
> > I used this and don't see too many I'd remove.
> > 
> > $ git grep -E "#\s*define\s+\w+\s+(struct|unsigned|char|short|int|long|const)\b"
> > 
> > Got an example you want this to find?
> 
> Too many. Alas I can't share them.

Too bad.

If all the defines end in _t maybe you could use
	if ($line =~ /^\+\s*#\s*define\s+\w+_t\s+$Type\b/) {
etc...


