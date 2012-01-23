Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab2AWQQ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 11:16:26 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52648 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab2AWQQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 11:16:25 -0500
Date: Mon, 23 Jan 2012 08:16:19 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/17] blkcg: shoot down blkio_groups on elevator switch
Message-ID: <20120123161619.GE12652@google.com>
References: <1327202725-3383-1-git-send-email-tj@kernel.org>
 <1327202725-3383-9-git-send-email-tj@kernel.org>
 <20120123152055.GD25986@redhat.com>
 <20120123153913.GB12652@google.com>
 <20120123155216.GF25986@redhat.com>
 <20120123155745.GD12652@google.com>
 <20120123161042.GG25986@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120123161042.GG25986@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 11:10:42AM -0500, Vivek Goyal wrote:
> This does not work well in hierachical management/scenario. Think that
> a user gets an upper limit of 10MB/s on a device and now user can manage
> its own children groups and divide allocated 10MB/s in children the way
> he wants.
> 
> Now if root does the elevator switch, and saves all the rules (including
> user's rules) and then restores back, these can very well race with
> user's scripts of changing rules. If user changed a cgroup device rule
> during elevator switch and after elevator switch root restored back
> old rules, user's new rule will be lost leading to confusion.

It simply doesn't matter.  Just declare elvswitch and policy change
reset blkcg configurations.  If some people are crazy enough to switch
elevators regularly with full system running and parallel
configuration going on, let them deal with synchronizing their
scripts.

-- 
tejun
