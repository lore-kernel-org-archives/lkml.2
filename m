Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424917Ab2LFVhO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 16:37:14 -0500
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:36377 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424897Ab2LFVhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 16:37:11 -0500
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: At9NAMMPwVBV5qjOPGdsb2JhbABEim6zQBcDAQEBATg0gh4BAQQBOhwjBQsIA0YUJQoaiB0KwmsUjEiDP2EDlgKFe4NTiW4
X-IronPort-AV: E=Sophos;i="4.84,233,1355094000"; 
   d="scan'208";a="462904698"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 6 Dec 2012 22:39:09 +0100
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Jan Kara <jack@suse.cz>,
        linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Oops in 3.7-rc8 isolate_free_pages_block()
Message-ID: <20121206213909.GA625@polaris.bitmath.org>
References: <20121206091744.GA1397@polaris.bitmath.org>
 <20121206144821.GC18547@quack.suse.cz>
 <20121206161934.GA17258@suse.de>
 <CA+55aFw9WQN-MYFKzoGXF9Z70h1XsMu5X4hLy0GPJopBVuE=Yg@mail.gmail.com>
 <20121206175451.GC17258@suse.de>
 <CA+55aFwDZHXf2FkWugCy4DF+mPTjxvjZH87ydhE5cuFFcJ-dJg@mail.gmail.com>
 <20121206183259.GA591@polaris.bitmath.org>
 <CA+55aFzievpA_b5p-bXwW11a89eC-ucpzKUuSqb2PNQOLrqaPg@mail.gmail.com>
 <20121206192845.GA599@polaris.bitmath.org>
 <CA+55aFy4Lv+_aPEakOJNR2F9PR=09jviT6Z70_NkWV5bSH5ABw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy4Lv+_aPEakOJNR2F9PR=09jviT6Z70_NkWV5bSH5ABw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There is also a
> 
>     low_pfn += pageblock_nr_pages;
>     low_pfn = ALIGN(low_pfn, pageblock_nr_pages) - 1;
> 
> that looks suspicious for similar reasons. Maybe
> 
>     low_pfn = ALIGN(low_pfn + 1, pageblock_nr_pages) - 1;
> 
> instead? Although that *can* result in the same low_pfn in the end, so
> maybe that one was correct after all? I just did some grepping, no
> actual semantic analysis...

Here is a totally obscure version:

	low_pfn |= pageblock_nr_pages - 1;

It simply moves to the very end of the block, which seems to be what
was intended.

Henrik
