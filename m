Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965Ab1HTIOI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 04:14:08 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54482 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab1HTIOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 04:14:04 -0400
Date: Sat, 20 Aug 2011 10:13:56 +0200
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: menage@google.com, linux-kernel@vger.kernel.org, arnd@arndb.de,
        oleg@redhat.com
Subject: Re: [PATCH 01/16] freezer: fix current->state restoration race in
 refrigerator()
Message-ID: <20110820081356.GJ20085@htj.dyndns.org>
References: <1313763382-12341-1-git-send-email-tj@kernel.org>
 <1313763382-12341-2-git-send-email-tj@kernel.org>
 <201108192308.59705.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108192308.59705.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Rafael.

On Fri, Aug 19, 2011 at 11:08:59PM +0200, Rafael J. Wysocki wrote:
> On Friday, August 19, 2011, Tejun Heo wrote:
> > refrigerator() saves current->state before entering frozen state and
> > restores it before returning using __set_current_state(); however,
> > this is racy, for example, please consider the following sequence.
> > 
> > 	set_current_state(TASK_INTERRUPTIBLE);
> > 	try_to_sleep();
> 
> Did you mean try_to_freeze() here?

Heh, yeah, I'm constantly being confused among try_to_freeze(),
try_to_sleep() and try_to_wake_up().  Will update. ;)

Thanks.

-- 
tejun
