Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627Ab1BOBdh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 20:33:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40946 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab1BOBdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 20:33:35 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=M7KJ_pm0K9UA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1XWaLZrsAAAA:8 a=iSmfwXa-FYafOWYyttsA:9 a=T-tk81qHWHqwpdr75khJgU-Db_oA:4 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [Stable-review] [PATCH 20/23] tracing: Fix panic when lseek()
 called on "trace" opened for writing
From: Steven Rostedt <rostedt@goodmis.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org, stable@kernel.org,
        stable-review@kernel.org, Slava Pestov <slavapestov@google.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <1297725267.3104.84.camel@localhost>
References: <20110206232253.378726212@pcw.home.local>
	 <1297725267.3104.84.camel@localhost>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 14 Feb 2011 20:33:33 -0500
Message-ID: <1297733613.23343.92.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-14 at 23:14 +0000, Ben Hutchings wrote:
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

What don't they agree on?

-- Steve


