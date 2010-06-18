Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629Ab0FRCxt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 22:53:49 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33280 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481Ab0FRCxs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 22:53:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KbKORC6SkOJXr2e1vAllqtDRBj82cJB05oi1KXm29Ev3omkDxZ1NWl3XWeS7YAi+1W
         3VmT537SdmSFRPGRKLF57zuopy06+iHdTchc8VMdpR9Z87vmG7099uUC2L7huuN0GfB8
         +DcIrWyZzaYeTSxLOFh8o5vgwXGQytqwmsKJ8=
MIME-Version: 1.0
In-Reply-To: <AANLkTimSyRdLIWzWaj5lKccw0rBUFJ7kZ4vAkKGjCYOp@mail.gmail.com>
References: <Pine.LNX.4.64.1006171341420.8191@boston.corp.fedex.com>
	<AANLkTimOjN2CiqGIxh8BClkki8F1SsERaumyy4L1a6Ab@mail.gmail.com>
	<AANLkTimSyRdLIWzWaj5lKccw0rBUFJ7kZ4vAkKGjCYOp@mail.gmail.com>
Date: Thu, 17 Jun 2010 20:53:46 -0600
Message-ID: <AANLkTimvGbDNOTPeuH79ZnJMR14pv7ehQ8vZ3ib_eKrP@mail.gmail.com>
Subject: Re: What is HSM violation? Causing ata1.00 hard resetting link
From: Robert Hancock <hancockrwd@gmail.com>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Jeff Garzik <jgarzik@redhat.com>, Greg KH <greg@kroah.com>,
       kristen.c.accardi@intel.com, Dely Sy <dely.l.sy@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Wilcox <willy@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 17, 2010 at 8:33 PM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
>
>
> On Fri, Jun 18, 2010 at 7:41 AM, Robert Hancock <hancockrwd@gmail.com>
> wrote:
>>
>> On Thu, Jun 17, 2010 at 12:05 AM, Jeff Chua <jeff.chua.linux@gmail.com>
>> wrote:
>>
>> > ata1.00: exception Emask 0x2 SAct 0x7 SErr 0x3000400 action 0x6
>> > ata1.00: irq_stat 0x44000008
>>
>> The controller is reporting a protocol violation in Serror, and the
>> IRQ status reports a taskfile error and unknown FIS received from the
>> device.
>>
>> What kind of external drive is this? Seems to me like either it's
>> doing something not quite kosher, or there's some other problem (maybe
>> the eSATA cable is bad, or it doesn't seat properly in the connector -
>> apparently that's not uncommon).
>
> ata1.00 is the internal AHCI connector [Intel Corporation 5 Series/3400
> Series Chipset 6 port SATA AHCI Controller (rev 06)] with a  [SAMSUNG
> MMDOE56GG5MXP-OVB rev 0 with f/w VBM1801Q] (256GB SATA) attached.
>
> The errors were pointing to ata1.00 and after the HSM violation appeared,
> the disk was no longer accessible.

OK, so it was the SSD that had the problem, not the eSATA drive.

It does seem like the drive did something the controller really didn't
like, though. Is there any firmware update available for the drive?

>
> The external e-SATA has a JMicro [JMicron JMB360 AHCI Controller (rev 02)]
> with the same model Samsung SSD attached.
>
> If I do a "sync" every 3 seconds, I don't see any error. I had seen this
> errors in the past doing tar to external USB2 disks ... and it could be the
> same problem but just didn't notice it before.
>
> Thanks,
> Jeff
>
>
