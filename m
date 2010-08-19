Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab0HSMXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 08:23:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35773 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab0HSMXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 08:23:13 -0400
From: Andi Kleen <andi@firstfloor.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] introduce ptr_diff()
References: <1282217856-8625-1-git-send-email-namhyung@gmail.com>
Date: Thu, 19 Aug 2010 14:23:09 +0200
In-Reply-To: <1282217856-8625-1-git-send-email-namhyung@gmail.com> (Namhyung
	Kim's message of "Thu, 19 Aug 2010 20:37:36 +0900")
Message-ID: <87aaoiu6z6.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namhyung Kim <namhyung@gmail.com> writes:

> When I compiled allyesconfig'ed kernel with C=1, I got 1519 lines of
> following message:
>
>  include/linux/mm.h:599:16: warning: potentially expensive pointer subtraction
>
> which is around 10% of total warnings. this was caused by page_to_pfn() macro
> so I think it's worth to remove it by calculating pointer subtraction
> manually.

IMHO it would be better to simply disable the warning in sparse instead
of uglying the code just to work around sparse bogosity. It doesnt' seem
to make much sense. A subtraction followed by a shift is not expensive.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
