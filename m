Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927Ab1IWTV0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 15:21:26 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33521 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab1IWTVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 15:21:24 -0400
Message-ID: <4E7CDC30.8070607@gmail.com>
Date: Fri, 23 Sep 2011 21:21:20 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110918 Thunderbird/7.0
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Jiri Slaby <jslaby@suse.cz>, Greg KH <greg@kroah.com>,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 1/4] TTY: serial, fix locking imbalance
References: <1314818699-10873-1-git-send-email-jslaby@suse.cz> <20110922224653.GB21296@kroah.com> <4E7CD560.8010706@suse.cz> <20110923190840.GA31009@suse.de>
In-Reply-To: <20110923190840.GA31009@suse.de>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2011 09:08 PM, Greg KH wrote:
> On Fri, Sep 23, 2011 at 08:52:16PM +0200, Jiri Slaby wrote:
>> On 09/23/2011 12:46 AM, Greg KH wrote:
>>> On Wed, Aug 31, 2011 at 09:24:56PM +0200, Jiri Slaby wrote:
>>>> Commit "TTY: serial, move locking in uart_close" moved the lock, but
>>>> omitted to update branches which unlock the lock. Now they try to
>>>> unlock the lock without holding it.
>>>>
>>>> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
>>>> ---
>>>> If possible, please, merge this into the patch mentioned above (it's
>>>> not upstream yet).
>>>
>>> I can't do that,
>>
>> Hmm, but what is the reason for that? I mean, why do you prefer a kernel
>> with broken history with respect to bisection? Per definition -next
>> doesn't mind rebases in subtrees. Or is this already in tty-linus branch
>> (I cannot check now, obviously)?
> 
> Because it is in my tree and I can't rebase it as others depend on it
> (linux-next and others.)

linux-next doesn't mind if you rebase. That's exactly what it is for. To
test commits collected from #for-next branches and alter them if needed.
It merges whatever is in the current branch no matter what was there
some days ago.

But if there are more trees depending on the tree, then OK, I will live
with that ;).

thanks,
-- 
js
