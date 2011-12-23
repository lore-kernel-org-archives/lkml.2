Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209Ab1LWAaM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 19:30:12 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49696 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756149Ab1LWAaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 19:30:04 -0500
Date: Thu, 22 Dec 2011 16:29:44 -0800
From: Mandeep Singh Baines <msb@chromium.org>
To: Tejun Heo <tj@kernel.org>
Cc: Mandeep Singh Baines <msb@chromium.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH 2/2] cgroup: remove extra calls to find_existing_css_set
Message-ID: <20111223002944.GK13529@google.com>
References: <1324592816-13792-1-git-send-email-msb@chromium.org>
 <1324592816-13792-2-git-send-email-msb@chromium.org>
 <20111222231203.GO17084@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111222231203.GO17084@google.com>
X-Operating-System: Linux/2.6.38.8-gg621 (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo (tj@kernel.org) wrote:
> On Thu, Dec 22, 2011 at 02:26:56PM -0800, Mandeep Singh Baines wrote:
> > +out_list_teardown:
> > +	if (retval) {
> > +		for (i = 0; i < group_size; i++) {
> > +			tc = flex_array_get(group, i);
> > +			put_css_set(tc->cg);
> > +		}
> > +	}
> 
> Don't we need to put them even after success?
> 

On success, we need to keep a reference for each thread in the threadgroup.

> -- 
> tejun
