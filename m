Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760418Ab1F1SJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 14:09:25 -0400
Received: from lo.gmane.org ([80.91.229.12]:45742 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759528Ab1F1SI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 14:08:56 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Aditya Kali <adityakali@google.com>
Subject: Re: [RFC PATCH 4/4] cgroups: Add an rlimit subsystem
Date: Tue, 28 Jun 2011 18:08:42 +0000 (UTC)
Message-ID: <loom.20110628T194004-818@post.gmane.org>
References: <1308527474-20704-1-git-send-email-fweisbec@gmail.com> <1308527474-20704-5-git-send-email-fweisbec@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 216.239.45.4 (Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.77 Safari/534.30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker <fweisbec <at> gmail.com> writes:
> +struct rlim {
> +	struct res_counter		proc_counter;
> +	struct cgroup_subsys_state	css;
> +};
This can be used to enforce limits on FDs (RLIMIT_NOFILE), TCP/UDP ports,
locked memory, queued data on sockets, etc. How making proc_counter an
array (currently of size 1) ? Though with this patch there is just one, but it 
will great to have ready support for easily adding more.

> +static struct cftype cft_max_proc = {
> +	.name		= "max_proc",
> +	.read_u64	= max_proc_read_u64,
> +	.write_u64	= max_proc_write_u64,
> +};
How about exporting USAGE, MAX_USAGE and FAILCNT too? These are useful
for resource estimation.


