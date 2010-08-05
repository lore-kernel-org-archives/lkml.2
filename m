Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933067Ab0HEVhR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 17:37:17 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:11331 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932693Ab0HEVhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 17:37:11 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAJ/LWkyrR7H+/2dsb2JhbACgP3GsDpsnhToEhCA
X-IronPort-AV: E=Sophos;i="4.55,324,1278288000"; 
   d="scan'208";a="569297482"
From: Roland Dreier <rdreier@cisco.com>
To: Yegor Yefremov <yegorslists@googlemail.com>
Cc: Tiago Maluta <tiago.maluta@gmail.com>, Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Fix CONFIG_CROSS_COMPILE issue in .config
References: <AANLkTim2mi0wbJJl17OkbCJbRt-s5phR4sumn5GsJKUp@mail.gmail.com>
	<20100621120613.86cad1a4.akpm@linux-foundation.org>
	<4C1FC35C.8090201@suse.cz>
	<AANLkTil2-YNAa-jyOYD4cNtbJQ1XQJ6-v3iJ6wxpz7br@mail.gmail.com>
	<AANLkTinC6Sqs7W--=14nmJFDcTS4HQn0=ysn7VhYDDX6@mail.gmail.com>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 05 Aug 2010 14:37:07 -0700
In-Reply-To: <AANLkTinC6Sqs7W--=14nmJFDcTS4HQn0=ysn7VhYDDX6@mail.gmail.com>
	(Yegor Yefremov's message of "Wed, 4 Aug 2010 14:16:15 +0200")
Message-ID: <adaocdg3fng.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > What about such a solution:
 > 
 > just remove empty  CROSS_COMPILE  ?=
 > 
 > Fix CONFIG_CROSS_COMPILE issue in .config
 > 
 > Signed-off-by: Yegor Yefremov <yegorslists@googlemail.com>
 > 
 > Index: b/Makefile
 > ===================================================================
 > --- a/Makefile	2010-08-02 00:11:14.000000000 +0200
 > +++ b/Makefile	2010-08-04 14:08:51.000000000 +0200
 > @@ -189,7 +189,6 @@
 >  # Note: Some architectures assign CROSS_COMPILE in their arch/*/Makefile
 >  export KBUILD_BUILDHOST := $(SUBARCH)
 >  ARCH		?= $(SUBARCH)
 > -CROSS_COMPILE	?=
 >  CROSS_COMPILE	?= $(CONFIG_CROSS_COMPILE:"%"=%)

Yes, this make sense to me.  It's not clear to me why we ever needed
the conditional assignment of an empty CROSS_COMPILE (that code predates
the start of git history) but clearly having two "?=" assignments one
after another cannot work -- the second assignment to CROSS_COMPILE will
never do anything, since the line before makes CROSS_COMPILE defined.

 - R.
-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
