Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab2AWQKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 11:10:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12188 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885Ab2AWQKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 11:10:47 -0500
Date: Mon, 23 Jan 2012 11:10:42 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/17] blkcg: shoot down blkio_groups on elevator switch
Message-ID: <20120123161042.GG25986@redhat.com>
References: <1327202725-3383-1-git-send-email-tj@kernel.org>
 <1327202725-3383-9-git-send-email-tj@kernel.org>
 <20120123152055.GD25986@redhat.com>
 <20120123153913.GB12652@google.com>
 <20120123155216.GF25986@redhat.com>
 <20120123155745.GD12652@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120123155745.GD12652@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 07:57:45AM -0800, Tejun Heo wrote:
> On Mon, Jan 23, 2012 at 10:52:16AM -0500, Vivek Goyal wrote:
> > Atleast throttling rules should not disappear over elevator switch. They
> > are per device and not per IO scheduler. Think of losing nr_requests
> > settings just because elevator switch happened.
> > 
> > Elevator switch can be low frequency but how would a user space know
> > that elevator switch failed that's why we lost our rules and now lets
> > put the rules back.
> 
> It's simple - store all the policy rules before switching elevators
> and restore them afterwards regardless of success / failure.

This does not work well in hierachical management/scenario. Think that
a user gets an upper limit of 10MB/s on a device and now user can manage
its own children groups and divide allocated 10MB/s in children the way
he wants.

Now if root does the elevator switch, and saves all the rules (including
user's rules) and then restores back, these can very well race with
user's scripts of changing rules. If user changed a cgroup device rule
during elevator switch and after elevator switch root restored back
old rules, user's new rule will be lost leading to confusion.

Thanks
Vivek
