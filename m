Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab0JKN3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 09:29:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:38333 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754614Ab0JKN3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 09:29:50 -0400
Message-ID: <4CB3113E.1060403@kernel.org>
Date: Mon, 11 Oct 2010 15:29:34 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: core: use non-reentrant workqueue where necessary
References: <tkrat.06dc43b96f9ab9bf@s5r6.in-berlin.de>
In-Reply-To: <tkrat.06dc43b96f9ab9bf@s5r6.in-berlin.de>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 11 Oct 2010 13:29:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Stefan.

On 10/10/2010 04:55 PM, Stefan Richter wrote:
...
> Therefore queue all of these types of work items on system_nrt_wq
> instead of system_wq.  The former guarantees non-reentrance across all
> CPUs, the latter only on the CPU which schedules a work item.
> 
> As a bonus, other subsystems which flush system_wq won't be held up if
> the firewire subsystem spends a lot of time in an extraordinarily long
> fw_device.work.

Awesome, thanks a lot for doing this.  BTW, I'm in the process of
hunting down all flush_scheduled_work() users and plan to remove
workqueue flushing capability from all system workqueues.

> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

For the workqueue part,

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
