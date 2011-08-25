Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633Ab1HYKQJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 06:16:09 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36035 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab1HYKQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 06:16:07 -0400
Date: Thu, 25 Aug 2011 12:16:02 +0200
From: Tejun Heo <tj@kernel.org>
To: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, James.Bottomley@HansenPartnership.com,
        dle-develop@lists.sourceforge.net,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [-v3 PATCH 0/3] Persistent device name using alias
Message-ID: <20110825101602.GI3286@htj.dyndns.org>
References: <20110825090359.2288.91057.stgit@ltc197.sdl.hitachi.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110825090359.2288.91057.stgit@ltc197.sdl.hitachi.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Aug 25, 2011 at 06:03:59PM +0900, Nao Nishijima wrote:
> This patch series provide an "alias" of the disk into kernel messages.
> 
> A raw device name of a disk does not always point a same disk at each boot-up
> time. Therefore, users have to use persistent device names, which udev creates
> to always access the same disk. However, kernel messages still display the raw
> device names.
> 
> My proposal is that users can use and see persistent device names which were
> assigned by themselves because users expect same name to point same disk
> anytime.
> 
> Why need to modify kernel messages?
> - We can see mapping of device names and persistent device names in udev log.
>   If those logs output to syslog, we can search persistent device name from
>   device name, but it can cause a large amount of syslog output.
> 
> - If we can use the persistent device names and can always see the same name on
>   the kernel log, we don't need to pay additional cost for searching and picking
>   a correct pair of device name and persistent device name from udev log.
> 
> - Kernel messages are output to serial console when kenel crashes, it's so hard
>   to convert a device name to the alias.

Just some general comments.  This may already be a horse which is
beaten to death but anyways...

I'm not really convinced this is something we need.  What we're
missing is structured error reporting which can be understood,
processed, presented and reacted by programs implementing system
management policies.  Such facility would be useful in general but for
block devices I think it's a must that we're sorely missing.

Free format kernel message is a very undiscoverable way of
communicating these information.  For developing and debugging, it's
fine.  It's easy, flexible and you don't really have to think too much
about what should be presented how.  For anything else, it's basically
horrible.

I don't really see what the point of this feature is.  For developing
and debugging, pretty names might be nice but almost completely
unnecessary.  For anything else, this falls way too short and can be
easily replaced by some smart scripting from userland.  After all,
matching different device names is the least of the worries when
trying to use kernel log for general management and post-processing w/
good amount of heuristics is necessary to be useful anyway.

So, FWIW, I object.

Thank you.

-- 
tejun
