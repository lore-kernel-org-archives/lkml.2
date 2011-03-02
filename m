Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175Ab1CBTjm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 14:39:42 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39938
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756515Ab1CBTjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 14:39:41 -0500
Date: Wed, 02 Mar 2011 11:40:18 -0800 (PST)
Message-Id: <20110302.114018.104077586.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: oleg@redhat.com, akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, pageexec@freemail.hu,
        solar@openwall.com, eteo@redhat.com, spender@grsecurity.net,
        roland@redhat.com, miltonm@bga.com
Subject: Re: [PATCH v3 0/4] exec: unify native/compat code
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTinzQmprg+XHKjTj7bA+jFf_N4hta3_09M+SEfRt@mail.gmail.com>
References: <20110302162650.GA26810@redhat.com>
	<20110302164428.GF26810@redhat.com>
	<AANLkTinzQmprg+XHKjTj7bA+jFf_N4hta3_09M+SEfRt@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 2 Mar 2011 10:00:23 -0800

> No, I think we're ok with passing the structure by value - it's a
> small structure that would generally be passed in registers (at least
> on some architectures, I guess it will depend on the ABI), and we do
> the "struct-by-value" thing for other things too (notably the page
> table entries), so it's not a new thing in the kernel.

We purposely don't do that "page table entry typedef'd to aggregate" stuff
on sparc32 because otherwise such values get passed on the stack.

Architectures can currently avoid this bad code generation for the
page table case, but with this new code they won't be able to avoid
pass-by-value.
