Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762086Ab2FHKgk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 06:36:40 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36427 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab2FHKgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 06:36:37 -0400
Message-ID: <423CA1423E2A456282D16F490475452A@local.st.by>
From: "Victor Miasnikov" <vvm@tut.by>
To: "Greg KH" <gregkh@linuxfoundation.org>,
        "Jonathan Nieder" <jrnieder@gmail.com>,
        "Andy Whitcroft" <apw@canonical.com>
Cc: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "KY Srinivasan" <kys@microsoft.com>,
        "Mike Sterling" <Mike.Sterling@microsoft.com>
References: <5293B8B4C8D947B9AA82309DD9A66F53@local.st.by> <20120607201610.GD3194@burratino>
Subject: Re: Re: ToDo: backport to v3.4 , v3.3 , v3.2 patches 1b) db63a4c8115a libata 1) cd006086fa5d ata_piix: defer disks to the Hyper-V drivers by default Fw: use hv_storvsc instead of ata_piix for IDE disks ( but not for the CD-ROM)
Date: Fri, 8 Jun 2012 13:36:31 +0300
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="ISO-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.3790.4548
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4862
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

To Andy Whitcroft: please prepare and re-send patches in "stable kernel format"

Thanks!

--

Jonathan Nieder: > Your mails are hard to read.

1) This is not specail :-( , sorry . . .
2) No problem:


{
> > > Hyper-V admins need _worked_ Linux v3.4.X / v3.3.X / v3.2.X
> > > Please, _fix_ errors related "use hv_storvsc instead of ata_piix to
> > > handle the IDE disks devices ( but not for the CD-ROM)"

  i.e. need backport to all actual version after 3.1

  cd006086fa5d ata_piix: defer disks to the Hyper-V drivers by default

and its prerequisite

  db63a4c8115a libata: add a host flag to ignore detected ATA devices
}




[ To: ] Greg: ( in any case: accept "backport patches" or not)  might be very usefull  info:  what lines from this rules

==
Rules on what kind of patches are accepted, and which ones are not, into the
"-stable" tree:

 - It must be obviously correct and tested.
 - It cannot be bigger than 100 lines, with context.
 - It must fix only one thing.
 - It must fix a real bug that bothers people (not a, "This could be a
   problem..." type thing).
 - It must fix a problem that causes a build error (but not for things
   marked CONFIG_BROKEN), an oops, a hang, data corruption, a real
   security issue, or some "oh, that's not good" issue.  In short, something
   critical.
 - New device IDs and quirks are also accepted.
 - No "theoretical race condition" issues, unless an explanation of how the
   race can be exploited is also provided.
 - It cannot contain any "trivial" fixes in it (spelling changes,
   whitespace cleanups, etc).
 - It must follow the Documentation/SubmittingPatches rules.
 - It or an equivalent fix must already exist in Linus' tree (upstream).
==


doesn't meet?



> Lots of things would be "nice",
> but as this doesn't meet the stable_kernel_rules.txt rules, sorry, I can't take them.

 IMHO, patches "does meet the stable_kernel_rules.txt rules" by _all_ criterias . . .

 See info correlated with rules:
==
Rules on what kind of patches are accepted, and which ones are not, into the
"-stable" tree:

{
 - It must be obviously correct and tested.

 Tested:
   -- Ubuntu 12.04 + OpenSUSE ( but, in early implementaition)
   --   I ( VVM) test kernel v3.5 on Arch Linux -- all related this patches work Ok
   {
   --   I test  boot flags  ata_piix.prefer_ms_hyperv=0
       it's really disabled set of patches "1b) db63a4c8115a libata 1) cd006086fa5d ata_piix"

----- Original Message ----- 
From: "Victor Miasnikov"
To: Cc:  _ _ _
Sent: Thursday, April 19, 2012 11:15 AM

KY Srinivasan: >  I think the correct approach here is to have a kernel (or an ata_piix module parameter)
KY Srinivasan: > that can be set to override the skipping of the block device by the ata driver.

 Already implemented, see:
module_param(prefer_ms_hyperv, int, 0);

 and work as need in real life:

http://www.mail-archive.com/ubuntu-bugs@lists.ubuntu.com/msg3482442.html
==
Tim Miller Dyck
Wed, 14 Mar 2012 07:15:52 -0700
 . . .
The boot flags can be viewed by pressing F5? F6? (one of those) on the
setup boot screen and then navigating to the boot line with cursor keys
and adding the boot parameter below before the double dash at the end of
the line.
The flag to disable the Hyper-V IDE drivers is:

 ata_piix.prefer_ms_hyperv=0  . . .
==

    }

}

{

- It cannot be bigger than 100 lines, with context.


79 lines  ( 36 line of pure sorce code)
 +
47 lines  ( 7 line of source code)
}

{
 - It must fix only one thing.

Yes

}

{

 - It must fix a real bug that bothers people (not a, "This could be a
   problem..." type thing).


 Is real bug: see URLs in my e-mails about problem
==
+ see tranlate from Russian language issue described by Maksim Kramarenko:
http://lists.debian.org/debian-russian/2012/01/msg00324.html

>> Correct, that is loaded without error, sleep and wake, for a small exception:
>>
>> At the conclusion of the system through the halt or when sending a
>> signal shutdown by ACPI to power down the console fell errors:
>> http://www.k-max.name/wp-content/uploads/2012/01/hyper-v.png
[That image shows the message

  exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
  ata1.00: failed command: STANDBY IMMEDIATE
]
>> Errors do not interfere with work, but sneaking suspicion about
>> future problems with the hard drive ...
[...]
>> in general, the source of the problem as follows:
>> After [VVM: turn On in kernel source]  Hyper-V modules [compile and
>> start use], a hard disk was determined as 2 with the same UUID.
[...]
>> connected to a drive:
>> http://www.k-max.name/wp-content/uploads/2012/01/hdd-e1327750214479.png
>> it is defined as a 2:
>> http://www.k-max.name/wp-content/uploads/2012/01/2hdd.png
>> Naturally, the same UUID:
>> http://www.k-max.name/wp-content/uploads/2012/01/blkid.png
>> That's what tells us the directory / dev:
>> http://www.k-max.name/wp-content/uploads/2012/01/uuid.png

Jonathan Nieder:  Thanks --- I think this is what Greg was asking for.
==



MS > this is not a bug in the ata_piix driver

 -- not bug in ata_piix driver itself
 -- _but_ this is bug in "(drivers_set(ata_piix + hv_storvsc))"

I.e. it is _bug_ in any case

 of cource, solution of  ( bug in "(drivers_set(ata_piix + hv_storvsc))" ) problem need
"changing the behavior of the ata driver [ VVM: ata_piix ]  to accommodate Hyper-V [ VVM: Hyper-V SCSI&ATA driver (
hv_storvsc) ] "


very good description of problem and possible solution:

----- Original Message ----- 
From: "Jonathan Nieder"
To: . . . Cc:  . . .
Sent: Tuesday, June 05, 2012 7:59 AM
Subject: Re: [PATCH 2/2] ata_piix: defer disks to the Hyper-V drivers by default

  . . .

If I understand correctly,
the problem is that ata_piix and hv_storvsc both claim the (virtual) hard disk.
That sounds worth fixing.
The patch works by making ata_piix skip the disk during enumeration
if hv_storvsc is enabled as a built-in driver or module.

A workaround is to blacklist the ata_piix module.
However, that means losing access to CD and DVD drives
which are exposed by ata_piix and not hv_storvsc.
--


----- Original Message ----- 
From: "Victor Miasnikov"
To: "Jonathan Nieder"
Sent: Tuesday, June 05, 2012 9:50:16 +0300 AM

  . . .
J.N.> {
A workaround is to blacklist the ata_piix module.
However, that means losing access to CD and DVD drives
which are exposed by ata_piix and not hv_storvsc.
}
 Yes: work without CD-ROM is not super-fine,
{
best backport patches from v3.5 ( de-facto reincarnation _tested_(!) patches from Ubuntu v12.04 and/or OpenSUSE )
--



}

{
 - It must fix a problem that causes a build error (but not for things
   marked CONFIG_BROKEN), an oops, a hang, data corruption, a real
   security issue, or some "oh, that's not good" issue.  In short, something
   critical.
 - New device IDs and quirks are also accepted.

 not related this patch

}

{
 - No "theoretical race condition" issues, unless an explanation of how the
   race can be exploited is also provided.
 - It cannot contain any "trivial" fixes in it (spelling changes,
   whitespace cleanups, etc).

No "theoretical" , no "trivial"

}

 - It must follow the Documentation/SubmittingPatches rules.

 IMHO, best choice ask author of patches ( APW) re-send patches in "stable kernel format"


 - It or an equivalent fix must already exist in Linus' tree (upstream).

 Yes

==







Best regards, Victor Miasnikov
Blog:  http://vvm.blog.tut.by/

