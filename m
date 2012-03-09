Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758383Ab2CIVU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 16:20:56 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55492 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757555Ab2CIVUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 16:20:55 -0500
Date: Fri, 9 Mar 2012 13:20:49 -0800
From: Tejun Heo <tj@kernel.org>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>,
        Will Drewry <wad@chromium.org>, Elly Jones <ellyjones@chromium.org>,
        Milan Broz <mbroz@redhat.com>, Olof Johansson <olofj@chromium.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: workqueues and percpu (was: [PATCH] dm: remake of the verity
 target)
Message-ID: <20120309212049.GD24890@google.com>
References: <1330648393-20692-1-git-send-email-msb@chromium.org>
 <Pine.LNX.4.64.1203031340340.10937@file.rdu.redhat.com>
 <20120306215947.GB27051@google.com>
 <Pine.LNX.4.64.1203081656590.31821@file.rdu.redhat.com>
 <20120308143909.bfc4cb4d.akpm@linux-foundation.org>
 <20120308231521.GA2968@htj.dyndns.org>
 <20120309211512.GL27051@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120309211512.GL27051@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Mar 09, 2012 at 01:15:12PM -0800, Mandeep Singh Baines wrote:
> In this case, I need the per-cpu data for the duration of calculating
> a cryptographics hash on a 4K page of data. That's a long time to disable
> pre-emption.

How long are we talking about?  Tens of microsecs, tens of millisecs?

> I could fix the bug temporarily by adding get/put for the per_cpu data
> but would that be acceptable? I'm not sure what the OK limit is for how
> long one can disable preemption. An alternative fix would be not allow
> CONFIG_VERITY when CONFIG_HOTPLUG_CPU. Once workqueues are fixed, I could
> remove that restriction.

I think the right thing to do for now is to add cpu hotplug notifier
and do flush_work_sync() on the work item.  We can later move that
logic into workqueue and remove it from crypto.

Thanks.

-- 
tejun
