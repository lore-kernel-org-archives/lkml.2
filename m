Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab1JSQff (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 12:35:35 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34752 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042Ab1JSQfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 12:35:33 -0400
Date: Wed, 19 Oct 2011 09:35:28 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, ctalbott@google.com,
        rni@google.com
Subject: Re: [PATCH 05/10] block: drop unnecessary blk_get/put_queue() in
 scsi_cmd_ioctl() and blk_get_tg()
Message-ID: <20111019163528.GC25124@google.com>
References: <1318998384-22525-1-git-send-email-tj@kernel.org>
 <1318998384-22525-6-git-send-email-tj@kernel.org>
 <20111019135254.GD1140@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111019135254.GD1140@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Vivek.

On Wed, Oct 19, 2011 at 09:52:54AM -0400, Vivek Goyal wrote:
> What makes sure that caller has the reference to the queue upon entry. If
> that's the case, that's good. Just that I had not figured it out so
> resorted to defensive programming as taking extra reference does not harm.

The fact that @q can be dereferenced on entry at all. :)

Taking extra reference doesn't help anything.  If the caller doesn't
have standing reference, it will just change where oops occurs.  W/o
extra ref, it will crash soon after the last reference is put.  W/
extra ref, it will crash after the extra ref is put.  If the caller
doesn't hold a reference, there's nothing the callee can do to fix
that.

Thanks.

-- 
tejun
