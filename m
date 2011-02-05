Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab1BEAiI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 19:38:08 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42989 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752085Ab1BEAiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 19:38:06 -0500
Date: Fri, 4 Feb 2011 16:37:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: jacob.jun.pan@linux.intel.com
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Matt Helsley <matthltc@us.ibm.com>,
        container cgroup <containers@lists.linux-foundation.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>
Subject: Re: [PATCH v2] cgroup/freezer: add per freezer duty ratio control
Message-Id: <20110204163751.33ea54f3.akpm@linux-foundation.org>
In-Reply-To: <1296693740-11537-2-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1296693740-11537-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<1296693740-11537-2-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  2 Feb 2011 16:42:20 -0800
jacob.jun.pan@linux.intel.com wrote:

> Freezer subsystem is used to manage batch jobs which can start
> stop at the same time. However, sometime it is desirable to let
> the kernel manage the freezer state automatically with a given
> duty ratio.
> For example, if we want to reduce the time that backgroup apps
> are allowed to run we can put them into a freezer subsystem and
> set the kernel to turn them THAWED/FROZEN at given duty ratio.
> 
> This patch introduces two file nodes under cgroup
> freezer.duty_ratio_pct and freezer.period_sec
> 
> Usage example: set period to be 5 seconds and frozen duty ratio 90%
> [root@localhost aoa]# echo 90 > freezer.duty_ratio_pct
> [root@localhost aoa]# echo 5 > freezer.period_sec
> 
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> ---
>  kernel/cgroup_freezer.c |  109 ++++++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 107 insertions(+), 2 deletions(-)

Update the documentation please.  Documentation/cgroups/
