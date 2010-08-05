Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934874Ab0HEWoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:44:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42330 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934834Ab0HEWn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:43:57 -0400
Message-ID: <4C5B3E7B.6060505@zytor.com>
Date: Thu, 05 Aug 2010 15:43:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Greg KH <gregkh@suse.de>, john stultz <johnstul@us.ibm.com>,
        Alexander Shishkin <virtuoso@slind.org>, lkml@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Avi Kivity <avi@redhat.com>,
        John Kacur <jkacur@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] notify userspace about time changes
References: <1280926108-24668-1-git-send-email-virtuoso@slind.org> 	<1280937526.28884.21.camel@work-vm> <AANLkTin_5RVQo8qbJp=naN6WHdA39JM81Y+003E0SLOq@mail.gmail.com> 	<1281042665.3405.15.camel@localhost.localdomain> <20100805213851.GA13868@suse.de> 	<AANLkTimYmtXZe1Ue-z2D_5512RXz3xUSRWPiUUUY6rrz@mail.gmail.com> 	<4C5B3C65.8060703@zytor.com> <AANLkTinOxPoyPx3ERFKGFA+iLkvv==1=AYdtMsssvfRs@mail.gmail.com>
In-Reply-To: <AANLkTinOxPoyPx3ERFKGFA+iLkvv==1=AYdtMsssvfRs@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2010 03:39 PM, Kay Sievers wrote:
>>
>> Okay, what's wrong with having a file descriptor that gets *written to*
>> on a notification?
> 
> Because it needs documentation, and is just not needed for such a
> simple thing, I think. Why would you want to write a fd number to a
> magic file, which can be your fd right away, even passing you the data
> on read().
> 

I didn't mean that, I meant a note that you open and get a pipe/socket/*.

>> Why POLL_ERR?
> 
> Because normal files can not be poll()ed, and it's not that new data
> has arrived, it just tells you to rewind and read it again. It's
> commonly used:
>   http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=5addc5dd8836aa061f6efc4a0d9ba6323726297a

It makes sense there, I guess, as some kind of sideband notification is
highly useful.  Too bad we don't have a generic mechanism on files other
than inotify... a lot of things could use it (including tail, which I
think uses inotify now.)

	-hpa

