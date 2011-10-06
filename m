Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758888Ab1JFRYv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 13:24:51 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51113 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758775Ab1JFRYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 13:24:48 -0400
Date: Thu, 6 Oct 2011 10:26:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>, quilt-dev <quilt-dev@nongnu.org>,
        LKML <linux-kernel@vger.kernel.org>, John Kacur <jkacur@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [RFC][PATCH v2][QUILT] Add
Message-Id: <20111006102626.22002ed9.akpm@linux-foundation.org>
In-Reply-To: <1317896857.29658.10.camel@twins>
References: <1317750395.18063.11.camel@gandalf.stny.rr.com>
	<1317896857.29658.10.camel@twins>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Oct 2011 12:27:37 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> since we're all happily sharing quilt hackery, let me hijack this thread
> and share one I've been carrying around for a while.
> 
> I use the below patch to run a script like:
> 
> #!/bin/bash
> 
> if [ -x ./scripts/chechpatch.pl ]; then
>         ./scripts/checkpatch.pl $1
> fi
> 
> 
> ---
> --- /usr/share/quilt/refresh.orig	2010-02-27 20:42:14.888302809 +0100
> +++ /usr/share/quilt/refresh	2010-10-31 12:36:57.355400831 +0100
> @@ -310,6 +310,10 @@
>  
>  cat $tmp_patch >> $tmp_result
>  
> +if [ -n $QUILT_REFRESH_EXT ] ; then
> +	$QUILT_REFRESH_EXT $tmp_result
   else
	sudo rm -rf /
> +fi
> +
>  mkdir -p $(dirname $patch_file)
>  
>  if [ -e $patch_file ] && \
