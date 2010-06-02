Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933005Ab0FBTUw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 15:20:52 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:10667 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932976Ab0FBTUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 15:20:50 -0400
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAI9LBkyrR7Ht/2dsb2JhbACeH3GnPJonhRYEg0g
X-IronPort-AV: E=Sophos;i="4.53,348,1272844800"; 
   d="scan'208";a="206108663"
From: Roland Dreier <rdreier@cisco.com>
To: Dan Carpenter <error27@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [announce] smatch 1.54
References: <20100109085325.GE7840@bicker>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 02 Jun 2010 12:20:46 -0700
In-Reply-To: <20100109085325.GE7840@bicker> (Dan Carpenter's message of "Sat,
	9 Jan 2010 11:53:25 +0300")
Message-ID: <adahblls0kx.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

I'm trying out smatch on some kernel code now.  Neat stuff, but I'm
seeing some puzzling false positives relating to signedness.  Basically,
if I have code like:

	__be16 foo;
	__u16 bar;

	foo = cpu_to_be16(128);
	bar = cpu_to_be16(128);

then the first line warns about 32768 not fitting into foo, but while
the second line doesn't warn, even though __be16 is just a __bitwise__
__u16.  I don't understand the sparse / smatch internals so I'm not sure
why applying __bitwise__ apparently kills the unsigned modifier.  Maybe
it's an easy fix for you?  Otherwise I'll poke at it a little later.

Thanks,
  Roland
-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
