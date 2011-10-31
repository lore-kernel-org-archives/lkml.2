Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab1JaVXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 17:23:31 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42522 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937Ab1JaVX3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 17:23:29 -0400
MIME-Version: 1.0
In-Reply-To: <20111101081554.52ee5b38@notabene.brown>
References: <201110132145.42270.rjw@sisk.pl>
	<CACVXFVO_qNoy=AMs4RQOPsNq5dnTsc-=-f70Njf9Hv8eRkx=+Q@mail.gmail.com>
	<20111101081554.52ee5b38@notabene.brown>
Date: Tue, 1 Nov 2011 05:23:29 +0800
Message-ID: <CACVXFVPVSdwoME1s477dNwy0Ez6=NQkcPWEOkvNmxBOu84RYAw@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/2] PM / Sleep: Extended control of
 suspend/hibernate interfaces
From: Ming Lei <tom.leiming@gmail.com>
To: NeilBrown <neilb@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Nov 1, 2011 at 5:15 AM, NeilBrown <neilb@suse.de> wrote:
> On Tue, 1 Nov 2011 03:55:50 +0800 Ming Lei <tom.leiming@gmail.com> wrote:
>
>> Hi,
>>
>> On Fri, Oct 14, 2011 at 3:45 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>
>> > Second, to address the backup problem, we need to allow user space
>> > processes other than the suspend/hibernate process itself to prevent the
>> > system from being put into sleep states.  A mechanism for that is introduced
>> > by the second patch in the form of the /dev/sleepctl special device working
>> > kind of like user space wakelocks on Android (although in a simplified
>> > fashion).
>>
>> I also have another similar example: write(fd, buffer, 100*4096).
>>
>> Suppose only 80*4096 are copied into pages of the file, then someone
>> run ' echo mem > /sys/power/state ' to trigger system sleep, so only
>> partial writing is completed before system sleep and data inconsistence
>> may be caused for the file on filesystem.
>>
>> But I am not sure if it is possible to happen in reality.
>>
>> thank,
>
> I'm not sure if it is possible either, but even if it is it isn't a new
> problem.  A suspend is expected to leave all sorts of external things in
> inconsistent states. The contents of memory implicitly records all these
> inconsistencies and allows them to be resolved in the normal course of things
> after resume.
> If you lose power to memory during suspend then you can certainly expect
> filesystems to be corrupted in exactly the same sort of way that they can be

Also if the external some usb mass storage is disconnected during suspend, then
filesystem on the device may be corrupted too, but it is a very reason operation
for user.

> corrupted by a crash.  This has always been the case and I assume always will
> (until we get main-memory that preserves state without power)
>
> We want to block suspend during backups not to avoid corruption but simply to
> allow the backups to complete promptly.

Yes, it does make sense.

thanks,
-- 
Ming Lei
