Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab0JSP3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 11:29:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:47410 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061Ab0JSP27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 11:28:59 -0400
Message-ID: <4CBDB933.8030307@kernel.org>
Date: Tue, 19 Oct 2010 17:28:51 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH v2.6.36-rc7] init: don't call flush_scheduled_work() from
 do_initcalls()
References: <4CB86F94.7080702@kernel.org>
In-Reply-To: <4CB86F94.7080702@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 19 Oct 2010 15:28:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2010 05:13 PM, Tejun Heo wrote:
> It's unclear what flush_scheduled_work() in do_initcalls() tries to
> achieve.  The call doesn't make much sense - there already are
> multiple system workqueues which aren't affected by
> flush_scheduled_wokr() and subsystems are free to create and use their
> own.  Ordering requirements are and should be expressed explicitly.
> 
> Drop the call to prepare for deprecation and removal of
> flush_scheduled_work().
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
> If no one objects, I'll route this through wq tree.

Applying to wq#for-next.  Please scream if something is wrong.

Thanks.

-- 
tejun
