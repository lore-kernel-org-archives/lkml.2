Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661Ab2DFGN0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 02:13:26 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50161 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab2DFGNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 02:13:24 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1204051000450.1361-100000@iolanthe.rowland.org>
References: <20120405083245.GA19508@localhost.amd.com>
	<Pine.LNX.4.44L0.1204051000450.1361-100000@iolanthe.rowland.org>
Date: Fri, 6 Apr 2012 14:13:23 +0800
X-Google-Sender-Auth: iS5hllkIo6uTycH3_h8gjoM2Wbo
Message-ID: <CAF1ivSacvDoPK2t8OZ==o2nTqhzjh8ogrH5yEFKpyQ5zqn6SKQ@mail.gmail.com>
Subject: Re: [PATCH v3 7/7] [SCSI] sr: adds Zero-power ODD support
From: Lin Ming <ming.m.lin@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Aaron Lu <aaron.lu@amd.com>, Zhang Rui <rui.zhang@intel.com>,
        Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-acpi <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 5, 2012 at 10:03 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Thu, 5 Apr 2012, Aaron Lu wrote:
>
>> Hi,
>>
>> On Thu, Apr 05, 2012 at 02:00:57PM +0800, Lin Ming wrote:
>> > >
>> > > Another thing to consider is, user might want to eject the tray by
>> > > software like the
>> > > eject /dev/sr0 command or some UI mouse clicks against the cdrom icon. I'm still
>> > > thinking how to do this correctly.
>> >
>> > Assume eject /dev/sr0 is implemented as:
>> >
>> > int fd = open("/dev/sr0", ...)
>> > ioctl(fd, CDROMEJECT)
>> >
>>
>> Indeed, it is implemented as this :-)
>>
>> > We may need to resume ODD in the ioctl handler(scsi_cmd_ioctl).
>> >
>>
>> I prefer we do this in sr_block_ioctl.
>> Suppose the ODD is now runtime suspended and received an ioctl:
>> if the ioctl's cmd is CDROMEJECT, resume it.
>> For other cases, return an error code like EPERM.
>> When done, according to the result of ioctl: if success, leave it resumed;
>> if failed, put it back to sleep.
>
> Alternatively, you may want to do the runtime resume in sr_open and
> sr_block_open and the suspend in the corresponding release routines.
> It's up to you.

GNOME opens cdrom every seconds to check status.
So we won't get the desired power savings if we do the runtime resume
in sr_block_open.
See my previous mail.

>
> Alan Stern
