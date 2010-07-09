Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab0GIKEc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 06:04:32 -0400
Received: from trinity.develer.com ([83.149.158.210]:39814 "EHLO
	trinity.develer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab0GIKEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 06:04:30 -0400
Date: Fri, 9 Jul 2010 12:04:22 +0200
From: Andrea Righi <righi.andrea@gmail.com>
To: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       Vivek Goyal <vgoyal@redhat.com>, Ryo Tsuruta <ryov@valinux.co.jp>,
       taka@valinux.co.jp, kamezawa.hiroyu@jp.fujitsu.com,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>, akpm@linux-foundation.org,
       balbir@linux.vnet.ibm.com, Greg Thelen <gthelen@google.com>
Subject: Re: [RFC][PATCH 00/11] blkiocg async support
Message-ID: <20100709100422.GB1814@linux.develer.com>
References: <4C369009.80503@ds.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C369009.80503@ds.jp.nec.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 08, 2010 at 10:57:13PM -0400, Munehiro Ikeda wrote:
> This might be a piece of puzzle for complete async write support of blkio
> controller.  One of other pieces in my head is page dirtying ratio control.
> I believe Andrea Righi was working on it...how about the situation?

Greg Thelen (cc'ed) did some progresses on my original work. AFAIK
there're still some locking issue to resolve, principally because
cgroup dirty memory accounting requires lock_page_cgroup() to be
irq-safe. I did some tests using the irq-safe locking vs trylock
approach and Greg also tested the RCU way.

The RCU approach seems promising IMHO, because the page's cgroup owner
is supposed to change rarely (except for the files shared and frequently
written by many cgroups).

Greg, do you have a patch rebased to a recent kernel?

Thanks,
-Andrea
