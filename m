Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783Ab0HTM5w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 08:57:52 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35273 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab0HTM5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 08:57:50 -0400
Date: Fri, 20 Aug 2010 14:57:45 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Andi Kleen <andi@firstfloor.org>,
        Namhyung Kim <namhyung@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] introduce ptr_diff()
Message-ID: <20100820125745.GA1771@one.firstfloor.org>
References: <1282217856-8625-1-git-send-email-namhyung@gmail.com> <87aaoiu6z6.fsf@basil.nowhere.org> <20100820120737.GS31363@ZenIV.linux.org.uk> <20100820124958.GJ12892@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100820124958.GJ12892@parisc-linux.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm not sure the price is so high.  I googled around and came across
> http://mdfs.net/Docs/Comp/ARM/Cookbook/cook3 (section 3.3).  Dividing by
> 2^n, (2^n + 2^m) or (2^n - 2^m) can be done using a small series of adds
> and subtractions (important on ARM as it had no divide instruction at
> the time).  Most structures are going to be of one of these sizes ...
> and in particular, struct page is 56 bytes in my config, which is 64 - 8.
> Maybe sparse needs to be taught that dividing by 2^n [+-] 2^m is cheap
> enough to not warn about.

Usually you can just use x/n = x*(1/n) and generate *(1/n) with 1/n 
being computed at compile time. Multiplications are fast in hardware.

gcc only does that when -Os is not set though (friends don't let friends
compile with -Os...)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
