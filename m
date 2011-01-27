Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658Ab1A0H6o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 02:58:44 -0500
Received: from nm12-vm0.bullet.mail.ukl.yahoo.com ([217.146.183.246]:28173
	"HELO nm12-vm0.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751752Ab1A0H6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 02:58:42 -0500
X-Yahoo-Newman-Id: 834024.26591.bm@smtp131.mail.ukl.yahoo.com
X-Yahoo-SMTP: zgdcvJ6swBBcTOk5fgveL37ak9AQxYCP7GdO
X-YMail-OSG: QhUKMCkVM1ljH8xluDTmc8fkKBFpmvY7n5X1psYoZ6Dh0kI
 ShEiDJ7REwf3VdHTBxz8D4qH0TO4v_ysK4U926FTL8gyqK9M.trVRDO_dI9h
 2jXrCC20iZ_fGE_41hRcelxtaH572A8MeCAH4TvdLSd0YTXHKhfIo8VFe.jd
 0HIQcELelOq4So2DIZ8mUi6o67j_SOHmfZeJHqHcRTJjnkh7Co.WcA5QKdVb
 4Bsxc.zIjKj6QCuMNlHEdQKi.NZqOYw4RYgIDN45YgoBA9DQvpLw._6GHN9d
 l_QETYoTqUpc-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4D4125D6.4030309@yahoo.fr>
Date: Thu, 27 Jan 2011 08:59:18 +0100
From: Lionel Debroux <lionel_debroux@yahoo.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100131 Thunderbird/3.0.1
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, rjw@sisk.pl,
        colin.king@canonical.com
Subject: Re: Common boot/shutdown issues with the latest 2.6.37 (Mostly Asus
 laptops)
References: <556624.21214.qm@web28409.mail.ukl.yahoo.com> <4D3DDDA4.2080202@yahoo.fr> <alpine.LFD.2.02.1101242154090.6097@x980> <4D3FD00D.2040303@yahoo.fr>
In-Reply-To: <4D3FD00D.2040303@yahoo.fr>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.01.2011 08:41, Lionel Debroux wrote:
>>>>>> * 2.6.35 series: .4 and .6 boot successfully, .8 and .10 fail;
>>>>>> * 2.6.36 series: -rc2 boots successfully, .1 fails;
>>>>>> * 2.6.37 series: -rc4 fails.
>>>>>
>>>>> So it's probably a commit to the mainline tree which was picked
>>>>> by 2.6.35 maintainer to the stable tree (probably it was CC'ed)
>>>>> cause this.
>>>>>
>>>>> Does passing nolapic or acpi=off cures the issue?
>>>> IIRC, I tested at least one of these, without improvement.
>>>> I'll test again tonight, when I can physically access the
>>>> computer.
>>> None of nolapic, acpi=off, nolapic acpi=off enables 2.6.35.8 to
>>> boot on my ASUS F3Jv-AS022P.
>>> The kernel line is
>>> kernel /boot/vmlinuz root=/dev/sda9 nomce vga=791 nomodeset
>>> I've attached the 2.6.35.6 config.
>>
>> looks like you've bisected as far as:
>> 2.6.35.6 good
>> 2.6.35.8 bad
>>
>> can you try 2.6.35.7 and continue on to find which specific patch
>> in .stable broke your machine?
> The bisection between 2.6.35.6 and 2.6.35.8 is in progress, two steps
> left and no good kernel found yet (?!)
> Due to not having physical access to the computer during work time, I
> won't be able to finish until tonight.
Bisection log of the
git://git.kernel.org/pub/scm/linux/kernel/git/longterm/linux-2.6.35.y.git repository:

$ git bisect log
git bisect start
# good: [7273c1c64b2d4cb0ddfa7682ec7ab71dfe906398] Linux 2.6.35.6
git bisect good 7273c1c64b2d4cb0ddfa7682ec7ab71dfe906398
# bad: [f16e6e4df8ec41328d7e0841bc17f2a587eb2c67] Linux 2.6.35.8
git bisect bad f16e6e4df8ec41328d7e0841bc17f2a587eb2c67
# bad: [cd1bbdfed8ff5047d96ed27a3ee7b881069daf03] reiserfs: fix
dependency inversion between inode and reiserfs mutexes
git bisect bad cd1bbdfed8ff5047d96ed27a3ee7b881069daf03
# bad: [74352c5c9e2e5c914254d2588876c0c13333c6f5] V4L/DVB: gspca -
sn9c20x: Bad transfer size of Bayer images
git bisect bad 74352c5c9e2e5c914254d2588876c0c13333c6f5
# bad: [dc7237c6b7b529c5da2776cbb8b68cc74d1555c3] HID: hidraw, fix a
NULL pointer dereference in hidraw_ioctl
git bisect bad dc7237c6b7b529c5da2776cbb8b68cc74d1555c3
# bad: [e5d843fbf633dc65353bc08ee28f6b08ce651a4d] ALSA: hda - Add Dell
Latitude E6400 model quirk
git bisect bad e5d843fbf633dc65353bc08ee28f6b08ce651a4d
# bad: [9f09ac68e7af2001a24242cbe0f6e40e89dd6c62] x86, cpu: After
uncapping CPUID, re-run CPU feature detection
git bisect bad 9f09ac68e7af2001a24242cbe0f6e40e89dd6c62

--- up to this point, all kernels reboot ~1s after the messsage noting
vmlinuz being loaded disappears

# bad: [ea8a52f9f4bcc3420c38ae07f8378a2f18443970] Linux 2.6.35.7
git bisect bad ea8a52f9f4bcc3420c38ae07f8378a2f18443970

--- at this point, one commit before
9f09ac68e7af2001a24242cbe0f6e40e89dd6c62, the behaviour changes: the
computer does not reboot anymore, but it doesn't boot either. It hangs
with a backlit but black LCD. I let it alone for several minutes, it
didn't boot.
I double-checked by swapping twice between this kernel and the previous
one (9f09ac68e7af2001a24242cbe0f6e40e89dd6c62), falling back to the
2.6.35.6 compiled in late September 2010 to get the computer to boot and
swap kernels.

# bad: [b0dd220aefe1ab80823cf13e9588c64fec151488] Xen: fix typo in
previous patch
git bisect bad b0dd220aefe1ab80823cf13e9588c64fec151488

--- at this point, the kernel reboots again as most of the kernels in
this bisection did. The problem is,
ea8a52f9f4bcc3420c38ae07f8378a2f18443970 is a tag commit...

And obviously, bisection ends in:
b0dd220aefe1ab80823cf13e9588c64fec151488 is the first bad commit
commit b0dd220aefe1ab80823cf13e9588c64fec151488
Author: James Dingwall <james.dingwall@amdocs.com>
Date:   Mon Sep 27 09:37:17 2010 +0100

    Xen: fix typo in previous patch

    Correctly name the irq_chip structure to fix an immediate failure
when booting
    as a xen pv_ops guest with a NULL pointer exception. The missing 'x' was
    introduced in commit [fb412a178502dc498430723b082a932f797e4763]
applied to
    2.6.3[25]-stable trees.  The commit to mainline was
    [aaca49642b92c8a57d3ca5029a5a94019c7af69f] which did not have the
problem.

    Signed-off-by: James Dingwall <james@dingwall.me.uk>
    Reported-by: Pawel Zuzelski <pawelz@pld-linux.org>
    Tested-by: Pawel Zuzelski <pawelz@pld-linux.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

:040000 040000 81981a3f0c89adbdf28306b2dc23c631c815935f
ca642d7b5a94ad56c6179ba4d90e2281076672b9 M      drivers



But none of that makes any sense for multiple reasons...
I guess it's time for me to:
* try recompiling older kernel versions that I previously successfully
compiled to a kernel in proper booting state. But the package
installation history in Synaptic between September 27th 2010 (last
working kernel so far) and November 23th 2010 (first bad kernel) doesn't
show any upgrade of binutils or gcc...
* try out other kernel series: 2.6.32, 2.6.34, 2.6.37 and the 2.6.38-rc
series.


Sorry for the noise...


Regards,
Lionel.
