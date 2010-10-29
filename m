Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934083Ab0J2QKB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 12:10:01 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43428 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308Ab0J2QJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 12:09:58 -0400
Date: Fri, 29 Oct 2010 17:09:56 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Chun Wu <chun.wu84@gmail.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: missing module_put in put_disk
Message-ID: <20101029160955.GU19804@ZenIV.linux.org.uk>
References: <1288367495-2919-1-git-send-email-chun@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288367495-2919-1-git-send-email-chun@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 11:51:35AM -0400, Chun Wu wrote:
> From: Chun Wu <chun.wu84@gmail.com>
> 
> module_put function is not called in put_disk function. Should it be added?

Check the callers.  Check the callers of get_disk.  Think whether those
two are counterparts.  See if any callers would have module_put() nearby.
See if any callers would not have module_put() nearby.  See if there is
anything that would distinguish one class from another.  Think whether
they need different behaviour.  Then you'll be able to answer your
question.  As a bonus, consider the source of confusion and see if you
can remove it [I'm serious, BTW - get_disk() is apparently a lousy name
asking for confusion; renaming it might be a useful thing to do, provided
that new name would be less confusing]

[snip the patch blindly adding such call]
