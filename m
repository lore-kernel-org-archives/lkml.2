Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255Ab1C1T5J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 15:57:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57533 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756Ab1C1T5H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 15:57:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fLaM4MSVFE7Mke5wrKap4jIhqZcYwtgc9Uh6Z6ECS90A5sgK02FTBEyYHrJR708l6i
         rrcoQVeNwMod0BEC5zGY5Lyl6sA9r4sTmQz9Vi6N8jhJm89mJ2chIvasnFmLm5OISAm1
         SZV+hEy9sygMZHDFDoDyHOa0vu45Fl4yWczV8=
MIME-Version: 1.0
In-Reply-To: <20110328154543.1bb979fd@tlielax.poochiereds.net>
References: <20110328100846.0ba2e039@tlielax.poochiereds.net>
	<4D90C472.3090908@linux.vnet.ibm.com>
	<20110328141241.06a435f8@tlielax.poochiereds.net>
	<20110328154543.1bb979fd@tlielax.poochiereds.net>
Date: Tue, 29 Mar 2011 01:27:05 +0530
Message-ID: <AANLkTi=89x8P3m2gUhu1N=UAqa55JwhMB8TLvCvp1gwO@mail.gmail.com>
Subject: Re: TPM chip prevents machine from suspending
From: Sisir Koppaka <sisir.koppaka@gmail.com>
To: Jeff Layton <jlayton@poochiereds.net>
Cc: Stefan Berger <stefanb@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 1:15 AM, Jeff Layton <jlayton@poochiereds.net> wrote:
> On Mon, 28 Mar 2011 14:12:41 -0400
> Jeff Layton <jlayton@poochiereds.net> wrote:
>
>> On Mon, 28 Mar 2011 13:25:06 -0400
>> Stefan Berger <stefanb@linux.vnet.ibm.com> wrote:
>>
>> > On 03/28/2011 10:08 AM, Jeff Layton wrote:
>> > > My wife's machine apparently has a TPM chip in it. Since I upgraded it
>> > > to Fedora 14, it fails to suspend consistently. On the first attempt to
>> > > suspend it, it works fine. Once it has woken back up however, it will
>> > > not suspend again. Here's the dmesg log from such an attempt:
>> > >
>> > > [  202.460967] PM: Syncing filesystems ... done.
>> > > [  202.464818] PM: Preparing system for mem sleep
>> > > [  202.485968] Freezing user space processes ... (elapsed 0.01 seconds) done.
>> > > [  202.497079] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
>> > > [  202.508067] PM: Entering mem sleep
>> > > [  202.508086] Suspending console(s) (use no_console_suspend to debug)
>> > > [  202.508451] sd 3:0:0:0: [sdb] Synchronizing SCSI cache
>> > > [  202.508562] sd 2:0:0:0: [sda] Synchronizing SCSI cache
>> > > [  202.508616] sd 3:0:0:0: [sdb] Stopping disk
>> > > [  202.511956] parport_pc 00:0b: disabled
>> > > [  202.512127] serial 00:09: disabled
>> > > [  202.512134] serial 00:09: wake-up capability disabled by ACPI
>> > > [  202.536058] legacy_suspend(): pnp_bus_suspend+0x0/0x82 returns 38
>> > > [  202.536061] PM: Device 00:02 failed to suspend: error 38
>> > > [  202.997517] sd 2:0:0:0: [sda] Stopping disk
>> > > [  202.997806] PM: Some devices failed to suspend
>> > > [  202.998085] sd 2:0:0:0: [sda] Starting disk
>> > > [  202.998144] sd 3:0:0:0: [sdb] Starting disk
>> > > [  202.998614] serial 00:09: activated
>> > > [  202.999158] parport_pc 00:0b: activated
>> > > [  204.543094] PM: resume of devices complete after 1545.282 msecs
>> > > [  204.543268] PM: Finishing wakeup.
>> > > [  204.543270] Restarting tasks ... done.
>> > >
>> > > ...error 38 is ENOSYS, and the 00:02 is this:
>> > >
>> > > # cat /sys/bus/pnp/devices/00\:02/id
>> > > IFX0102
>> > > PNP0c31
>> > Also the tpm_tis driver handles both of these. Can you confirm which
>> > module that laptop was using  (tpm_tis or tpm_infineon) and try whether
>> > one of them works better than the other one? Please do a reboot between
>> > trying one and then the other.
>> >
>>
>> It's using tpm_tis:
>>
>> lrwxrwxrwx. 1 root root 0 Mar 28 13:40 /sys/bus/pnp/devices/00:02/driver -> ../../../bus/pnp/drivers/tpm_tis
>>
>> FWIW, the fedora kernels have this:
>>
>> CONFIG_TCG_TPM=y
>> CONFIG_TCG_TIS=y
>> CONFIG_TCG_NSC=m
>> CONFIG_TCG_ATMEL=m
>> CONFIG_TCG_INFINEON=m
>>
>> When I boot, tpm_infineon is also plugged in, but I can remove that
>> module and nothing seems to change (not sure what's plugging it in).
>>
>> I can try using tpm_infineon, but I'm not sure how to disable tpm_tis
>> with it compiled in like this -- is that possible?
>>
>> > Try the following before and after a suspend/resume:
>> >
>> > cd /sys
>> > find . | grep caps$ | xargs cat
>> >
>> > It should display manufacturer data.
>> >
>>
>> There's only one "caps" file. Here's the before (after a fresh reboot):
>>
>> # cat ./devices/pnp0/00:02/caps
>> Manufacturer: 0x49465800
>> TCG version: 1.2
>> Firmware version: 1.0
>>
>> ...after a successful suspend/resume cycle:
>>
>> # cat ./devices/pnp0/00:02/caps
>>
>> ...it gives no output at all. Guess that lends some weight to the
>> theory of it not being reset properly on resume?
>>
>> Thanks for the help so far...
>
> FWIW, I turned up dynamic debugging on the tpm files and got this in
> the ring buffer when I tried to read from "caps":
>
> [ 6880.495071] tpm_tis 00:02: A TPM error (38) occurred attempting to determine the manufacturer
>
> I don't see any obvious places that return ENOSYS in the tpm code, so
> I'm not clear on where that's coming from...
>

>From drivers/char/tpm/tpm.c,

static ssize_t transmit_cmd(struct tpm_chip *chip, struct tpm_cmd_t *cmd,
                            int len, const char *desc)
{
        int err;

        len = tpm_transmit(chip,(u8 *) cmd, len);
        if (len <  0)
                return len;
        if (len == TPM_ERROR_SIZE) {
                err = be32_to_cpu(cmd->header.out.return_code);
                dev_dbg(chip->dev, "A TPM error (%d) occurred %s\n", err, desc);
                return err;
        }
        return 0;
}

Where, desc comes from rc = tpm_getcap(dev, TPM_CAP_PROP_MANUFACTURER,
&cap, "attempting to determine the manufacturer");

TPM_ERROR_SIZE is 10, looks like it satisfies that condition.

                sk
