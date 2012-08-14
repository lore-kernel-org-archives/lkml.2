Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960Ab2HNV4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 17:56:22 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:33216 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750758Ab2HNV4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 17:56:21 -0400
Date: Wed, 15 Aug 2012 01:56:16 +0400
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
Message-ID: <20120814215616.GC31043@moon>
References: <20120814140342.354405844@openvz.org>
 <20120814140620.033884909@openvz.org>
 <20120814183142.GH23464@ZenIV.linux.org.uk>
 <20120814183558.GA1551@moon>
 <20120814195649.GB31043@moon>
 <20120814212721.GJ23464@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120814212721.GJ23464@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 10:27:21PM +0100, Al Viro wrote:
> On Tue, Aug 14, 2012 at 11:56:49PM +0400, Cyrill Gorcunov wrote:
> > Al, does the patch below looks better? If so I'll fix up the rest.
> 
> >  struct file_operations {
> >  	struct module *owner;
> > +	struct seq_operations *fdinfo_ops;
> 
> IDGI.  Why on the earth do you need the whole iterator?  All it takes
> is show_fdinfo(struct seq_file *m, struct file *f); have ->show() in
> your iterator (one going through the files) call that sucker for the
> file we are trying to show.
> 
> I think you are severely overdesigning that thing...

Hmm, in very first versions I've been using one ->show method, but
then I thought that this is not very correlate with seq-files idea
where for each record show/next sequence is called. I'll update (this
for sure will make code simplier, and I'll have to check for seq-file
overflow after seq_printf call to not continue printing data for too
long if buffer already out of space).

	Cyrill
