Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173Ab0EVW7Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 18:59:24 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45440 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759017Ab0EVW7X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 18:59:23 -0400
MIME-Version: 1.0
In-Reply-To: <20100522204426.GO31073@ZenIV.linux.org.uk>
References: <201005221535.38939.shawn.starr@rogers.com>
	 <4BF83CBF.8080300@gmail.com>
	 <20100522204426.GO31073@ZenIV.linux.org.uk>
Date: Sat, 22 May 2010 18:59:22 -0400
Message-ID: <AANLkTimffWnIjHIEW54AoVxiALEoFkJZJJ7u57ZChDuy@mail.gmail.com>
Subject: Re: [2.6.34-git8][regression] massive polling problems with udevd and 
	other processes
From: Eric Paris <eparis@parisplace.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: walt <w41ter@gmail.com>, linux-kernel@vger.kernel.org, eparis@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 22, 2010 at 4:44 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sat, May 22, 2010 at 01:21:19PM -0700, walt wrote:
>> On 05/22/2010 12:35 PM, Shawn Starr wrote:
>> >Just built today's snapshot from linus's tree and have problems with udev
>> >using 100% cpu and KDE processes also pegging cpus.
>> >
>> >This is with Fedora 13 + snapshot kernel from git.
>> >
>> >Anyone else noticing this?
>>
>> Yes, just bisected it to this:
>>
>> commit a7cf4145bb86aaf85d4d4d29a69b50b688e2e49d
>> Author: Eric Paris <eparis@>
>> Date:   Fri May 14 11:44:10 2010 -0400
>>
>>     anon_inode: set S_IFREG on the anon_inode
>
> Cute...  Frankly, I'd be fine with just reverting that one and teaching
> selinux to STFU.  However, I wonder what specifically is getting polled.
> Which anon_inode users?

On my system udev has both inotify and signalfd open.  He's asking for
more of the strace.  If the ONLY thing that udev is doing is polling
with no other syscalls at all it's a udev problem (although maybe one
where we have to maintain bug for bug compatibility.

Can you show us a more lines of strace context and the output of ls -l
/proc/$PID/fd ?  That should give us a better idea what udev is doing
and which anon_inode we are dealing with.

-Eric
