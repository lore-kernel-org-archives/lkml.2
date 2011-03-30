Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522Ab1C3Nvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 09:51:39 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:50680 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804Ab1C3Nvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 09:51:38 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jaxboe@fusionio.com,
        paulmck@linux.vnet.ibm.com, oleg@redhat.com
Subject: Re: [PATCH] blk-throttle: don't call xchg on bool
References: <1292447255-10698-1-git-send-email-vgoyal@redhat.com>
	<1292447255-10698-3-git-send-email-vgoyal@redhat.com>
	<m21v1ph639.fsf_-_@igel.home> <20110330131936.GA1291@redhat.com>
X-Yow: Now, I think it would be GOOD to buy FIVE or SIX STUDEBAKERS
 and CRUISE for ARTIFICIAL FLAVORING!!
Date: Wed, 30 Mar 2011 15:51:34 +0200
In-Reply-To: <20110330131936.GA1291@redhat.com> (Vivek Goyal's message of
	"Wed, 30 Mar 2011 09:19:36 -0400")
Message-ID: <m3vcz0ra1l.fsf@linux-m68k.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> Which arch creates the problem and what's the issue here if data type
> is smaller than 32bit?

Just look at the various implementations in arch/*/include/asm/system.h:

- arm: supports only one and 4 byte xchg
- avr32: supports only 4 byte xchg
- frv: supports only 4 byte xchg
- m32r: SMP supports only 4 byte xchg
- microblaze: supports only one and 4 byte xchg

etc.

> Is it a compile time warning?

Most implementations turn the use of xchg with a bad pointer into a link
error.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
