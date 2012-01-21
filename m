Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660Ab2AUAIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 19:08:53 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:50411 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755647Ab2AUAIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 19:08:50 -0500
Date: Fri, 20 Jan 2012 16:08:42 -0800
From: Tejun Heo <tj@kernel.org>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH 3/3] cgroup: remove extra calls to find_existing_css_set
Message-ID: <20120121000842.GB2908@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1325654312-32477-1-git-send-email-msb@chromium.org>
 <1325654312-32477-3-git-send-email-msb@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325654312-32477-3-git-send-email-msb@chromium.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 03, 2012 at 09:18:32PM -0800, Mandeep Singh Baines wrote:
> +out_put_css_set_refs:
> +	if (retval) {
> +		for (i = 0; i < css_set_refs; i++) {
> +			tc = flex_array_get(group, i);
> +			put_css_set(tc->cg);

Why not the following

	for (i = 0; i < group_size; i++) {
		tc = flex_array_get(group, i);
		if (tc)
			put_css_set(tc->cg);
	}

and remove css_set_refs?

Thanks

-- 
tejun
