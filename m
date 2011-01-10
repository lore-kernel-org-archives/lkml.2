Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641Ab1AJIOc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 03:14:32 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:57794 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab1AJIOa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 03:14:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FN2g7ZyjI98Uc/ze/kl/HuU94gbciOBj9vBB3rzMl3ESHelszRH2f85eXC+2tmQcR2
         rdh2EFwXS28QJbhbsBgh8JeFmzGrJmrpn+WNBsCt3eX7/811eVEXHxlbjm7HKoGleI4F
         vYb4eN4XnC8RhiNPU29QR8130y//V/75/aNLE=
MIME-Version: 1.0
In-Reply-To: <20110110080839.GA16066@atrey.karlin.mff.cuni.cz>
References: <4D25AF02.60208@gmail.com>
	<AANLkTimGt5hi+TpFHWxktJEg3tcDQmmARdqFqzAt++OQ@mail.gmail.com>
	<4D2777FC.6040509@gmail.com>
	<AANLkTimtvYfHXG=rMLbFLzVaKbfB6nrj_ZE1AH4quRG2@mail.gmail.com>
	<4D281D65.1070102@gmail.com>
	<20110110080839.GA16066@atrey.karlin.mff.cuni.cz>
Date: Mon, 10 Jan 2011 09:14:29 +0100
Message-ID: <AANLkTi=DbZ8eU05Sq0jxpCTNKm7rW52FWVNbR16U3Zse@mail.gmail.com>
Subject: Re: [PATCH 01/17] pramfs: documentation
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Tony Luck <tony.luck@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/1/10 Pavel Machek <pavel@ucw.cz>:
>> On 07/01/2011 22:59, Tony Luck wrote:
>> > On Fri, Jan 7, 2011 at 12:30 PM, Marco Stornelli
>> > <marco.stornelli@gmail.com> wrote:
>> >> constraint). About the errors: pramfs does not maintain file data in the
>> >> page caches for normal file I/O, so no writeback, the read/write
>> >> operation are done with direct io and they are always sync. The data are
>> >> write protected in hw when the arch provide this facility (x86 does).
>> >> Inode contains a checksum and when there are problems they are marked as
>> >> bad. Superblock contains checksum and there is a redundant superblock.
>> >
>> > But you can still get pramfs inconsistencies if the system crashes at an
>> > inopportune moment. E.g. when making files you write the new inode to
>> > pramfs, and then you insert the entry into the directory. A crash between
>> > these two operations leaves an allocated inode that doesn't appear in
>> > any directory.  Without a fsck option, it will be hard to see that you have
>> > this problem, and your only recovery option is to wipe *all* files by making
>> > a new filesystem.
>>
>> Is it a problem if you lost some logs? However do you expect that fsck
>> in this case will drop the inode?
>
> Ask it the other way around.
>
> What is persistent filesystem good for when it is only persistent
> sometimes?
>
> You'd be better running ext2 over special block device, it is quite simple.
>

Ok I can work on it. However can an userspace tool prevent the insert
of fs in linux next?

Marco
