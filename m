Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344Ab1KQPlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 10:41:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:33562 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932198Ab1KQPlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 10:41:16 -0500
Date: Thu, 17 Nov 2011 09:41:05 -0600
From: "Serge E. Hallyn" <serge.hallyn@canonical.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Introduce CAP_CHECKPOINT capability and filter map_files/
 access
Message-ID: <20111117154105.GA4522@sergelap>
References: <20111117100439.GK20508@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111117100439.GK20508@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Cyrill Gorcunov (gorcunov@gmail.com):
> The goal idea of checkpoint/restore is to provide this feature not
> for admins only but regular users as well. Still some operations
> are privileged -- such as accessing /proc/$pid/map_files.
> 
> So instead of requiring anyone who has a will to checkpoint/restore
> processes CAP_SYS_ADMIN privileges, it might (?) be worth to bring a way
> less powerful CAP_CHECKPOINT capability.
> 
> The following permissions for CAP_CHECKPOINT should be granted
>  - read/write /proc/$pid/map_files/

read/write to all map files, or only pids he owns?

I think a CAP_CHECKPOINT may make sense, but not if includes read/write
to all map files.  That's too much power, and you may as well just hand
him everything.  But, CAP_CHECKPOINT shouldn't need to include that.  You
should be able to get that for instance by being the creator of the user
namespace being checkpointed.  If you really want to checkpoint/restart
anything on the system, then you should be required to be root.  Trying
to easily hand that power to an unprivileged user is more dangerous imo.

>  - (not yet merged) clone-with-specified-pid, might be changed to last_pid+clone setup
>  - (not yet published/stabilized) prctls calls to tune up vDSO and elements
>    of mm_struct such as mm->start_code, mm->end_code, mm->start_data and etc
> 
> I would like to gather people opinions on such approach as a general.
> _ANY_ comments are highly appreciated. Would it worth it or not (since
> CAPs space is pretty limited one).

It's hard to have a specific dialogue without the full c/r patchset and
idea of the architecture of the exploiters (ie c/r and maybe
debuggers)

Sorry, the security implications of the in-kernel c/r syscalls were
pretty simple and clear to me, but those of the new approach are not.

-serge
