Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758885Ab2HHQjg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 12:39:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56751 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758853Ab2HHQjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 12:39:35 -0400
Date: Wed, 8 Aug 2012 09:39:29 -0700
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        padovan@profusion.mobi, marcel@holtmann.org, peterz@infradead.org,
        mingo@redhat.com, davem@davemloft.net, dougthompson@xmission.com,
        ibm-acpi@hmh.eng.br, cbou@mail.ru, rui.zhang@intel.com,
        tomi.valkeinen@ti.com
Subject: Re: your mail
Message-ID: <20120808163929.GA2985@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1344015839-21800-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344015839-21800-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2012 at 10:43:45AM -0700, Tejun Heo wrote:
> delayed_work has been annoyingly missing the mechanism to modify timer
> of a pending delayed_work - ie. mod_timer() counterpart.  delayed_work
> users have been working around this using several methods - using an
> explicit timer + work item, messing directly with delayed_work->timer,
> and canceling before re-queueing, all of which are error-prone and/or
> ugly.
> 
> Gustavo Padovan posted a RFC implementation[1] of mod_delayed_work() a
> while back but it wasn't complete.  To properly implement
> mod_delayed_work[_on](), it should be able to steal pending work items
> which may be on timer or worklist or anywhere inbetween.  This is
> similar to what __cancel_work_timer() does but it turns out that there
> are a lot of holes around this area and try_to_grab_pending() needs
> considerable amount of work to be used for other purposes too.
> 
> This patchset improves canceling and try_to_grab_pending(), use it to
> implement mod_delayed_work[_on](), convert easy ones, and drop
> __cancel_delayed_work_sync() which doesn't have relevant users
> afterwards.

Applied to wq/for-3.7.

Thanks.

-- 
tejun
