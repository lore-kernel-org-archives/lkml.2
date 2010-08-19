Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128Ab0HSMkV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 08:40:21 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:60531 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab0HSMkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 08:40:19 -0400
Date: Thu, 19 Aug 2010 06:40:17 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Andi Kleen <andi@firstfloor.org>
Cc: Namhyung Kim <namhyung@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] introduce ptr_diff()
Message-ID: <20100819124017.GI12892@parisc-linux.org>
References: <1282217856-8625-1-git-send-email-namhyung@gmail.com> <87aaoiu6z6.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87aaoiu6z6.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 02:23:09PM +0200, Andi Kleen wrote:
> IMHO it would be better to simply disable the warning in sparse instead
> of uglying the code just to work around sparse bogosity. It doesnt' seem
> to make much sense. A subtraction followed by a shift is not expensive.

What makes you think it's a shift?  struct page isn't necessarily a
power of two in size.  The original poster said "allyesconfig" which is
going to add in KMEMCHECK and WANT_PAGE_DEBUG_FLAGS.  I think that makes
it 76 bytes on x86-32, so sparse is right to warn.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
