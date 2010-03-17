Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab0CQJTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 05:19:07 -0400
Received: from mail2.shareable.org ([80.68.89.115]:38259 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818Ab0CQJTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 05:19:05 -0400
Date: Wed, 17 Mar 2010 09:18:20 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ulrich Drepper <drepper@redhat.com>, munroesj@us.ibm.com,
       "H. Peter Anvin" <hpa@zytor.com>, David Miller <davem@davemloft.net>,
       ralf@linux-mips.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel@teksavvy.com,
       torvalds@linux-foundation.org
Subject: Re: 64-syscall args on 32-bit vs syscall()
Message-ID: <20100317091820.GA8149@shareable.org>
References: <20100315134449.GB1653@linux-mips.org> <4B9E4EB1.9010800@zytor.com> <4B9E59B7.6060405@redhat.com> <20100315.120004.209998642.davem@davemloft.net> <4B9E8D67.8040209@zytor.com> <1268685311.2335.38.camel@pasglop> <1268776570.19726.98.camel@spokane1.rchland.ibm.com> <1268785874.2335.137.camel@pasglop> <4BA06E1B.2040706@redhat.com> <1268816179.2335.187.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268816179.2335.187.camel@pasglop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> Hence, apps that use the first form today because it works on x86 would
> end up working at least on powerpc where they would have been otherwise
> broken unless they used some arch specific #ifdef to do the second form.

I think what Ulrich is getting at is your change will break existing
code which already does:

#ifdef __powerpc__
	syscall(SYS_foo, 0, my_64bit_arg);
#else
	syscall(SYS_foo, my_64bit_arg);
#endif

I don't know of any such code, but it might be out there.

-- Jamie
