Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab2AHQ1U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 11:27:20 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52956 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab2AHQ1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 11:27:19 -0500
From: Namhyung Kim <namhyung@gmail.com>
To: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Cc: <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH][trace-cmd] blk plugin: replace BLK_TC_BARRIER with BLK_TC_FLUSH/BLK_TC_FUA
References: <1326028761-25209-1-git-send-email-stefanha@linux.vnet.ibm.com>
Date: Mon, 09 Jan 2012 01:27:12 +0900
In-Reply-To: <1326028761-25209-1-git-send-email-stefanha@linux.vnet.ibm.com>
	(Stefan Hajnoczi's message of "Sun, 8 Jan 2012 13:19:21 +0000")
Message-ID: <874nw6xiqn.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Hajnoczi <stefanha@linux.vnet.ibm.com> wrote:

> The BLK_TC_BARRIER flag was dropped in Linux commit c09c47caedc in
> August 2011.  The blk plugin fails to build against recent kernel
> headers.  Since no flag bits were left, the new BLK_TC_FLUSH flag reused
> the BLK_TC_BARRIER bit.  The new BLK_TC_FUA flag was also added.
>
> This patch updates fill_rwbs() to reflect the new
> BLK_TC_FLUSH/BLK_TC_FUA flags.  This allows plugin_blk.c to build
> successfully on recent kernels.  The drawback is that this breaks the
> build for pre-c09c47caedc kernel headers.
>
> Signed-off-by: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
> ---
> There is an alternative version of this patch with a build test in the Makefile
> so that we know whether to use BLK_TC_BARRIER or BLK_TC_FLUSH/BLK_TC_FUA.  That
> would support both old and new kernel headers using a HAVE_BLK_TC_FLUSH #ifdef.
>
> I wasn't able to find the right makefile shell escaping magic to get the
> build-test function to work.  If anyone knows how to test a snippet like the
> following, then that would be nicer:
>
>   #include <linux/blktrace_api.h>
>   int main(void) { return BLK_TC_FLUSH; }
>

Hi,

The perf uses following code for that:

# try-cc
# Usage: option = $(call try-cc, source-to-build, cc-options)
try-cc = $(shell sh -c						  \
	'TMP="$(OUTPUT)$(TMPOUT).$$$$";				  \
	 echo "$(1)" |						  \
	 $(CC) -x c - $(2) -o "$$TMP" > /dev/null 2>&1 && echo y; \
	 rm -f "$$TMP"')

Thanks,
Namhyung Kim
