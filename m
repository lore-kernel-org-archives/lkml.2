Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab1KBAAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 20:00:18 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61793 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756089Ab1KBAAP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 20:00:15 -0400
MIME-Version: 1.0
In-Reply-To: <20111101004542.GA18671@windriver.com>
References: <20111101004542.GA18671@windriver.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 1 Nov 2011 16:59:53 -0700
X-Google-Sender-Auth: 8bb4VPtLqQiYj9kdSGcoff-VjBQ
Message-ID: <CA+55aFz7dRWdQy_39+sCMeuqkavg8gYYyH_4u-n66OFVYzAWTg@mail.gmail.com>
Subject: Re: [GIT PULL] introduce export.h; reduce module.h usage
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: rusty@rustcorp.com.au, mingo@elte.hu, akpm@linux-foundation.org,
        sfr@canb.auug.org.au, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 31, 2011 at 5:45 PM, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:
>
> Please pull the below to get the module.h split content.  It has been
> tested on v3.1-rc6, soaked in linux-next, and re-tested again lots more
> today after rebasing it to allow most of the linux-next finds to be
> blended in, where they could not be on the original v3.1-rc6 baseline.

Does it bisect cleanly?

Quite frankly, for something fairly trivial like this where the upside
is mainly "slightly faster compile" (and hey, perhaps cleaner source
tree), the downsides needs to be minimized.  And just looking at the
shortlog makes me go: this will be a bisection disaster - people will
look for bugs, bisect will go into this series, and things won't
compile.

But maybe it's ordered so that the actual module.h split comes last,
exactly so that it would be safe and bisectable? I just don't know,
and I'd like to know before I pull..

                    Linus
