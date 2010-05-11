Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602Ab0EKC2j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 22:28:39 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:54631 "HELO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752052Ab0EKC2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 22:28:37 -0400
From: Michael Poole <mdpoole@troilus.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-bluetooth@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: magicmouse: claimed by neither input, hiddev nor hidraw
References: <j2idd18b0c31005101341o43b652c1zf8729f5f9a60e0d3@mail.gmail.com>
	<alpine.LRH.2.00.1005102334140.14809@twin.jikos.cz>
	<s2odd18b0c31005101439v22d03bfdw4e65d7c4b8315b6a@mail.gmail.com>
	<alpine.LNX.2.00.1005102351220.28092@pobox.suse.cz>
	<4BE8859E.3090305@gmail.com>
Date: Mon, 10 May 2010 22:28:32 -0400
In-Reply-To: <4BE8859E.3090305@gmail.com> (Justin P. Mattock's message of
	"Mon, 10 May 2010 15:15:58 -0700")
Message-ID: <87mxw7i33j.fsf@troilus.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin P. Mattock writes:

> On 05/10/2010 02:52 PM, Jiri Kosina wrote:
[snip]
>> This sounds a bit strange.
>>
>> hidraw shouldn't be making too much difference in the case you describe.
>> hidraw is basically just a mean of relaying HID events to userspace so
>> that any driver/application in userspace can access them. But magicmouse
>> driver is written completely in kernelspace.
>>
>> Does anything on your system have /dev/hidraw* nodes open? (you could
>> check by lsof).
>>
>
>
> right now I see
> /dev/hidraw0,1,2,3
>
> ./lsof | grep /dev
> (showing bluetooth)
>
> bluetooth 2020   root    0u      CHR                1,3       0t0 2551
> /dev/null
> bluetooth 2020   root    1u      CHR                1,3       0t0 2551
> /dev/null
> bluetooth 2020   root    2u      CHR                1,3       0t0 2551
> /dev/null
> bluetooth 2020   root   14u      CHR              10,62       0t0 3895
> /dev/rfkill
>
> I can try a bisect on this and see.

A list of which patches you have applied would also be helpful.  The
standard 2.6.33.* kernels predate the merge of the hid-magicmouse
driver, but the dmesg entry you pasted makes it look like the driver was
present.

Michael Poole
