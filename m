Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793Ab0EVVKc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 17:10:32 -0400
Received: from lo.gmane.org ([80.91.229.12]:37306 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758403Ab0EVVKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 17:10:30 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
connect(): No such file or directory
From: walt <w41ter@gmail.com>
Subject: Re: [2.6.34-git8][regression] massive polling problems with udevd
 and other processes
Date: Sat, 22 May 2010 14:10:07 -0700
Message-ID: <ht9h7l$tks$1@dough.gmane.org>
References: <201005221535.38939.shawn.starr@rogers.com> <4BF83CBF.8080300@gmail.com> <20100522204426.GO31073@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: adsl-69-234-199-35.dsl.irvnca.pacbell.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.3a5pre) Gecko/20100522 Thunderbird/3.2a1pre
In-Reply-To: <20100522204426.GO31073@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2010 01:44 PM, Al Viro wrote:
> On Sat, May 22, 2010 at 01:21:19PM -0700, walt wrote:
>> On 05/22/2010 12:35 PM, Shawn Starr wrote:
>>> Just built today's snapshot from linus's tree and have problems with udev
>>> using 100% cpu and KDE processes also pegging cpus.
>>>
>>> This is with Fedora 13 + snapshot kernel from git.
>>>
>>> Anyone else noticing this?
>>
>> Yes, just bisected it to this:
>>
>> commit a7cf4145bb86aaf85d4d4d29a69b50b688e2e49d
>> Author: Eric Paris<eparis@>
>> Date:   Fri May 14 11:44:10 2010 -0400
>>
>>      anon_inode: set S_IFREG on the anon_inode
>
> Cute...  Frankly, I'd be fine with just reverting that one and teaching
> selinux to STFU.  However, I wonder what specifically is getting polled.
> Which anon_inode users?
>
> Does anybody have strace handy?

I included only one of thousands of identical lines from strace of udevd at
the bottom of my previous post:

poll([{fd=4, events=POLLIN}, {fd=5, events=POLLIN}, {fd=6, events=POLLIN}, {fd=7, events=POLLIN}, {fd=8, events=POLLIN}], 5, -1) = 1 ([{fd=6, revents=POLLIN}])

Let me know if that's not what you need.

