Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642Ab0HZKhO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 06:37:14 -0400
Received: from smtpauth.tellcom.com.tr ([92.45.6.169]:23446 "EHLO
	smtpout2.superonline.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752000Ab0HZKhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 06:37:11 -0400
Message-ID: <4C7643C7.4010904@superonline.com>
Date: Thu, 26 Aug 2010 13:36:55 +0300
From: "M. Vefa Bicakci" <bicave@superonline.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.8) Gecko/20100821 Icedove/3.1.2
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bisected Regression in 2.6.35] A full tmpfs filesystem causeshibernationto hang
References: <20100825173231.F3E7.A69D9226@jp.fujitsu.com> <4C74EB70.3080406@superonline.com> <20100826134506.F676.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100826134506.F676.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SMTP-Filter: SurGATE SMTP Filter Engine Release 2.1 ($Revision: 184 $) http://www.endersys.com
X-SurGATE-Result: Clean (Content eval: 2.00 points)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/08/10 11:09 AM, KOSAKI Motohiro wrote:
>> If there is anything I can do to debug this problem please let me
>> know.
> 
> Vefa, your above log is very useful. really thanks.
> So, I'm convinced two things.
>  - my patch is purely unrelated.
>  - how to fix your issue.
> 
> Can you please try attached patch? I bet this can solve your issue.
> 
> Thanks for your patience.

Hello!

First of all, thanks a lot for your help - I really appreciate it.

I applied your new patches on top of your old patches. Hopefully that
was okay.

Unfortunately, it didn't work this time. Here's a sample output from the
new patch.

=== 8< ===
[58.050208] PM: Preallocating image memory...
[58.159881] shrink_all_memory start
[58.232411] PM: shrink memory: pass=1, req:312373 reclaimed:15864 free:358420
[58.342041] PM: shrink memory: pass=2, req:296509 reclaimed:21837 free:362167
[60.690035] PM: shrink memory: pass=3, req:274672 reclaimed:25982 free:348006
[61.754931] PM: shrink memory: pass=4, req:248690 reclaimed:49623 free:371589
[64.361714] PM: shrink memory: pass=5, req:199067 reclaimed:74683 free:396695
[64.361769] shrink_all_memory: req:124384 reclaimed:74683 free:396695
=== >8 ===

The interesting thing is that even though there is a lot of free memory at the
end, it still hangs. I also included the timestamps; note the one and two second
delays between the passes.

Please let me know if there is anything I can do.

Regards,

M. Vefa Bicakci
