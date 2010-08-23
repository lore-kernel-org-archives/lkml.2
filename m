Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab0HWLM7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 07:12:59 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46104 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab0HWLM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 07:12:57 -0400
Date: Mon, 23 Aug 2010 07:07:19 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Xiaotian Feng <dfeng@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Roland McGrath <roland@redhat.com>
Subject: Re: [RFC PATCH v3] core_pattern: fix long parameters was truncated
 by core_pattern handler
Message-ID: <20100823110719.GA12906@hmsreliant.think-freely.org>
References: <20100803105941.GA2996@hmsreliant.think-freely.org>
 <1282296958-2427-1-git-send-email-dfeng@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282296958-2427-1-git-send-email-dfeng@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 05:35:58PM +0800, Xiaotian Feng wrote:
> We met a parameter truncated issue, consider following:
> > echo "|/root/core_pattern_pipe_test %p /usr/libexec/blah-blah-blah \
> %s %c %p %u %g 11 12345678901234567890123456789012345678 %t" > \
> /proc/sys/kernel/core_pattern
> 
> This is okay because the strings is less than CORENAME_MAX_SIZE.
> "cat /proc/sys/kernel/core_pattern" shows the whole string. but
> after we run core_pattern_pipe_test in man page, we found last
> parameter was truncated like below:
>         argc[10]=<12807486>
> 
> The root cause is core_pattern allows % specifiers, which need to be
> replaced during parse time, but the replace may expand the strings
> to larger than CORENAME_MAX_SIZE. So if the last parameter is %
> specifiers, the replace code is using snprintf(out_ptr, out_end - out_ptr, ...),
> this will write out of corename array.
> 
> Changes since v2:
> Introduced generic function cn_printf and make format_corename remember the time
> has been expanded.
> 
> Changes since v1:
> This patch allocates corename at runtime, if the replace doesn't have enough
> memory, expand the corename dynamically.
> 
> Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: Roland McGrath <roland@redhat.com>
> ---
>  fs/exec.c |  180 ++++++++++++++++++++++++++++++++++++++++--------------------
>  1 files changed, 120 insertions(+), 60 deletions(-)
> 
This looks alot cleaner.  Thanks!
Reviewed-by: Neil Horman <nhorman@tuxdriver.com>

