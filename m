Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867Ab0LMVMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 16:12:32 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:20843 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab0LMVMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 16:12:31 -0500
Date: Mon, 13 Dec 2010 22:06:08 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Hank Janssen <hjanssen@microsoft.com>
cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Evgeniy Polyakov <zbr@ioremap.net>,
        Ky Srinivasan <ksrinivasan@novell.com>
Subject: RE: [PATCH 1/1] hv: Use only one receive buffer per channel and
 kmalloc on initialize
In-Reply-To: <8AFC7968D54FB448A30D8F38F259C5622C0BCB78@TK5EX14MBXC116.redmond.corp.microsoft.com>
Message-ID: <alpine.LNX.2.00.1012132204240.26491@swampdragon.chaosbits.net>
References: <1292272498-29483-1-git-send-email-hjanssen@microsoft.com> <alpine.LNX.2.00.1012132143590.26491@swampdragon.chaosbits.net> <8AFC7968D54FB448A30D8F38F259C5622C0BCB78@TK5EX14MBXC116.redmond.corp.microsoft.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Dec 2010, Hank Janssen wrote:

> 
> 
> > -----Original Message-----
> > From: Jesper Juhl [mailto:jj@chaosbits.net]
> > Sent: Monday, December 13, 2010 12:48 PM
> > You are leaking memory in the failure path. If for example one or two
> > allocations succeed but one or two fail, then you'll leak the two successful
> > allocations.
> > 
> > I believe this should be
> > 
> >      if (!shut_txf_buf || !time_txf_buf || !hbeat_txf_buf) {
> >              printk(KERN_INFO
> >                     "Unable to allocate memory for receive buffer\n");
> >              kfree(hbeat_txf_buf);
> >              kfree(time_txf_buf);
> >              kfree(shut_txf_buf);
> >              return -ENOMEM;
> > ...
> > 
>  
> Oops, you are correct. Resubmitting the patch in a few minutes.
> 
Ohh and another little detail; shouldn't this log message be a 
KERN_WARNING level message?
And perhaps the log text should include "HyperV" or something so it's 
clear where it comes from..?

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

