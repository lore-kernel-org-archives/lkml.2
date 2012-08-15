Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536Ab2HOVe5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 17:34:57 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40178 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757486Ab2HOVex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 17:34:53 -0400
Date: Thu, 16 Aug 2012 01:34:49 +0400
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
Message-ID: <20120815213449.GQ23657@moon>
References: <20120815092116.700948346@openvz.org>
 <20120815092409.507162379@openvz.org>
 <20120815212927.GO23464@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120815212927.GO23464@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 10:29:27PM +0100, Al Viro wrote:
> 
> This, BTW, is too convoluted for its own good.  What you need is
> something like
> struct whatever {
> 	struct seq_file *m;
> 	struct file *f;
> 	int flags;
> };
> with single allocation of that sucker in your ->open().  Set
> file->private_data to address of seq_file field in your object *before*
> calling seq_open() and don't bother with m->private at all - just use
> container_of(m, struct whatever, m) in your ->show() to get to that
> structure...

I will try and post results, thanks!

	Cyrill
