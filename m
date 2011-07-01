Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956Ab1GAWnb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 18:43:31 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:56837 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757598Ab1GAWna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 18:43:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=WK/ezSrHZ0hfLErDtE0hvH3Sfqce7pqR6j1C62YWxf//MFhKHufjokI4k/RuhJtejABWkW1MiF7ReCY7YUMyFPCp6T+YRj3tQgUgqZkX3pkqONKgYkz5YoqUrkAS+j0E;
Date: Fri, 1 Jul 2011 15:43:27 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh <greg@kroah.com>,
        driverdevel <devel@driverdev.osuosl.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>
Subject: Re: linux-next: Tree for July 1 (staging/comedi)
Message-Id: <20110701154327.69c5b852.rdunlap@xenotime.net>
In-Reply-To: <20110701160523.5626201d.sfr@canb.auug.org.au>
References: <20110701160523.5626201d.sfr@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jul 2011 16:05:23 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20110630:


drivers/staging/comedi/drivers/ni_labpc.c: In function 'labpc_common_attach':
drivers/staging/comedi/drivers/ni_labpc.c:602: error: implicit declaration of function 'request_dma'
drivers/staging/comedi/drivers/ni_labpc.c:608: error: implicit declaration of function 'claim_dma_lock'
drivers/staging/comedi/drivers/ni_labpc.c:611: error: implicit declaration of function 'release_dma_lock'
drivers/staging/comedi/drivers/ni_labpc.c: In function 'labpc_common_detach':
drivers/staging/comedi/drivers/ni_labpc.c:803: error: implicit declaration of function 'free_dma'


on x86_64 when CONFIG_ISA_DMA_API is not enabled.

Since that driver handles both ISA and PCI devices,
and the PCI parts are conditional, I guess that the ISA parts also
need to be made conditional.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
