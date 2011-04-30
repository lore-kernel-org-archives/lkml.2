Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760468Ab1D3AY0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 20:24:26 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33501 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760278Ab1D3AYR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 20:24:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=BcOAhfZSbNvFBz9/WBiv2ABZ91JEAaJZ+pDflG+NN4isr1hFcRxntm+o14G/L09zz7
         6+3jyvmo+lB5yYPkjFgStDJu00B0Nyw3XL0xXrMQTKYPJq0MoTkuM58OAcMHmaVwIiFq
         WuhTK9aN+pd47DFpUmNfy2BTK8TYisnLD7qHU=
MIME-Version: 1.0
In-Reply-To: <20110430001641.GC18929@tux1.beaverton.ibm.com>
References: <20110429234805.GA20579@tux1.beaverton.ibm.com>
	<BANLkTimm00fwBukO_C=wS_jK6090rdj2pw@mail.gmail.com>
	<20110430001641.GC18929@tux1.beaverton.ibm.com>
Date: Fri, 29 Apr 2011 18:24:16 -0600
X-Google-Sender-Auth: utmEcvQ-KH0DMyBT9LoQqd28V7w
Message-ID: <BANLkTimzOxJTf5x8_odoogXF72wwP=6_+w@mail.gmail.com>
Subject: Re: Premature -ENOSPC on btrfs?
From: cwillu <cwillu@cwillu.com>
To: djwong@us.ibm.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 6:16 PM, Darrick J. Wong <djwong@us.ibm.com> wrote:
> On Fri, Apr 29, 2011 at 06:00:16PM -0600, cwillu wrote:
>> On Fri, Apr 29, 2011 at 5:48 PM, Darrick J. Wong <djwong@us.ibm.com> wrote:
>> > Hi,
>> >
>> > I was giving btrfs (2.6.39-rc4) a quick tryout today and noticed some odd
>> > behavior when running a rather stupid test.
>> >
>> > First, I create a 1GB test fs, format it, and mount it.  Then, I run the
>> > following command to create a huge file, truncate it, rewrite it, and report
>> > what size file got created.
>> >
>> > # while true; do dd if=/dev/zero of=/mnt/testfile bs=1024k; done
>> >
>> > This is roughly what I see in terms of file size after filtering out all the
>> > "dd: writing `/mnt/testfile': No space left on device" messages.
>> >
>> > 782237696 bytes (782 MB) copied, 16.5647 s, 47.2 MB/s
>> > 545259520 bytes (545 MB) copied, 14.061 s, 38.8 MB/s
>> > 780140544 bytes (780 MB) copied, 15.2959 s, 51.0 MB/s
>> > 933232640 bytes (933 MB) copied, 15.2241 s, 61.3 MB/s
>> > 827326464 bytes (827 MB) copied, 14.8383 s, 55.8 MB/s
>> > 931135488 bytes (931 MB) copied, 15.1554 s, 61.4 MB/s
>> > 936378368 bytes (936 MB) copied, 2.98301 s, 314 MB/s
>> > 393216000 bytes (393 MB) copied, 12.9202 s, 30.4 MB/s
>> > 387973120 bytes (388 MB) copied, 13.4906 s, 28.8 MB/s
>> > 932184064 bytes (932 MB) copied, 15.3356 s, 60.8 MB/s
>> > 785383424 bytes (785 MB) copied, 14.6429 s, 53.6 MB/s
>> > 927989760 bytes (928 MB) copied, 15.4386 s, 60.1 MB/s
>> > 833617920 bytes (834 MB) copied, 14.6289 s, 57.0 MB/s
>> > 936378368 bytes (936 MB) copied, 3.33651 s, 281 MB/s
>> > 393216000 bytes (393 MB) copied, 12.9689 s, 30.3 MB/s
>> > 389021696 bytes (389 MB) copied, 6.02794 s, 64.5 MB/s
>> > 294649856 bytes (295 MB) copied, 1.05144 s, 280 MB/s
>> >
>> > Strangely, df reports that free space remains, and I can even create a second
>> > file to fill the empty space, so clearly the fs isn't full yet.  Is this the
>> > intended behavior of btrfs?  ext4/vfat seem to produce the same size file
>> > every time.
>>
>> https://btrfs.wiki.kernel.org/index.php/FAQ#if_your_device_is_small
>>
>> You'll want to use mixed block groups with such a small filesystem.
>
> The wiki seems dead, but the Google cache version implies that 2.6.37+ takes
> care of enabling mixed block groups already.  I also pulled btrfsprogs git and
> built a new mkfs, but that didn't seem to solve anything.

The wiki does that frequently :(

Check the tmp branch of the progs git;  there should be a -M option to
mkfs.btrfs.
