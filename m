Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab1E3GYJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 02:24:09 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50895 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab1E3GYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 02:24:08 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DE337FB.3000804@jp.fujitsu.com>
Date: Mon, 30 May 2011 15:23:55 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: vnagarnaik@google.com, rientjes@google.com, mingo@redhat.com,
        fweisbec@gmail.com, mrubin@google.com, dhsharp@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trace: Set oom_score_adj to maximum for ring buffer allocating
 process
References: <1306439537-23706-1-git-send-email-vnagarnaik@google.com>	 <1306519125-19301-1-git-send-email-vnagarnaik@google.com>	 <alpine.DEB.2.00.1105271618470.9445@chino.kir.corp.google.com>	 <BANLkTimfdkpY=9pgEmBZwE3ezCmooEtQTA@mail.gmail.com> <1306547453.3857.44.camel@gandalf.stny.rr.com>
In-Reply-To: <1306547453.3857.44.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/28 10:50), Steven Rostedt wrote:
> On Fri, 2011-05-27 at 17:44 -0700, Vaibhav Nagarnaik wrote:
> 
>> That said, I am open to changing it if Steven and you think using
>> oom_killer_disabled is a better solution.
> 
> My biggest concern is that we are setting policy in the kernel. If you
> are concerned about this, why not just have the process that is going to
> increase the size of the ring buffer adjust its own oom policy
> with /proc/<pid>/oom_score_adj ? Only a privilege process can increase
> the size of the ring buffer so it's not like we are worried about any
> normal user task upping the ring buffer to kill other processes.

I like Steven's approach.

Because even if we apply Vaibhav's patch, we still have a oom issue.
because when oom-killer killed echo commands, it doesn't shrink ring
buffer. it only just die. So, the kernel is still under extreme memory
shortage. Any admins operation may invoke next oom-killer.

And -personally- I think any tracing user should know system ram size
and proper ring buffer size. ;)

