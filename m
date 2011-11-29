Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab1K2Jyv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 04:54:51 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:41078 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753026Ab1K2Jys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 04:54:48 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Artem Bityutskiy <dedekind1@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the l2-mtd tree
References: <20111129143358.0859ae27c22f2c752a608f65@canb.auug.org.au>
X-URL: http://belgarath.falguerolles.org/
Date: Tue, 29 Nov 2011 10:54:37 +0100
In-Reply-To: <20111129143358.0859ae27c22f2c752a608f65@canb.auug.org.au>
	(Stephen Rothwell's message of "Tue, 29 Nov 2011 14:33:58 +1100")
Message-ID: <878vmz8d9e.fsf@free.fr>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:
> After merging the l2-mtd tree, today's linux-next build (x86_64
> allmodconfig) produced this warning:
>
> drivers/mtd/devices/docg3.c: In function 'doc_write_page_ecc_init':
> drivers/mtd/devices/docg3.c:577:6: warning: suggest parentheses around operand
> of '!' or change '|' to '||' or '!' to '~' [-Wparentheses]

Hi Stephen,

My fault, I've been too lazy with that commit for too long, and code like
writel(!reg1 | reg2, adr) is error prone. Artem did point out the warning
already, so that's on me.

I'll mend the fix in a V2 to a cleanup patch already submitted to linux-mtd.

Cheers.

-- 
Robert

PS: there will be another warning about an unused function
doc_get_erase_count(). This one will be fixed a bit later I'm afraid.
