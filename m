Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935441Ab0HFHoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 03:44:20 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57203 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933570Ab0HFHoS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 03:44:18 -0400
MIME-Version: 1.0
In-Reply-To: <4C5B6065.7000700@free.fr>
References: <4C5734A2.7070400@free.fr> <4C59B444.7080609@nortel.com> 
	<4C5B6065.7000700@free.fr>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 6 Aug 2010 09:44:02 +0200
Message-ID: <AANLkTi=h633N2toWEHqwubVf8Hd21==+4Or7h=35d+Kr@mail.gmail.com>
Subject: Re: mount notification question
To: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: Chris Friesen <cfriesen@nortel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 6, 2010 at 03:07, Daniel Lezcano <daniel.lezcano@free.fr> wrote:
> On 08/04/2010 08:41 PM, Chris Friesen wrote:
>> On 08/02/2010 03:12 PM, Daniel Lezcano wrote:
>>> is there a way to be notified when a mount occurs on the system ?
>>
>> Have you looked on google?  The link is a bit misleading but they do
>> give a way to do it (not using inotify).
>>
>> http://stackoverflow.com/questions/1113176/how-could-i-detect-when-a-directory-is-mounted-with-inotify
>
> Thanks a lot for the pointer. I am not sure this solution will work, because
> it is inadequate for watching a specific location in a container context
> separated by the mount and the network namespaces. We have multiple mount
> points at the same place (eg. the mount point inheritance, the container
> configuration and the init scripts may mount /dev or /var/run several time)
> and the network namespace separation will make impossible to watch udev
> event via a netlink socket. I didn't look at the inotify implementation but
> IMHO, it should be worth to add IN_MOUNT and IN_UNMOUNT events for inotify
> no ?

These events wouldn't work, and they are long removed from the kernel
and don't exist.

You need to poll() /proc/mounts, and any changes in it will wake you
up with POLL_ERR. /proc/mounts should be namespace aware.

Kay
