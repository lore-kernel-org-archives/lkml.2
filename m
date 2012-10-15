Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959Ab2JOWCq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 18:02:46 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:50427 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753902Ab2JOWCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 18:02:45 -0400
Date: Mon, 15 Oct 2012 17:02:20 -0500
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
Subject: Re: [PATCH] TPM: Let the tpm char device be openable multiple times
Message-ID: <20121015220220.GC30592@ennui.austin.ibm.com>
References: <20120930233345.GJ30637@obsidianresearch.com>
 <20121010163324.GB5013@ennui.austin.ibm.com>
 <20121012205658.GM4124@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121012205658.GM4124@obsidianresearch.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12101522-7182-0000-0000-000002D5BD9B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Using open/close is an interesting idea, but it wouldn't work. open()
> is coded to return EBUSY if another process has it open, rather than
> block, and spinning on open would be unacceptable.

  I'm trying to imagine when spinning would be unacceptable? Keygen
could take several seconds, regardless of whether you can get the
command to the chip right away or not...

> > around any use of the device node. That seems simple enough to me. In
> > places where you do want TSS to be the sole opener, it can't enforce
> > that rule itself, so I think we need to preserve the option of a single
> > open at a minimum.
> 
> I agree, but I'm not sure how to expose this function? I've seen other
> places abuse O_EXCL for this, but that would not be compatible with
> existing implementations.
> 
> Three things come to mind
>  - O_EXCL means the open only succeeds if it the only open and
>    prevents others (not compatible)
>  - Some other O_ flag is hijacked to mean the opposite of the above
>    (yuk)
>  - A sysfs flag is added to turn on the new O_EXCL behavior
> 
> What do you think?

  My first thought was a sysfs var to turn off exclusivity that
defaulted to today's behavior.

Kent

> Jason
> 

