Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab2AILLg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 06:11:36 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:52407 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228Ab2AILLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 06:11:35 -0500
Date: Mon, 9 Jan 2012 11:11:28 +0000
From: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH][trace-cmd] blk plugin: replace BLK_TC_BARRIER with
 BLK_TC_FLUSH/BLK_TC_FUA
Message-ID: <20120109111128.GA9468@stefanha-thinkpad.localdomain>
References: <1326028761-25209-1-git-send-email-stefanha@linux.vnet.ibm.com>
 <874nw6xiqn.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874nw6xiqn.fsf@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12010911-4966-0000-0000-00000116C2C1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 01:27:12AM +0900, Namhyung Kim wrote:
> Stefan Hajnoczi <stefanha@linux.vnet.ibm.com> wrote:
> 
> > The BLK_TC_BARRIER flag was dropped in Linux commit c09c47caedc in
> > August 2011.  The blk plugin fails to build against recent kernel
> > headers.  Since no flag bits were left, the new BLK_TC_FLUSH flag reused
> > the BLK_TC_BARRIER bit.  The new BLK_TC_FUA flag was also added.
> >
> > This patch updates fill_rwbs() to reflect the new
> > BLK_TC_FLUSH/BLK_TC_FUA flags.  This allows plugin_blk.c to build
> > successfully on recent kernels.  The drawback is that this breaks the
> > build for pre-c09c47caedc kernel headers.
> >
> > Signed-off-by: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
> > ---
> > There is an alternative version of this patch with a build test in the Makefile
> > so that we know whether to use BLK_TC_BARRIER or BLK_TC_FLUSH/BLK_TC_FUA.  That
> > would support both old and new kernel headers using a HAVE_BLK_TC_FLUSH #ifdef.
> >
> > I wasn't able to find the right makefile shell escaping magic to get the
> > build-test function to work.  If anyone knows how to test a snippet like the
> > following, then that would be nicer:
> >
> >   #include <linux/blktrace_api.h>
> >   int main(void) { return BLK_TC_FLUSH; }
> >
> 
> Hi,
> 
> The perf uses following code for that:
> 
> # try-cc
> # Usage: option = $(call try-cc, source-to-build, cc-options)
> try-cc = $(shell sh -c						  \
> 	'TMP="$(OUTPUT)$(TMPOUT).$$$$";				  \
> 	 echo "$(1)" |						  \
> 	 $(CC) -x c - $(2) -o "$$TMP" > /dev/null 2>&1 && echo y; \
> 	 rm -f "$$TMP"')

Looks perfect, thanks!

Stefan

