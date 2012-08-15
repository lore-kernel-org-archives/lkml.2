Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924Ab2HOAHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 20:07:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33382 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288Ab2HOAHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 20:07:06 -0400
Date: Wed, 15 Aug 2012 01:07:03 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>
Subject: Re: [patch 3/8] procfs: Add ability to plug in auxiliary fdinfo
 providers
Message-ID: <20120815000703.GL23464@ZenIV.linux.org.uk>
References: <20120814140342.354405844@openvz.org>
 <20120814140620.033884909@openvz.org>
 <20120814183142.GH23464@ZenIV.linux.org.uk>
 <20120814183558.GA1551@moon>
 <20120814195649.GB31043@moon>
 <20120814212721.GJ23464@ZenIV.linux.org.uk>
 <20120814215616.GC31043@moon>
 <20120814222147.GA21674@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120814222147.GA21674@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 02:21:47AM +0400, Cyrill Gorcunov wrote:
> > Hmm, in very first versions I've been using one ->show method, but
> > then I thought that this is not very correlate with seq-files idea
> > where for each record show/next sequence is called. I'll update (this
> > for sure will make code simplier, and I'll have to check for seq-file
> > overflow after seq_printf call to not continue printing data for too
> > long if buffer already out of space).
> 
> Al, I'll cook the whole series tomorrow and resend it for review,
> also I guess the new show_fdinfo() member in file-operations should
> be guarded with CONFIG_PROC_FS, right?

I seriously doubt that it's worth bothering.  If somebody cares, they
can add making it conditional later.
