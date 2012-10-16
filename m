Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab2JPPC7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 11:02:59 -0400
Received: from c60.cesmail.net ([216.154.195.49]:42439 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754745Ab2JPPC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 11:02:58 -0400
Date: Tue, 16 Oct 2012 11:02:54 -0400
From: Pavel Roskin <proski@gnu.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Bisected regression in Linux 3.7.0-rc1, hang on login caused by
 replace_fd()
Message-ID: <20121016110254.2f2df195@mj>
In-Reply-To: <20121015234853.GN2616@ZenIV.linux.org.uk>
References: <20121015171437.32e9a4ac@mj>
	<20121015215127.GK2616@ZenIV.linux.org.uk>
	<20121015191105.2dac4cac@mj>
	<20121015232705.GM2616@ZenIV.linux.org.uk>
	<20121015194008.29e38086@mj>
	<20121015234853.GN2616@ZenIV.linux.org.uk>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2012 00:48:53 +0100
Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Mon, Oct 15, 2012 at 07:40:08PM -0400, Pavel Roskin wrote:
> > On Tue, 16 Oct 2012 00:27:05 +0100
> > Al Viro <viro@ZenIV.linux.org.uk> wrote:
> > 
> > > 	I think I understand what's going on there.  Add
> > > fput(files[0]) after that replace_fd(); we have a leak and while
> > > that's not the right way to fix it, that'd verify if anything
> > > else is going on there.
> > 
> > Yes, it's working now!  No more hang on login!
> 
> That should be closer to the final variant.

It works me, thank you!  I don't use SELinux, so I could not really
test the second part.

-- 
Regards,
Pavel Roskin
