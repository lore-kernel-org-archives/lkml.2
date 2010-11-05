Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070Ab0KEXH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 19:07:28 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31510 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944Ab0KEXH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 19:07:26 -0400
Message-ID: <4CD48E04.2050709@oracle.com>
Date: Fri, 05 Nov 2010 16:06:44 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Pavel Roskin <proski@gnu.org>, "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.37-rc1 (libipw remove_proc_entry warning)
References: <AANLkTimr3rW67HxgOUyReEW8dmmSsd4b7-Ns57mXzS1w@mail.gmail.com> <20101103161837.fad11d79.randy.dunlap@oracle.com> <AANLkTimnHFHJq13xpJ0ZgLmpd+cHmHH5sQ4HWtL_MrMT@mail.gmail.com>
In-Reply-To: <AANLkTimnHFHJq13xpJ0ZgLmpd+cHmHH5sQ4HWtL_MrMT@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/10 15:24, Linus Torvalds wrote:
> This bug seems to be due to commit 27ae60f8f7aac ("ipw2x00: replace
> "ieee80211" with "libipw" where appropriate"), where Pavel did this:
> 
> -       libipw_proc = proc_mkdir(DRV_NAME, init_net.proc_net);
> +       libipw_proc = proc_mkdir("ieee80211", init_net.proc_net);
> 
> but then the cleanup was kept as
> 
>         remove_proc_entry(DRV_NAME, init_net.proc_net);
> 
> in both places (both in the failure case and in the unload case). The
> error string is also total crap, and says
> 
>      "Unable to create " DRV_NAME " proc directory\n");
> 
> Even though it doesn't actually create a proc directory named DRV_NAME at all.
> 
> So that patch looks like total and utter crap to me. The commit message says
> 
>   "Keep /proc/net/ieee80211 under the original name to avoid breaking user
>     interface."
> 
> but the thing is, it really didn't fix anything but that one create
> thing. It needs to fix all the other cases too.
> 
> Totally UNTESTED patch attached. It may or may not compile. And maybe
> it doesn't catch all cases, but it should catch the obvious ones.

That works for me.

Tested-by: Randy Dunlap <randy.dunlap@oracle.com>


thanks,
-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
