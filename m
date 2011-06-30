Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab1F3HJq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 03:09:46 -0400
Received: from gate.crashing.org ([63.228.1.57]:47520 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888Ab1F3HJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 03:09:38 -0400
Subject: Re: linux-next: build failure after merge of the final tree
 (powerpc tree related)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110630163659.374db7f9.sfr@canb.auug.org.au>
References: <20110630163659.374db7f9.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Jun 2011 17:09:21 +1000
Message-ID: <1309417761.14501.206.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-30 at 16:36 +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/tty/hvc/hvsi.c:701:12: error: conflicting types for 'hvsi_put_chars'
> arch/powerpc/include/asm/hvsi.h:92:12: note: previous declaration of 'hvsi_put_chars' was here
> drivers/tty/hvc/hvsi.c:736:12: error: conflicting types for 'hvsi_open'
> arch/powerpc/include/asm/hvsi.h:86:12: note: previous declaration of 'hvsi_open' was here
> drivers/tty/hvc/hvsi.c:802:13: error: conflicting types for 'hvsi_close'
> arch/powerpc/include/asm/hvsi.h:87:13: note: previous declaration of 'hvsi_close' was here
> drivers/tty/hvc/hvsi.c:1083:19: error: conflicting types for 'hvsi_init'
> arch/powerpc/include/asm/hvsi.h:81:13: note: previous declaration of 'hvsi_init' was here
> 
> Caused by commit 17bdc6c0e979 ("powerpc/pseries: Move hvsi support into a
> library").
> 
> I have reverted that commit for today.

Ooops, that seems to be entirely my fault, not sure what happened, I
might have merged the wrong patch version (I had some problem locally
with screwing up the git repo where those patches were originally).

I'll push a fix tomorrow.

Cheers,
Ben.


