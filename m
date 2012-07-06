Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337Ab2GFJVp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 05:21:45 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:51101 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755599Ab2GFJVP convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Fri, 6 Jul 2012 05:21:15 -0400
Message-Id: <4FF6BDFB020000780008DFEF@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 06 Jul 2012 09:29:15 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Olaf Hering" <olaf@aepfle.de>
Cc: <kexec@lists.infradead.org>, <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] incorrect layout of globals from head_64.S
 during kexec boot
References: <20120705210607.GA26908@aepfle.de>
In-Reply-To: <20120705210607.GA26908@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 05.07.12 at 23:06, Olaf Hering <olaf@aepfle.de> wrote:
> My question is: were to put additional debug to trace the copying of the
> data section to its final destination? Is this a task of kexec -l or
> does that happen during decompressing? I suspect the latter. This is the
> console output before the crash (the crash happens in 'movq %rax, %cr3'):
> 
> ...
> [   44.072548] Starting new kernel
> I'm in purgatory
> early console in decompress_kernel
> 
> Decompressing Linux... Parsing ELF... done.

According to this, I'd first of all extend the printing done on
arch/x86/boot/compressed/misc.c:parse_elf(). One possible
problem (without much looking at how the individual address
ranges get determined) could be overlapping memory ranges
in the call to memcpy() inside the loop.

Jan

