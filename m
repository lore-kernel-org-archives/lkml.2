Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760352Ab2EVTu2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 15:50:28 -0400
Received: from plane.gmane.org ([80.91.229.3]:47124 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932087Ab2EVTuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 15:50:24 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?ISO-8859-1?Q?J=F6rg-Volker_Peetz?= <jvpeetz@web.de>
Subject: Re: Linux 3.4 released
Date: Tue, 22 May 2012 21:50:10 +0200
Message-ID: <4FBBEDF2.8060803@web.de>
References: <CA+55aFwaobhbBZkE1LTyQJYhk8w8zk-cyOXXuXfPyE=BXzT3PA@mail.gmail.com> <4FBBB11D.7020904@web.de> <20120522155345.GC14339@google.com> <4FBBC461.4060008@web.de> <20120522170320.GD14339@google.com> <jpglns$1uj$1@dough.gmane.org> <CAOS58YPMh_hbJ4a49j4p9H68n8U1LzMUuaxmHx57gVTkmfxF6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
Cc: linux-kernel@vger.kernel.org
X-Gmane-NNTP-Posting-Host: p5b371840.dip.t-dialin.net
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
In-Reply-To: <CAOS58YPMh_hbJ4a49j4p9H68n8U1LzMUuaxmHx57gVTkmfxF6A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote, on 05/22/12 20:35:
> Hello,
> 
> On Tue, May 22, 2012 at 11:26 AM, Jörg-Volker Peetz <jvpeetz@web.de> wrote:
>> Also with this second patch I wasn't able to see any output beginning with "XXX
>> delayed_work_timer_fn:". It should appear in the system log or on the text-console?
> 
> Hmmm... it should appear on the console but your printk setting might
> be different. Can you please prepend KERN_CRIT before the printk
> format string? So that it looks like printk(KERN_CRIT "XXX: ...").
> 
> Thanks.
> 

Hello,

no, changing to  printk(KERN_CRIT "XXX: ...", ...)  in kernel/workqueue.c didn't
print anything I could read. Would it appear before the "panic screen"? But I'm
not able to scroll back.
The Panic screen starts with

BUG: Unable to handle kernel NULL pointer dereference at 0000000000000008
IP: [<ffffffff8103eef1>] delayed_work_timer_fn+0x13/0x70

and the Call Trace with

Call Trace:
 <IRQ>
 [<ffffffff81056fbf>] ? ktime_get+0x5f/0xf0
 [<ffffffff810342c6>] ? run_timer_softirq+0x106/0x220
 [<ffffffff8105cc44>] ? tick_handle_oneshot_broadcast+0xc4/0xe0

Do I need special settings in the kernel config?

-- 
Best regards,
Jörg-Volker.


