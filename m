Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab1LVCej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 21:34:39 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54755 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab1LVCeh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 21:34:37 -0500
MIME-Version: 1.0
In-Reply-To: <20111222014718.GA13085@suse.de>
References: <4EF264C3.6000104@am.sony.com> <20111221231956.GB23859@suse.de>
 <4EF27B85.9080801@am.sony.com> <20111222005114.GA22541@suse.de>
 <4EF288B4.1070601@am.sony.com> <20111222014718.GA13085@suse.de>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 22 Dec 2011 03:34:16 +0100
Message-ID: <CAPXgP120iT_MiUgP96nqXtTHbNut7852f+4FKLYVZXVLZGJBug@mail.gmail.com>
Subject: Re: RFC: android logger feedback request
To: Greg KH <gregkh@suse.de>
Cc: Tim Bird <tim.bird@am.sony.com>,
        linux-embedded <linux-embedded@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, john stultz <johnstul@us.ibm.com>,
        Brian Swetland <swetland@google.com>,
        Lennart Poettering <lennart@poettering.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 02:47, Greg KH <gregkh@suse.de> wrote:
> On Wed, Dec 21, 2011 at 05:32:36PM -0800, Tim Bird wrote:
>> On 12/21/2011 04:51 PM, Greg KH wrote:
>> > On Wed, Dec 21, 2011 at 04:36:21PM -0800, Tim Bird wrote:
>> >> On 12/21/2011 03:19 PM, Greg KH wrote:
>>
>> > Huh, I'm not talking about syslogd, I'm talking about the syslog(2)
>> > syscall we have.
>>
>> OK - switching gears.  Since the kernel log buffer isn't normally
>> used to store use-space messages, I thought you were referring
>> to syslog(3) and the associated (logger(1) and syslogd(8)).
>
> The kernel log buffer has been storing userspace messages for a while
> now, look at your boot log on the latest Fedora and openSUSE releases
> (or any other distro using systemd for booting).

Right, and the kernel's printk buffer support numbered facilities,
like the syslog protocol defines, just fine.

Stuff injected into the kernel from userspace can easily distinguished
from kernel generated messages when pulled out by userspace.

We use that currently to do early boot logging, when no syslog is running:
  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=9d90c8d9cde929cbc575098e825d7c29d9f45054

Kay
