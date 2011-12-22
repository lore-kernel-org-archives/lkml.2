Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab1LVXML (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 18:12:11 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43637 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab1LVXMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 18:12:08 -0500
Date: Thu, 22 Dec 2011 15:12:03 -0800
From: Tejun Heo <tj@kernel.org>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH 2/2] cgroup: remove extra calls to find_existing_css_set
Message-ID: <20111222231203.GO17084@google.com>
References: <1324592816-13792-1-git-send-email-msb@chromium.org>
 <1324592816-13792-2-git-send-email-msb@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324592816-13792-2-git-send-email-msb@chromium.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 02:26:56PM -0800, Mandeep Singh Baines wrote:
> +out_list_teardown:
> +	if (retval) {
> +		for (i = 0; i < group_size; i++) {
> +			tc = flex_array_get(group, i);
> +			put_css_set(tc->cg);
> +		}
> +	}

Don't we need to put them even after success?

-- 
tejun
