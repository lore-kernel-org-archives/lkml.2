Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab2AUC5b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 21:57:31 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39230 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499Ab2AUC51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 21:57:27 -0500
Date: Fri, 20 Jan 2012 18:57:12 -0800
From: Mandeep Singh Baines <msb@chromium.org>
To: Tejun Heo <tj@kernel.org>
Cc: Mandeep Singh Baines <msb@chromium.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH 3/3] cgroup: remove extra calls to find_existing_css_set
Message-ID: <20120121025712.GB4656@google.com>
References: <1325654312-32477-1-git-send-email-msb@chromium.org>
 <1325654312-32477-3-git-send-email-msb@chromium.org>
 <20120121000842.GB2908@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
In-Reply-To: <20120121000842.GB2908@dhcp-172-17-108-109.mtv.corp.google.com>
X-Operating-System: Linux/2.6.38.8-gg683 (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo (tj@kernel.org) wrote:
> On Tue, Jan 03, 2012 at 09:18:32PM -0800, Mandeep Singh Baines wrote:
> > +out_put_css_set_refs:
> > +	if (retval) {
> > +		for (i = 0; i < css_set_refs; i++) {
> > +			tc = flex_array_get(group, i);
> > +			put_css_set(tc->cg);
> 
> Why not the following
> 
> 	for (i = 0; i < group_size; i++) {
> 		tc = flex_array_get(group, i);
> 		if (tc)
> 			put_css_set(tc->cg);
> 	}
> 
> and remove css_set_refs?
> 

If I break out of step 2 via the goto (out_put_css_set_refs), I only
want to put back the refs I've gotten so far. I could reset group_size
in that case but wanted avoid overloading group_size: someone
could later add more error path code that isn't expecting that
group_size will get re-assigned and have its meaning change.

Regards,
Mandeep

> Thanks
> 
> -- 
> tejun
