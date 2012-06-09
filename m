Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787Ab2FIF0O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 01:26:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36495 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab2FIF0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 01:26:12 -0400
Date: Sat, 9 Jun 2012 06:26:10 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jan Kara <jack@suse.cz>
Cc: Eric Van Hensbergen <ericvh@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: seq_file dangerous assumption?
Message-ID: <20120609052610.GX30000@ZenIV.linux.org.uk>
References: <CAFkjPTkmgMY_TkUHvCmN0iQ9Hx4ADBVCLXGrQB8uMyoF0xMj0g@mail.gmail.com>
 <20120604200720.GI11010@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120604200720.GI11010@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2012 at 10:07:20PM +0200, Jan Kara wrote:

> Also we don't usually put magics into our data structure just to stop bad
> use of interfaces. I agree that in this particular case the interface is
> easy to get wrong - but that should be solved by changing the interface to
> a more robust one. Actually, I'm not sure if anyone actually passes
> ->private_data != NULL since seq_open_private() seems to be a standard way
> of associating some additional data with seq_file. So maybe
> BUG_ON(file->private_data) would be a good robustification of the interface
> :).

*cough* /proc/mounts *cough*

I've just thrown a cleanup of that shite into #for-next (and posted it
upthread).  The bottom line:
	* seq_open() is fine with ->private_data pointing to struct seq_file
embedded into something.
	* that's a supported use; just use container_of() to get to the
entire object by ->private_data (or similar container_of() by seq_file *
argument in seq_file methods).
