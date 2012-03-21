Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705Ab2CUJJG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 05:09:06 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36940 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479Ab2CUJJC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 05:09:02 -0400
MIME-Version: 1.0
In-Reply-To: <4F662AFB.9050106@yahoo.co.jp>
References: <4F5ECD06.3000608@yahoo.co.jp>
	<4F5F7C4C.7080800@teksavvy.com>
	<4F662AFB.9050106@yahoo.co.jp>
Date: Wed, 21 Mar 2012 17:09:02 +0800
Message-ID: <CAMHSBOWg+rxxrVjf05r1tYDpW1S75XzdrLQ+U8TrjC9okRYtuA@mail.gmail.com>
Subject: Re: Fwd: libata-pmp patch for 3.2.x and later for eSATA Port
 Multiplier Sil3726
From: Gwendal Grignou <gwendal@google.com>
To: "ANEZAKI, Akira" <fireblade1230@yahoo.co.jp>
Cc: "IDE/ATA development list" <linux-ide@vger.kernel.org>,
        Mark Lord <kernel@teksavvy.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Akira,

- When you do the test between 3.1 and 3.2, do you cold boot the
machine every time?
- does the problem with 3.2 happens when you just reboot the machine
instead of cold booting?
Looking at your log, it seems you are using old drives that take a
long time to spinup.

We can see there are progress between 3.2.3 and 3.2.9:
In 3.2.3, we fail with qc_timeout and some drives are disabled.
In 3.2.9, we take time to spinup the drives, but finally all are found.

The patch you proposed seems to only have been tested with warm
reboot, not power cycle.
Please see http://www.spinics.net/lists/linux-ide/msg41699.html and
http://www.spinics.net/lists/linux-ide/msg41700.html for an
explanation why this patch is need.

Gwendal.

On Mon, Mar 19, 2012 at 2:35 AM, ANEZAKI, Akira
<fireblade1230@yahoo.co.jp> wrote:
> You may see these messages more easier when cold boot even if there are
> a few Sil3726 port multiplier:
>  :
>> [    0.000000] Linux version 3.2.10-3.fc16.i686.PAE (mockbuild@x86-02.phx2.fedoraproject.org) (gcc version 4.6.2 20111027 (Red Hat 4.6.2-1) (GCC) ) #1 SMP Thu Mar 15 20:37:01 UTC 2012
>  :
>> [    3.764070] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [    3.764394] ata5.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
>> [    3.767216] ata5.00: hard resetting link
>> [    4.105264] ata5.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
>> [    4.105300] ata5.01: hard resetting link
>> [    4.421064] ata5.01: softreset failed (SRST command error)
>> [    4.421078] ata5.01: failed to read SCR 0 (Emask=0x40)
>> [    4.421085] ata5.01: reset failed (errno=-85), retrying in 10 secs
>> [   14.105089] ata5.01: reset failed, giving up
>> [   14.105100] ata5.15: hard resetting link
>> [   16.226094] ata5.15: softreset failed (SRST command error)
>> [   16.226102] ata5.15: reset failed (errno=-5), retrying in 8 secs
>> [   24.105243] ata5.15: hard resetting link
>> [   26.226231] ata5.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [   26.226242] ata5.15: PMP revalidation failed (errno=-19)
>> [   31.226079] ata5.15: hard resetting link
>> [   33.358086] ata5.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [   33.358388] ata5.00: hard resetting link
>> [   33.696256] ata5.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
>> [   33.696291] ata5.01: hard resetting link
>> [   34.034255] ata5.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [   34.034292] ata5.02: hard resetting link
>> [   34.460042] ata5.02: softreset failed (SRST command error)
>> [   34.460064] ata5.02: failed to read SCR 0 (Emask=0x40)
>> [   34.460070] ata5.02: reset failed (errno=-85), retrying in 10 secs
>> [   44.034216] ata5.02: reset failed, giving up
>> [   44.034225] ata5.15: hard resetting link
>> [   44.034230] ata5: controller in dubious state, performing PORT_RST
>> [   46.188102] ata5.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [   46.188403] ata5.00: hard resetting link
>> [   46.526267] ata5.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
>> [   46.526301] ata5.01: hard resetting link
>> [   46.864262] ata5.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [   46.864297] ata5.02: hard resetting link
>> [   47.202253] ata5.02: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [   47.202288] ata5.03: hard resetting link
>> [   47.628038] ata5.03: softreset failed (SRST command error)
>> [   47.628052] ata5.03: failed to read SCR 0 (Emask=0x40)
>> [   47.628058] ata5.03: reset failed (errno=-85), retrying in 10 secs
>> [   57.202189] ata5.03: reset failed, giving up
>> [   57.202197] ata5.15: hard resetting link
>> [   57.202202] ata5: controller in dubious state, performing PORT_RST
>> [   59.356051] ata5.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [   59.356397] ata5.00: hard resetting link
>> [   59.694252] ata5.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
>> [   59.694287] ata5.01: hard resetting link
>> [   60.032253] ata5.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [   60.032290] ata5.02: hard resetting link
>> [   60.370261] ata5.02: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [   60.370296] ata5.03: hard resetting link
>> [   60.708269] ata5.03: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [   60.708304] ata5.04: hard resetting link
>> [   61.013360] ata5.04: SATA link down (SStatus 0 SControl 320)
>> [   61.013422] ata5.05: hard resetting link
>  :
>> [   63.850067] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [   63.850427] ata6.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
>> [   63.853419] ata6.00: hard resetting link
>> [   64.180241] ata6.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
>> [   64.180280] ata6.01: hard resetting link
>> [   64.606036] ata6.01: softreset failed (SRST command error)
>> [   64.606054] ata6.01: failed to read SCR 0 (Emask=0x40)
>> [   64.606061] ata6.01: reset failed (errno=-85), retrying in 10 secs
>> [   74.180035] ata6.01: reset failed, giving up
>> [   74.180046] ata6.15: hard resetting link
>> [   74.180052] ata6: controller in dubious state, performing PORT_RST
>> [   76.334081] ata6.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [   76.334404] ata6.00: hard resetting link
>> [   76.661266] ata6.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
>> [   76.661305] ata6.01: hard resetting link
>> [   76.988320] ata6.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [   76.988357] ata6.02: hard resetting link
>> [   77.414044] ata6.02: softreset failed (SRST command error)
>> [   77.414057] ata6.02: failed to read SCR 0 (Emask=0x40)
>> [   77.414065] ata6.02: reset failed (errno=-85), retrying in 10 secs
>> [   86.988104] ata6.02: reset failed, giving up
>> [   86.988114] ata6.15: hard resetting link
>> [   86.988120] ata6: controller in dubious state, performing PORT_RST
>> [   89.142149] ata6.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [   89.142465] ata6.00: hard resetting link
>> [   89.469329] ata6.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
>> [   89.469367] ata6.01: hard resetting link
>> [   89.796252] ata6.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [   89.796289] ata6.02: hard resetting link
>> [   90.123242] ata6.02: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [   90.123277] ata6.03: hard resetting link
>> [   90.549042] ata6.03: softreset failed (SRST command error)
>> [   90.549058] ata6.03: failed to read SCR 0 (Emask=0x40)
>> [   90.549065] ata6.03: reset failed (errno=-85), retrying in 10 secs
>> [  100.123063] ata6.03: reset failed, giving up
>> [  100.123072] ata6.15: hard resetting link
>> [  100.123078] ata6: controller in dubious state, performing PORT_RST
>> [  102.277076] ata6.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> [  102.277392] ata6.00: hard resetting link
>> [  102.604240] ata6.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
>> [  102.604278] ata6.01: hard resetting link
>> [  102.931241] ata6.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [  102.931279] ata6.02: hard resetting link
>> [  103.258256] ata6.02: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [  103.258292] ata6.03: hard resetting link
>> [  103.585257] ata6.03: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> [  103.585294] ata6.04: hard resetting link
>> [  103.890368] ata6.04: SATA link down (SStatus 0 SControl 320)
>> [  103.890433] ata6.05: hard resetting link
>> [  104.195336] ata6.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
>  :
>
>
> (2012/03/14 01:56), Mark Lord wrote:
>> Sounds like a regression from 3.1 to 3.2.
>> Copying linux-ide & Jeff.
>>
>> -------- Original Message --------
>> Subject: libata-pmp patch for 3.2.x and later for eSATA Port Multiplier Sil3726
>> Date: Tue, 13 Mar 2012 13:28:54 +0900
>> From: ANEZAKI, Akira <fireblade1230@yahoo.co.jp>
>> To: linux-kernel@vger.kernel.org
>>
>> Hi!
>>
>> I'm in trouble on a PC that has 6 eSATA port multiplier.
>>
>>>From kernel 3.2.x, kernel fails to boot when many HDDs are connected to
>> many eSATA port multiplier with Sil3726.
>>
>> Kernel is repeating eSATA bus reset while booting and spend long time,
>> and result into fail to boot with timeout. It causes that some HDDs
>> cannot be seen from kernel on a PC that has 6 Sil3726 port multiplier.
>> dmesg contains many reset messages while booting like this:
>>    :
>>> [   48.060454] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>>> [   48.061150] ata6.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
>>> [   48.063158] ata6.00: hard resetting link
>>> [   48.401020] ata6.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
>>> [   48.401080] ata6.01: hard resetting link
>>> [   48.825741] ata6.01: softreset failed (SRST command error)
>>> [   48.935499] ata6.01: failed to read SCR 0 (Emask=0x1)
>>> [   48.935505] ata6.01: reset failed (errno=-85), retrying in 10 secs
>>    :
>>> [  294.950152] ata9: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>>> [  294.950453] ata9.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
>>> [  294.953382] ata9.00: hard resetting link
>>> [  304.937981] ata9.00: softreset failed (timeout)
>>> [  307.931302] ata9.15: qc timeout (cmd 0xe4)
>>> [  307.931318] ata9.00: failed to read SCR 0 (Emask=0x5)
>>> [  307.931322] ata9.00: reset failed, giving up
>>> [  307.931327] ata9.15: hard resetting link
>>> [  310.058635] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>>> [  310.059016] ata9.00: hard resetting link
>>> [  320.044490] ata9.00: softreset failed (timeout)
>>> [  323.037851] ata9.15: qc timeout (cmd 0xe4)
>>> [  323.037868] ata9.00: failed to read SCR 0 (Emask=0x5)
>>> [  323.037872] ata9.00: reset failed, giving up
>>    :
>>> [  556.513676] systemd[1]: Job dev-disk-by\x2dlabel-WORK.device/start timed out.
>>> [  556.513693] systemd[1]: Job fedora-autorelabel-mark.service/start failed with result 'dependency'.
>>> [  556.513816] systemd[1]: Job fedora-autorelabel.service/start failed with result 'dependency'.
>>> [  556.513833] systemd[1]: Job local-fs.target/start failed with result 'dependency'.
>>> [  556.513846] systemd[1]: Triggering OnFailure= dependencies of local-fs.target.
>>> [  556.515352] systemd[1]: Job mnt-work.mount/start failed with result 'dependency'.
>>> [  556.515368] systemd[1]: Job dev-disk-by\x2dlabel-WORK.device/start failed with result 'timeout'.
>>> [  556.851000] systemd[1]: Startup finished in 2s 212ms 906us (kernel) + 7min 44s 688ms 483us (initrd) + 1min 30s 977ms 147us (userspace) = 9min 17s 878ms 536us.
>>
>> When only one sentence in drivers/ata/libata-pmp.c only for Sil3726 back
>> to that in kernel 3.1.x, this problem is not seen. I attached the patch
>> file.
>>
>> This patch solves the problem on my PC but I can't understand ata
>> subsystem. So I'm afraid of side effect.
>>
>> Can you consider this patch?
>>
>> Best Regards,
>> ANEZAKI, Akira
>>
>> -------- Original Message --------
>> Subject: [Bug 787468] boot fails by timeout while activating RAIDs with
>> many HDDs
>> Date: Mon, 12 Mar 2012 16:30:45 -0400
>> From: bugzilla@redhat.com
>> To: fireblade1230@yahoo.co.jp
>>
>> Please do not reply directly to this email. All additional
>> comments should be made in the comments box of this bug.
>>
>>
>> https://bugzilla.redhat.com/show_bug.cgi?id=787468
>>
>> --- Comment #20 from Dave Jones <davej@redhat.com> 2012-03-12 16:30:43
>> EDT ---
>> can you post this patch upstream to linux-kernel@vger.kernel.org ?
>> if it is acceptable there, we will add it to the Fedora kernel.
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
