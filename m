Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796Ab0CZUR4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 16:17:56 -0400
Received: from c60.cesmail.net ([216.154.195.49]:21847 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792Ab0CZURz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 16:17:55 -0400
Subject: Re: [git patches] libata fixes
From: Pavel Roskin <proski@gnu.org>
To: Tejun Heo <tj@kernel.org>
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4BAB8D76.5040104@kernel.org>
References: <20100323134226.GA14752@havoc.gtf.org>
	 <1269367619.13592.12.camel@mj>  <4BAB8D76.5040104@kernel.org>
Content-Type: text/plain
Date: Fri, 26 Mar 2010 16:17:52 -0400
Message-Id: <1269634672.8534.2.camel@mj>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-26 at 01:21 +0900, Tejun Heo wrote:
> On 03/24/2010 03:06 AM, Pavel Roskin wrote:
> > By all means, please push this patch to all stable kernels, or more
> > money will be wasted on hard drives ;-)
> 
> Oh, the original patch which caused the problem never saw the light of
> the day before 2.6.34-rc1 so there's no stable kernel to push the
> patch into.

It looks like I'm still getting "clearing spurious IRQ".  In most cases,
it's not followed by anything, but in one case, there was a lost
interrupt followed by a link reset.

[ 5030.881191] ata2: clearing spurious IRQ
[ 5060.950036] ata2: lost interrupt (Status 0x50)
[ 5060.950055] ata2.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
frozen
[ 5060.950059] ata2.01: failed command: WRITE DMA
[ 5060.950066] ata2.01: cmd ca/00:08:b7:11:a9/00:00:00:00:00/f0 tag 0
dma 4096 out
[ 5060.950068]          res 40/00:00:00:4f:c2/00:00:00:00:00/10 Emask
0x4 (timeout)
[ 5060.950071] ata2.01: status: { DRDY }
[ 5060.950080] ata2: soft resetting link
[ 5061.160268] ata2.01: configured for UDMA/133
[ 5061.160275] ata2.01: device reported invalid CHS sector 0
[ 5061.160283] ata2: EH complete
[80540.010652] ata2: clearing spurious IRQ

That last line is apparently a separate event.

-- 
Regards,
Pavel Roskin
