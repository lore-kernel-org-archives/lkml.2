Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760470Ab2FDMdd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 08:33:33 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54955 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760427Ab2FDMdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 08:33:31 -0400
Message-ID: <ACB4012399AF4F20A8DAECA154E96ED3@local.st.by>
From: "Victor Miasnikov" <vvm@tut.by>
To: "Greg KH" <gregkh@linuxfoundation.org>,
        "KY Srinivasan" <kys@microsoft.com>
Cc: <stable@vger.kernel.org>, "Jonathan Nieder" <jrnieder@gmail.com>,
        <linux-kernel@vger.kernel.org>,
        "Mike Sterling" <Mike.Sterling@microsoft.com>
References: <20120527010903.GA18244@kroah.com> <B4A84D892D5742FE83F71F788F6EAF48@local.st.by> <20120528203518.GA12623@kroah.com> <5EBD7E368EFE4B5CABF4AC528058A4DB@local.st.by> <20120601092017.GE22821@kroah.com> <59CBCFF13ABD41B682835DD5E4851BC1@local.st.by> <20120601162629.GA11812@kroah.com> <426367E2313C2449837CD2DE46E7EAF90710C295@SN2PRD0310MB382.namprd03.prod.outlook.com> <20120602012249.GA7783@kroah.com>
Subject: Re: Linux on Hyper-V 1) cd006086fa5d ata_piix: defer disks to the Hyper-V drivers by default 2) db63a4c8115a libata: add a host flag to ignore detected ATA device FW: use hv_storvsc instead of ata_piix to handle the IDE disks devices ( but not for the ...
Date: Mon, 4 Jun 2012 15:33:25 +0300
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

VVM > > > Hyper-V admins need _worked_ Linux v3.4.X / v3.3.X / v3.2.X
VVM > > >
VVM > > > Please, _fix_ errors related "use hv_storvsc instead of ata_piix to
VVM > > > handle the IDE disks devices ( but not for the CD-ROM)"


K.Y.S. >> {
 Clearly I cannot tell you anything about this that you don't know!
Looking at the rules for stable tree patches,
this patch does not satisfy the requirement that the patch fix a bug
since we are changing the behavior here of the ata driver to accommodate Hyper-V.
I don't know how much flexibility you have here for taking patches that improve
the general usability of Linux in different environments.
All I can say is that It will be nice to have this patch in previous stable releases.
}

This is _real_ bug

{ P.S.
  Dear K.Y., please read _again_ my letter
Sent: Monday, April 02, 2012 1:46 PM
}

> Lots of things would be "nice",
> but as this doesn't meet the stable_kernel_rules.txt rules, sorry, I can't take them.

 IMHO, patches "does meet the stable_kernel_rules.txt rules" by _all_ criterias . . .

 See info correlated with rules:
==
Rules on what kind of patches are accepted, and which ones are not, into the
"-stable" tree:

{
 - It must be obviously correct and tested.

 Tested ( but, in early implementaition): Ubuntu 12.04 + OpenSUSE

}

{

- It cannot be bigger than 100 lines, with context.


79 lines
 +
47 lines
}

{
 - It must fix only one thing.

Yes

}

{

 - It must fix a real bug that bothers people (not a, "This could be a
   problem..." type thing).


 Is real bug: see URLs in my e-mails about problem
+ see tranlate from Russian language issue described by Maksim Kramarenko:
http://lists.debian.org/debian-russian/2012/01/msg00324.html
==

 . . .

At the conclusion of the system through the halt or when sending a signal shutdown by ACPI to power down the console
fell errors:
http://www.k-max.name/wp-content/uploads/2012/01/hyper-v.png

Errors do not interfere with work, but sneaking suspicion about future problems with the hard drive ...

  . . .

in general, the source of the problem as follows:
After [VVM: turn On in kernel source]  Hyper-V modules [compile and start use], a hard disk was determined as 2 with the 
same UUID.

 . . .

Here are screenshots of what is happening:
connected to a drive:
http://www.k-max.name/wp-content/uploads/2012/01/hdd-e1327750214479.png
it is defined as a 2:
http://www.k-max.name/wp-content/uploads/2012/01/2hdd.png
Naturally, the same UUID:
http://www.k-max.name/wp-content/uploads/2012/01/blkid.png
That's what tells us the directory / dev:
http://www.k-max.name/wp-content/uploads/2012/01/uuid.png

==


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

 Prepare patches -- this job duty of Microsoft employee

 - It or an equivalent fix must already exist in Linus' tree (upstream).

 Yes

==


Best regards, Victor Miasnikov
Blog:  http://vvm.blog.tut.by/


