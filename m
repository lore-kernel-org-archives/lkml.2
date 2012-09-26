Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab2IZLQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 07:16:17 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:52714 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911Ab2IZLQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 07:16:15 -0400
Date: Wed, 26 Sep 2012 13:16:10 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: Tao Guo <glorioustao@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] x86_64: Work around old gas bug
Message-ID: <20120926111610.GB21143@gmail.com>
References: <1348648102-12653-1-git-send-email-glorioustao@gmail.com>
 <5062F267020000780009DF06@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5062F267020000780009DF06@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <JBeulich@suse.com> wrote:

> >>> On 26.09.12 at 10:28, Tao Guo <glorioustao@gmail.com> wrote:
> > gas in binutils(2.16.91) could not parse parentheses within macro
> > parameters unless fully parenthesized, and this is a workaround to
> > make old gas work without generating below errors:
> > arch/x86/kernel/entry_64.S: Assembler messages:
> > arch/x86/kernel/entry_64.S:387: Error: too many positional arguments
> > arch/x86/kernel/entry_64.S:389: Error: too many positional arguments
> > arch/x86/kernel/entry_64.S:390: Error: too many positional arguments
> > arch/x86/kernel/entry_64.S:391: Error: too many positional arguments
> > arch/x86/kernel/entry_64.S:392: Error: too many positional arguments
> > arch/x86/kernel/entry_64.S:393: Error: too many positional arguments
> > arch/x86/kernel/entry_64.S:394: Error: too many positional arguments
> > 
> > Signed-off-by: Tao Guo <glorioustao@gmail.com>
> 
> This looks okay now to me, but I'm somewhat reluctant to 
> formally ack it given that we know how broken those particular 
> gas versions are.

Well, assuming Tao Guo test-booted a kernel build with this old 
GAS version, we could apply this patch on a best-effort basis - 
the changes don't look particularly ugly. If other, unacceptable 
uglies or fragilities come up then we might balk.

Agreed?

Thanks,

	Ingo
