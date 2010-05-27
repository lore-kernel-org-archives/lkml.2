Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935091Ab0E0SiW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 14:38:22 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34032 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166Ab0E0SiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 14:38:21 -0400
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: personality(ADDR_LIMIT_3GB) results in EFAULT
From: Andi Kleen <andi@firstfloor.org>
References: <4BFEA911.40600@msgid.tls.msk.ru>
Date: Thu, 27 May 2010 20:38:19 +0200
In-Reply-To: <4BFEA911.40600@msgid.tls.msk.ru> (Michael Tokarev's message of "Thu\, 27 May 2010 21\:17\:05 +0400")
Message-ID: <874oht197o.fsf@basil.nowhere.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev <mjt@tls.msk.ru> writes:

> I noticed an.. interesting issue here.
>
> Running a 32bit executable on a 64bit kernel,
> and doing
>
>   personality(ADDR_LIMIT_3GB);
>
> That call succedes, but any further execve()
> and friends results in EFAULT, unless whole
> argv[] and envp[] are copied to a malloc'ed
> space.  alloca sometimes helps and sometimes
> not.

It worked when I wrote it originally.

Sounds like a regression, perhaps related to
b6a2fea39318e43fee84fa7b0b90d68bed92d2ba


-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
