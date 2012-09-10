Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab2IJOqp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 10:46:45 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:60516 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533Ab2IJOqm convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Mon, 10 Sep 2012 10:46:42 -0400
Message-Id: <504E196C020000780009A3F9@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 10 Sep 2012 15:46:36 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] x86/xor: improve XMM register spill/fill
References: <504DFB5B020000780009A327@nat28.tlf.novell.com>
 <504DF3BC.30708@zytor.com>
In-Reply-To: <504DF3BC.30708@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 10.09.12 at 16:05, "H. Peter Anvin" <hpa@zytor.com> wrote:
> On 09/10/2012 05:38 AM, Jan Beulich wrote:
>> +/*
>> + * By forcing the alignment beyond the default of 16 bytes, we make the
>> + * compiler guarantee the alignment. Passing -mincoming-stack-boundary=3
>> + * (which would have been the better global alternative, as the kernel
>> + * never guarantees better stack alignment) isn't permitted on x86-64.
>> + */
> 
> The very latest gcc should handle it, and in fact we compile with 
> -mstack-alignment=3 if gcc accepts it (if it is not yet upstream it will 
> be soon.)  This affects the validity of this patch.

The comment would be stale with that, but the code should still
be fine - it would merely over-align the stack in that case (to
32 bytes when 16 would suffice). Or did you spot something else
that I'm missing?

Also, I can't spot any use of -mstack-alignment= in today's tip's
arch/x86/Makefile* - where's that hidden?

Jan

