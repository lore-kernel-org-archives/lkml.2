Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269Ab1EZSu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:50:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37199 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932833Ab1EZSuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:50:25 -0400
MIME-Version: 1.0
In-Reply-To: <20110526184402.GA2453@p183.telecom.by>
References: <4DDE2873.7060409@jp.fujitsu.com> <BANLkTi=znC18PAbpDfeVO+=Pat_EeXddjw@mail.gmail.com>
 <20110526184402.GA2453@p183.telecom.by>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 26 May 2011 11:49:59 -0700
Message-ID: <BANLkTi=Z=AoEH_AyN370jiUq7Qm1RhM0gQ@mail.gmail.com>
Subject: Re: [PATCH] mm: don't access vm_flags as 'int'
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, benh@kernel.crashing.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, hughd@google.com,
        akpm@linux-foundation.org, dave@linux.vnet.ibm.com,
        kamezawa.hiroyu@jp.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 11:44 AM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
>
> Woo-hoo!
>
> Why it is marked __nocast and not __bitwise__ like gfp_t?

Because that's what one of the other patches in Andrew's series had,
so I just emulated that.

Also, I don't think we can currently mark it __bitwise without causing
a sh*tload of sparse warnings. __nocast is much weaker than bitwise
(it only warns about implicit casts to different sizes). __bitwise
implies a lot more type-checking, and actually makes the result a very
specific type.

I'm not sure it is worth the __bitwise pain. If we go down the
__bitwise path, we'd need to mark all the VM_XYZZY constants with the
type, and we'd need to do *all* the conversions in one go. I am
definitely not ready to do that at this stage, but I was willing to
take the much weaker __nocast.

                    Linus
