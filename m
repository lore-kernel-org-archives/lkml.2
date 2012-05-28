Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478Ab2E1Jlx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 05:41:53 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64088 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab2E1Jlv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 05:41:51 -0400
MIME-Version: 1.0
In-Reply-To: <20120421062130.GC27551@core.coreip.homeip.net>
References: <1328084386-31110-1-git-send-email-clchiou@chromium.org>
 <1328671497-20880-1-git-send-email-clchiou@chromium.org> <CAGS+omDWrSyLtDYWAubyc5F=BUqKOnKmCnyWPn5nNcoREar_aw@mail.gmail.com>
 <20120421062130.GC27551@core.coreip.homeip.net>
From: Che-liang Chiou <clchiou@chromium.org>
Date: Mon, 28 May 2012 17:41:09 +0800
X-Google-Sender-Auth: Pp_r1KCcn-JdpirgdHKqhI1e7vE
Message-ID: <CANJuy2+Gboe-_3boJ3NEMKH_FpDZX_+73KDaykBqdazDNSwzZA@mail.gmail.com>
Subject: Re: [PATCH 0/5] Input: serio_raw - add monitor/replay debugging interface
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Daniel Kurtz <djkurtz@google.com>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

I am sorry for getting back to you so late. See below.

On Sat, Apr 21, 2012 at 2:21 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Tue, Feb 14, 2012 at 11:18:38AM +0800, Daniel Kurtz wrote:
>> On Wed, Feb 8, 2012 at 11:24 AM, Che-Liang Chiou <clchiou@chromium.org> wrote:
>> >
>> > The serio_raw driver is designed to provide "raw access" to mice, keyboards
>> > etc; thus, a driver accessing serio_raw may live entirely in userland.
>> >
>> > However, serio_raw lacks testability.  It is practically impossible to do
>> > regression tests on changes to a serio_raw -based userland driver.  On the other
>> > hand, the kernel's input subsystem has good testability support.  With the help
>> > of tools like utouch-evemu, we may capture and replay input events for evdev
>> > drivers in regression tests.
>> >
>> > This patchset contains extensions to the serio_raw driver which add debugfs
>> > entries for monitoring and replaying byte sequence between a userland driver
>> > and device.  These byte sequences can be used in regression tests of the
>> > userland driver.  This patchset closes the gap between serio_raw and the input
>> > subsystem regarding testability.
>> >
>> > This patchset is successfully applied on kernel version 3.3-rc2.
>> >
>> > Che-Liang Chiou (5):
>> >  Input: serio_raw - return proper result when serio_raw_read fails
>> >  Input: serio_raw - extract queue interface
>> >  Input: serio_raw - factor out common pattern of write
>> >  Input: serio_raw - add debugfs interface
>> >  Input: serio_raw - implement debugfs interface
>>
>> For patches 3-5:
>> Reviewed-by: Daniel Kurtz <djkurtz@google.com>
>>
>> For patch 1 (and its implication on queue_read() in patch 2, I'd
>> prefer to hear feedback from the list.
>
> I have already taken the patch 1, but I am unsure why we need kernel
> support for the monitor and replay. It seems you should only need a
> userspace program that would sit between the driver being tested and
> serio_raw misc device and pipe data back and forth, optionally saving
> it for subsequent replay.

Sadly some user space drivers hard codes path, like
"/dev/serio_raw%d", and quite often their source codes are not
available; so it is effectively impossible to monitor these drivers
without kernel's help.

Besides, changing from accessing a char device to communicating
through IPC requires rewriting the user space driver, no matter it's a
pair of named pipes or a socket. This may sometimes be quite hard
depending on the I/O strategy of the driver.

> Thanks.
>
> --
> Dmitry

Regards,
Che-Liang
