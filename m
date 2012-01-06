Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759168Ab2AFUn0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 15:43:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39410 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759119Ab2AFUnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 15:43:24 -0500
Message-ID: <4F075D40.6080001@canonical.com>
Date: Fri, 06 Jan 2012 12:44:48 -0800
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Input: evdev - Add EVIOC mechanism to extract the
 MT slot state
References: <1325863019-2242-1-git-send-email-rydberg@euromail.se> <CAN+gG=FUEH851Um4Lco0avqdE2Eup3Jo79Ti4T7XhxT=PO6WeQ@mail.gmail.com> <20120106181845.GA22653@core.coreip.homeip.net> <4F0743EE.6080302@canonical.com> <20120106195846.GA23619@core.coreip.homeip.net> <4F075500.3020601@canonical.com> <20120106201735.GA23818@core.coreip.homeip.net>
In-Reply-To: <20120106201735.GA23818@core.coreip.homeip.net>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2012 12:17 PM, Dmitry Torokhov wrote:
> On Fri, Jan 06, 2012 at 12:09:36PM -0800, Chase Douglas wrote:
>> I know there's a slight distinction between these two scenarios, but my
>> point is that if you are doing multithreaded evdev reading from the same
>> evdev fd, you are asking for trouble and you need to be careful. That
>> even goes for modifying any of the other state through EVIOCSABS from
>> multiple processes. And really, how many programs are out there reading
>> from the same evdev fd in multiple threads. I'd wager a fair amount of
>> money the answer is 0.
> 
> I am really not concerned about what userspace might do - I've looked at
> enough code to see all kinds of weird stuff. My task is to make sure
> that kernel interface is sane and since it is userspace ABI matter I
> want to be extra careful.

Evdev by its very nature is thread unsafe. There's no way to atomically
retrieve an event frame including all the new values up through the next
EV_SYN. That's the meat and potatoes of evdev. If the base of an API is
thread-unsafe, it does very little to add thread safety to functions
surrounding it.

If you want to make a line of demarcation to say that evdev reads are
not thread-safe, but ioctls are, then that makes a slight bit of
technical sense. However, it still seems like a fools errand to me,
because no one will ever make a multithreaded program that opens an
evdev device, accesses its ioctls through multiple threads, while never
reading from the evdev fd. If for some reason someone actually does
this, all they need is a simple mutex.

I really think this is a waste of time when Henrik's patch is ready to
go, is small and self contained, and meets everyone's needs. But this is
the last I'll speak of it.

-- Chase
