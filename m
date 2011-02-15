Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab1BOMTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 07:19:46 -0500
Received: from smtp.nokia.com ([147.243.1.47]:32762 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545Ab1BOMTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 07:19:44 -0500
Message-ID: <4D5A6EEC.5000908@maxwell.research.nokia.com>
Date: Tue, 15 Feb 2011 14:17:48 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20101123 SeaMonkey/2.0.11
MIME-Version: 1.0
To: balbi@ti.com
CC: Thomas Weber <weber@corscience.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-omap@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, Tejun Heo <tj@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] video: omap24xxcam: Fix compilation
References: <1297068547-10635-1-git-send-email-weber@corscience.de> <4D5A6353.7040907@maxwell.research.nokia.com> <20110215113717.GN2570@legolas.emea.dhcp.ti.com> <4D5A672A.7040000@samsung.com> <4D5A6874.1080705@corscience.de> <20110215115349.GQ2570@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110215115349.GQ2570@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe Balbi wrote:
> Hi,
> 
> On Tue, Feb 15, 2011 at 12:50:12PM +0100, Thomas Weber wrote:
>> Hello Felipe,
>>
>> in include/linux/wait.h
>>
>> #define wake_up(x)            __wake_up(x, TASK_NORMAL, 1, NULL)
> 
> aha, now I get it, so shouldn't the real fix be including <linux/sched.h>
> on <linux/wait.h>, I mean, it's <linuux/wait.h> who uses a symbol
> defined in <linux/sched.h>, right ?

Surprisingly many other files still don't seem to be affected. But this
is actually a better solution (to include sched.h in wait.h).

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
