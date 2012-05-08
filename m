Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab2EHTLW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 15:11:22 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47770 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585Ab2EHTLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 15:11:21 -0400
Subject: Re: [PATCH] mm: sl[auo]b: Use atomic bit operations to update
 page-flags.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Pravin B Shelar <pshelar@nicira.com>
Cc: cl@linux.com, penberg@kernel.org, mpm@selenic.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, jesse@nicira.com,
        abhide@nicira.com
In-Reply-To: <1336503339-18722-1-git-send-email-pshelar@nicira.com>
References: <1336503339-18722-1-git-send-email-pshelar@nicira.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 May 2012 21:11:16 +0200
Message-ID: <1336504276.3752.2600.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-08 at 11:55 -0700, Pravin B Shelar wrote:
> Transparent huge pages can change page->flags (PG_compound_lock)
> without taking Slab lock. So sl[auo]b need to use atomic bit
> operation while changing page->flags.
> Specificly this patch fixes race between compound_unlock and slab
> functions which does page-flags update. This can occur when
> get_page/put_page is called on page from slab object.


But should get_page()/put_page() be called on a page own by slub ?


