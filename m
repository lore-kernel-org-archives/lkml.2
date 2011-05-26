Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184Ab1EZRy3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 13:54:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54418 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753523Ab1EZRy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 13:54:28 -0400
MIME-Version: 1.0
In-Reply-To: <4DDE2873.7060409@jp.fujitsu.com>
References: <4DDE2873.7060409@jp.fujitsu.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 26 May 2011 10:53:34 -0700
Message-ID: <BANLkTi=znC18PAbpDfeVO+=Pat_EeXddjw@mail.gmail.com>
Subject: Re: [PATCH] mm: don't access vm_flags as 'int'
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: benh@kernel.crashing.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        hughd@google.com, akpm@linux-foundation.org, dave@linux.vnet.ibm.com,
        kamezawa.hiroyu@jp.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/26 KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>:
> The type of vma->vm_flags is 'unsigned long'. Neither 'int' nor
> 'unsigned int'. This patch fixes such misuse.

I applied this, except I also just made the executive decision to
replace things with "vm_flags_t" after all.

Which leaves a lot of "unsigned long" users that aren't converted, but
right now it doesn't matter, and it can be converted piecemeal as
people notice users..

                   Linus
