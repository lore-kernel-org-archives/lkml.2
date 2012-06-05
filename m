Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab2FEGuY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 02:50:24 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64638 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819Ab2FEGuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 02:50:22 -0400
Message-ID: <B06F99AAB8B64125808F01FCDD1F9909@local.st.by>
From: "Victor Miasnikov" <vvm@tut.by>
To: "Jonathan Nieder" <jrnieder@gmail.com>,
        "Greg KH" <gregkh@linuxfoundation.org>
Cc: "KY Srinivasan" <kys@microsoft.com>, <stable@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "Mike Sterling" <Mike.Sterling@microsoft.com>
References: <20120527010903.GA18244@kroah.com> <B4A84D892D5742FE83F71F788F6EAF48@local.st.by> <20120528203518.GA12623@kroah.com> <5EBD7E368EFE4B5CABF4AC528058A4DB@local.st.by> <20120601092017.GE22821@kroah.com> <59CBCFF13ABD41B682835DD5E4851BC1@local.st.by> <20120601162629.GA11812@kroah.com> <426367E2313C2449837CD2DE46E7EAF90710C295@SN2PRD0310MB382.namprd03.prod.outlook.com> <20120602012249.GA7783@kroah.com> <ACB4012399AF4F20A8DAECA154E96ED3@local.st.by> <20120605045950.GB3118@burratino>
Subject: ToDo: backport to v3.4 , v3.3 , v3.2 patches 1b) db63a4c8115a libata 1) cd006086fa5d ata_piix: defer disks to the Hyper-V drivers by default Fw: use hv_storvsc instead of ata_piix for IDE disks ( but not for the CD-ROM)
Date: Tue, 5 Jun 2012 09:50:16 +0300
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
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


>>> use hv_storvsc instead of ata_piix to handle the IDE disks devices ( but not for the CD-ROM)

J.N.> the problem is that ata_piix and hv_storvscboth claim the (virtual) hard disk.  

 Yes:
{  About bug fixed by patches:

>>  see tranlate from Russian language issue described by Maksim Kramarenko:
>> http://lists.debian.org/debian-russian/2012/01/msg00324.html

>>> After [VVM: turn On in kernel source]  Hyper-V modules [compile and
>>> start use], a hard disk was determined as 2 with the same UUID.

}

J.N.> {
A workaround is to blacklist the ata_piix module.  
However, that means losing access to CD and DVD drives 
which are exposed by ata_piix and not hv_storvsc.
}

 Yes: work without CD-ROM is not super-fine, 
{
best backport patches from v3.5 ( de-facto reincarnation _tested_(!) patches from Ubuntu v12.04 and/or OpenSUSE ) :

J.N.> {
 The patch works by making ata_piix skip the disk during enumeration 
if hv_storvsc is enabled as a built-in driver or module.
 }

>> > VVM > > > Hyper-V admins need _worked_ Linux v3.4.X / v3.3.X / v3.2.X

  i.e. need backport to all actual version after 3.1

  cd006086fa5d ata_piix: defer disks to the Hyper-V drivers by default

and its prerequisite

  db63a4c8115a libata: add a host flag to ignore detected ATA devices

}


> --- I think this is what Greg was asking for.

 I supose . . .

 Thanks,
Best regards, Victor Miasnikov
Blog:  http://vvm.blog.tut.by/

P.S.

> Thanks

 No problem :-)

> Hoping that clarifies,

 Yes: very good description of problem and possible solution
Big thanks!

--


----- Original Message ----- 
From: "Jonathan Nieder" 
To: . . . Cc:  . . .
Sent: Tuesday, June 05, 2012 7:59 AM
Subject: Re: [PATCH 2/2] ata_piix: defer disks to the Hyper-V drivers by default

  . . . 

If I understand correctly, 
the problem is that ata_piix and hv_storvscboth claim the (virtual) hard disk.  
That sounds worth fixing.  
The patch works by making ata_piix skip the disk during enumeration 
if hv_storvsc is enabled as a built-in driver or module.

A workaround is to blacklist the ata_piix module.  
However, that means losing access to CD and DVD drives 
which are exposed by ata_piix and not hv_storvsc.
--


