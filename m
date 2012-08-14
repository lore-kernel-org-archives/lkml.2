Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286Ab2HNSgF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 14:36:05 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:53728 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754258Ab2HNSgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 14:36:02 -0400
Date: Tue, 14 Aug 2012 22:35:58 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>
Subject: Re: [patch 3/8] procfs: Add ability to plug in auxiliary fdinfo
 providers
Message-ID: <20120814183558.GA1551@moon>
References: <20120814140342.354405844@openvz.org>
 <20120814140620.033884909@openvz.org>
 <20120814183142.GH23464@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120814183142.GH23464@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 07:31:42PM +0100, Al Viro wrote:
> > Initially we considered to inject some "show" metod to
> > file_operations but since there really a number of
> > file_operations declared inside kernel (and in real the
> > further patches cover onle eventfd/epoll/inotify) the
> > waste of memory space will be inacceptable I think.
> 
> NAK.  This is too ugly to live.  Put it into file_operations,
> with NULL meaning default output, or don't do it at all.
> 
> And no, "it's only if you enable CONFIG_SOME_SHIT" gambit won't
> fly - we have all seen it played too many times.  All it takes
> is one politically-inclined induhvidual adding a dependency to
> some "vertically integrated" turd (*cough* systemd *spit* udev
> *cough*) and we are stuck with the damn thing.  CGROUP shite
> is already there, DEVTMPFS is well on its way, etc.

OK, I'll put it into file_operations then (actually Pavel was
proposing the same but I've been scared by amount of file_operations
declared). Thanks!

	Cyrill
