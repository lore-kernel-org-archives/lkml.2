Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab1FYPvv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 11:51:51 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:51561 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767Ab1FYPvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 11:51:50 -0400
Message-ID: <4E06040B.7040309@free.fr>
Date: Sat, 25 Jun 2011 17:51:39 +0200
From: f6bvp <f6bvp@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110501 Mandriva/3.1.10-0.1mdv2010.2 (2010.2) Thunderbird/3.1.10
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Ralf Baechle <ralf@linux-mips.org>, linux-kernel@vger.kernel.org,
        Linux Netdev List <netdev@vger.kernel.org>, linux-hams@vger.kernel.org
Subject: Re: [AX25] inconsistent lock state
References: <4B2CD772.1030106@upmc.fr> <201106171536.15660.arnd@arndb.de> <20110617135147.GA3470@linux-mips.org> <201106171611.10655.arnd@arndb.de>
In-Reply-To: <201106171611.10655.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I applied the patch and since then I could not reproduce the
inconsistent lock state.
Thus mkiss patch fixed it.

Thanks,

Bernard

Le 17/06/2011 16:11, Arnd Bergmann a écrit :
> On Friday 17 June 2011 15:51:48 Ralf Baechle wrote:
>> On Fri, Jun 17, 2011 at 03:36:15PM +0200, Arnd Bergmann wrote:
>>
>> (Removed Jarek from cc; his email bounces.)
>>
>>> The message hints that disc_data_lock is aquired with softirqs disabled,
>>> but does not itself disable softirqs, which can in rare circumstances
>>> lead to a deadlock.
>>>
>>> Does this fix it?
>> If so, drivers/net/hamradio.c, function sp_get() would probably need the
>> equivalent fix.  Same for drivers/net/ppp_async.c:ap_get() and sp_get() in
>> drivers/net/ppp_synctty.c.
> It seems that ppp_synctty.c is ok, it uses write_lock_irq() already,
> sixpack.c looks like it has the same bug as mkiss. I also realized
> after sending out the patch that only the write_lock needs to be
> changed to write_lock_bh, while read_lock can leave softirqs enabled
> because it can be called recursively.
>
> 	Arnd

