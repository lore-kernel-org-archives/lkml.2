Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab2ARWEu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 17:04:50 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44461 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab2ARWEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 17:04:49 -0500
Date: Wed, 18 Jan 2012 14:04:44 -0800
From: Tejun Heo <tj@kernel.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, horms@verge.net.au,
        "pavel@ucw.cz" <pavel@ucw.cz>, Len Brown <lenb@kernel.org>
Subject: Re: [Update][PATCH] PM / Hibernate: Fix s2disk regression related
 to unlock_system_sleep()
Message-ID: <20120118220444.GB21533@google.com>
References: <4F16C24A.4050007@linux.vnet.ibm.com>
 <CAOS58YMBWrD2cMyPJG0Xf16i1vnkB8xerdeqWJ=fk7HVNpoPAw@mail.gmail.com>
 <4F16F94C.4020000@linux.vnet.ibm.com>
 <CAOS58YPW3hB3ibaYPLBqhu=2jZTAjjF7DZaXO=hK5tookAX7YA@mail.gmail.com>
 <4F16FF0D.1030606@linux.vnet.ibm.com>
 <20120118173037.GE30664@google.com>
 <4F171BF8.50803@linux.vnet.ibm.com>
 <20120118193040.GA28538@google.com>
 <4F17217E.5040805@linux.vnet.ibm.com>
 <4F172B8D.8050408@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F172B8D.8050408@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 01:59:01AM +0530, Srivatsa S. Bhat wrote:
> From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> Subject: [PATCH] PM / Hibernate: Rewrite unlock_system_sleep() to fix s2disk regression
> 
> Commit 33e638b, "PM / Sleep: Use the freezer_count() functions in
> [un]lock_system_sleep() APIs" introduced an undesirable change in the
> behaviour of unlock_system_sleep() since freezer_count() internally calls
> try_to_freeze() - which we don't need in unlock_system_sleep().
> 
> And commit bcda53f, "PM / Sleep: Replace mutex_[un]lock(&pm_mutex) with
> [un]lock_system_sleep()" made these APIs wide-spread. This caused a
> regression in suspend-to-disk where snapshot_read() and snapshot_write()
> were getting frozen due to the try_to_freeze embedded in
> unlock_system_sleep(), since these functions were invoked when the freezing
> condition was still in effect.
> 
> Fix this by rewriting unlock_system_sleep() by open-coding freezer_count()
> and dropping the try_to_freeze() part. Not only will this fix the
> regression but this will also ensure that the API only does what it is
> intended to do, and nothing more, under the hood.
> 
> While at it, make the code more correct and robust by ensuring that the
> PF_FREEZER_SKIP flag gets cleared with pm_mutex held, to avoid a race with
> the freezer.
> 
> Reported-by: Rafael J. Wysocki <rjw@sisk.pl>
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks!

-- 
tejun
