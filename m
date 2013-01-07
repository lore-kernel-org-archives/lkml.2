Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab3AGRod (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 12:44:33 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:40572 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab3AGRob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 12:44:31 -0500
Date: Mon, 7 Jan 2013 09:44:27 -0800
From: Tejun Heo <tj@kernel.org>
To: Greg Thelen <gthelen@google.com>
Cc: Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] cgroups: fix cgroup_event_listener error handling
Message-ID: <20130107174427.GM3926@htj.dyndns.org>
References: <1357333518-28899-1-git-send-email-gthelen@google.com>
 <1357333518-28899-2-git-send-email-gthelen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1357333518-28899-2-git-send-email-gthelen@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2013 at 01:05:18PM -0800, Greg Thelen wrote:
> If the <absolute-path-to-control-file> command line parameter cannot
> be opened, then cgroup_event_listener prints an error message and
> tries to return an error.  However, due to an uninitialized variable
> the return value was undefined.
> 
> With this patch such failures always return non-zero error.
> 
> Compiler warning found this:
>   $ gcc -Wall -O2 cgroup_event_listener.c
>   cgroup_event_listener.c: In function ‘main’:
>   cgroup_event_listener.c:109:2: warning: ‘ret’ may be used uninitialized in this function [-Wuninitialized]
> 
> Signed-off-by: Greg Thelen <gthelen@google.com>
> ---
>  tools/cgroup/cgroup_event_listener.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/cgroup/cgroup_event_listener.c b/tools/cgroup/cgroup_event_listener.c
> index 3e082f9..a70f00c 100644
> --- a/tools/cgroup/cgroup_event_listener.c
> +++ b/tools/cgroup/cgroup_event_listener.c
> @@ -35,7 +35,7 @@ int main(int argc, char **argv)
>  	if (cfd == -1) {
>  		fprintf(stderr, "Cannot open %s: %s\n", argv[1],
>  				strerror(errno));
> -		goto out;
> +		return 1;

Hmm... so, event_control open failure path is broken the same way.
Can you please fix it together?  Please just remove the cleanup path.

Thanks.

-- 
tejun
