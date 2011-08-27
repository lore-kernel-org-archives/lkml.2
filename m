Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255Ab1H0K1B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 06:27:01 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41118 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab1H0K1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 06:27:00 -0400
Date: Sat, 27 Aug 2011 12:26:55 +0200
From: Tejun Heo <tj@kernel.org>
To: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, James.Bottomley@HansenPartnership.com,
        dle-develop@lists.sourceforge.net,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com, kay.sievers@gmail.com
Subject: Re: [-v3 PATCH 0/3] Persistent device name using alias
Message-ID: <20110827102655.GJ2632@htj.dyndns.org>
References: <20110825090359.2288.91057.stgit@ltc197.sdl.hitachi.co.jp>
 <20110825101602.GI3286@htj.dyndns.org>
 <4E58C3BD.3000609@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E58C3BD.3000609@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing Kay)
Hello,

On Sat, Aug 27, 2011 at 07:15:25PM +0900, Nao Nishijima wrote:
> Our concern is the failure analysis. For example, when the disk failure
> happened, we need to identify the disk from kernel log.
> 
> Kernel messages are output to serial console when kernel crashes.
> It's so hard to convert a device name to the alias. Thus the script
> can't always convert the name.

Hmm... I don't follow.  Why wouldn't it be able to?  All the
informations are in the log.  It is messy but it's there.  If you want
more structured information, u{dev|disks} already maintain device
libarary - what maps to what, connected how with what attributes and
so on.  Sending them off to the log machine as device hotplug events
occur and consulting it when post-processing log message would work
fine.  All you need is just some python scripting.  I don't really see
much point in messing with device names directly.  The only thing is
that the raw log would be prettier.  I don't think that is useful
enough to justify changing kernel device names.

Thanks.

-- 
tejun
