Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab2AWP5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 10:57:52 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58496 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab2AWP5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 10:57:50 -0500
Date: Mon, 23 Jan 2012 07:57:45 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/17] blkcg: shoot down blkio_groups on elevator switch
Message-ID: <20120123155745.GD12652@google.com>
References: <1327202725-3383-1-git-send-email-tj@kernel.org>
 <1327202725-3383-9-git-send-email-tj@kernel.org>
 <20120123152055.GD25986@redhat.com>
 <20120123153913.GB12652@google.com>
 <20120123155216.GF25986@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120123155216.GF25986@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 10:52:16AM -0500, Vivek Goyal wrote:
> Atleast throttling rules should not disappear over elevator switch. They
> are per device and not per IO scheduler. Think of losing nr_requests
> settings just because elevator switch happened.
> 
> Elevator switch can be low frequency but how would a user space know
> that elevator switch failed that's why we lost our rules and now lets
> put the rules back.

It's simple - store all the policy rules before switching elevators
and restore them afterwards regardless of success / failure.

> I am not sure how would we justify this that because of ease of programming
> in kernel, now user space is supposed to make sure that any programmed
> rules are still there and reprogram the cgroup if rules are gone for
> some reason.

Sanity in trade off?

-- 
tejun
