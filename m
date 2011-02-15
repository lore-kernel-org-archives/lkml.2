Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963Ab1BOFjp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 00:39:45 -0500
Received: from 1wt.eu ([62.212.114.60]:60547 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224Ab1BOFjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 00:39:42 -0500
Date: Tue, 15 Feb 2011 06:39:22 +0100
From: Willy Tarreau <w@1wt.eu>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        Slava Pestov <slavapestov@google.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [Stable-review] [PATCH 20/23] tracing: Fix panic when lseek() called on "trace" opened for writing
Message-ID: <20110215053922.GB17278@1wt.eu>
References: <20110206232253.378726212@pcw.home.local> <1297725267.3104.84.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297725267.3104.84.camel@localhost>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Mon, Feb 14, 2011 at 11:14:27PM +0000, Ben Hutchings wrote:
> On Mon, 2011-02-07 at 00:23 +0100, Willy Tarreau wrote:
> > 2.6.27.58-stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > 
> > From: Slava Pestov <slavapestov@google.com>
> > 
> > commit 364829b1263b44aa60383824e4c1289d83d78ca7 upstream.
> > 
> > The file_ops struct for the "trace" special file defined llseek as seq_lseek().
> > However, if the file was opened for writing only, seq_open() was not called,
> > and the seek would dereference a null pointer, file->private_data.
> > 
> > This patch introduces a new wrapper for seq_lseek() which checks if the file
> > descriptor is opened for reading first. If not, it does nothing.
> [...]
> > --- longterm-2.6.27.orig/kernel/trace/trace.c	2011-01-23 10:52:37.000000000 +0100
> > +++ longterm-2.6.27/kernel/trace/trace.c	2011-01-29 11:42:07.287067215 +0100
> > @@ -2041,17 +2041,25 @@
> >  	return ret;
> >  }
> >  
> > +static loff_t tracing_seek(struct file *file, loff_t offset, int origin)
> [...]
> > +	.llseek		= tracing_lseek,
> [...]
> > +	.llseek		= tracing_lseek,
> [...]
> 
> These names don't agree!

Indeed, it's been fixed before releasing.
Thanks for the review anyway !

Willy

