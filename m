Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab1IMIAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 04:00:14 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60968 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339Ab1IMIAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 04:00:10 -0400
Date: Tue, 13 Sep 2011 17:00:04 +0900
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, linux-kernel@vger.kernel.org,
        dvlasenk@redhat.com
Subject: Re: [PATCH v2] Make PTRACE_SEIZE set ptrace options specified in
 'data' parameter
Message-ID: <20110913080004.GF11397@mtj.dyndns.org>
References: <201109072340.31460.vda.linux@googlemail.com>
 <20110908004438.GC3987@mtj.dyndns.org>
 <20110908181747.GA28120@redhat.com>
 <20110911020523.GL29319@htj.dyndns.org>
 <20110911181442.GA22239@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110911181442.GA22239@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 11, 2011 at 08:14:42PM +0200, Oleg Nesterov wrote:
> We need to rework the locking, yes. But we need the lock which protects
> the parent's list_head (currently we rely on tasklist). Yes, a single
> lock can't help. We already use ->cred_guard_mutex though.
> 
> This needs more thinking, but imho child->siglock is pointless here.

But we can at least guarantee that if ->ptrace is set (or clear) while
tracee's siglock is held, its ->parent points to the tracer (or not).
At any rate, AFAICS, this currently doesn't really matter.  I
suggested it mainly because it would make the locking change easier.

Thanks.

-- 
tejun
