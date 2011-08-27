Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748Ab1H0Myh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 08:54:37 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:43976 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab1H0Mye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 08:54:34 -0400
X-AuditID: b753bd60-a46b0ba0000019f4-9e-4e58e9078128
X-AuditID: b753bd60-a46b0ba0000019f4-9e-4e58e9078128
Message-ID: <4E58E905.4020704@hitachi.com>
Date: Sat, 27 Aug 2011 21:54:29 +0900
From: Nao Nishijima <nao.nishijima.xt@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, James.Bottomley@HansenPartnership.com,
        dle-develop@lists.sourceforge.net,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com, kay.sievers@gmail.com
Subject: Re: [-v3 PATCH 0/3] Persistent device name using alias
References: <20110825090359.2288.91057.stgit@ltc197.sdl.hitachi.co.jp> <20110825101602.GI3286@htj.dyndns.org> <4E58C3BD.3000609@hitachi.com> <20110827102655.GJ2632@htj.dyndns.org>
In-Reply-To: <20110827102655.GJ2632@htj.dyndns.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

(2011/08/27 19:26), Tejun Heo wrote:
> (cc'ing Kay)
> Hello,
> 
> On Sat, Aug 27, 2011 at 07:15:25PM +0900, Nao Nishijima wrote:
>> Our concern is the failure analysis. For example, when the disk failure
>> happened, we need to identify the disk from kernel log.
>>
>> Kernel messages are output to serial console when kernel crashes.
>> It's so hard to convert a device name to the alias. Thus the script
>> can't always convert the name.
> 
> Hmm... I don't follow.  Why wouldn't it be able to?  All the
> informations are in the log.  It is messy but it's there.  If you want

In many cases, the script is able to convert the name. However there is
the special case that the logs do not exist in memory and disk due to
the crash except console.


> more structured information, u{dev|disks} already maintain device
> libarary - what maps to what, connected how with what attributes and
> so on.  Sending them off to the log machine as device hotplug events
> occur and consulting it when post-processing log message would work
> fine.  All you need is just some python scripting.  I don't really see
> much point in messing with device names directly.  The only thing is
> that the raw log would be prettier.  I don't think that is useful
> enough to justify changing kernel device names.

A kernel device names (e.g. sda) is not useful information because it
doesn't always point the same disk at each boot-up time.

An alias is just an option and provides the ability to give all
kernel devices a "preferred name".

By default, dev_printk's will show a kernel device name. They show an
alias only when the user assigns a "preferred name" to an alias.
Even if the persistend device name is used, the device names in logs are
different from the name that the users are using. So, an alias helps the
user identify the disk.


Best regards,

-- 
Nao NISHIJIMA
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., YOKOHAMA Research  Laboratory
Email： nao.nishijima.xt@hitachi.com
