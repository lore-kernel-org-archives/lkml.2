Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760165Ab1IKOb5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 10:31:57 -0400
Received: from nm9.bullet.mail.ird.yahoo.com ([77.238.189.35]:30281 "HELO
	nm9.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754720Ab1IKObu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 10:31:50 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 895465.72733.bm@omp1025.mail.ird.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=3Rzp8iJFAyuntAOgpPqEdHNbDzGFyNlDDObVbXyJ9WC511KBLMIK3naEyHKUySz/UR/2AFgx3OZVBXq7iK319aUkndz9ct7zrN7IX2d7Ztwyr0m2IMQcXDDQmgM1CKZqvDaVsEAcHS/s9b4ImrTwcZgppEcohdaAcIlKuySbyJQ=;
X-YMail-OSG: mSoQRzYVM1nHySwTmp8thkGUhEtvt2zzWZ6WkxaP.HOJBsQ
 7FegWl3zXanjp4mgfhWE3LAKJUQu8A9kbcU3YroMkE3ExjzvF6Mz2WZDk7ZZ
 436OBaM9SRCNIEClWH_0HPuNKk9RflNrYNxC_QEoV6q8oftD6RfMl5Kqd3fB
 dLc4TO9jD6l38Am8d9B73yKpmhsq1rt5M8F4eoMB2KLfzyK5nox9UZ1W8s5l
 IuAr9Vx7jJ0MSdIFs5UHsZ6ch4BRngCYapMlGTzmElMwWjUfkQ6sQezWY1iM
 UkWnDVd_T7UuO..K5_jlvZBzCuBmVDzjDQVwwavpkKDNUZZ3OMOA3IWGdBF0
 Vg6tQs7mFrKjmXnVTE..vz9VGbAI5dveK8dp0mkeLvO_qLYzMLWQxOSlit3J
 4upBesCwDnxx8R3SIOQVxZ.Iup5Y4E9LH5.TAES3K4PnujYX3qrfSroZgkA1
 vswmcmyWC15_6hezITEdwd1KJN0g30KKfDGN3m_iyKNPYr99wAWSIVyKJaR9
 bHHC9lzsvMwPTKmLneDoxTnThstml..zEFCJ6xEQ_xKh75Xd0442x
X-Mailer: YahooMailClassic/14.0.5 YahooMailWebService/0.8.113.315625
Message-ID: <1315751507.52552.YahooMailClassic@web29517.mail.ird.yahoo.com>
Date: Sun, 11 Sep 2011 15:31:47 +0100 (BST)
From: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
Subject: Re: graceful handling of removing a plugable storage device that is being written to
To: linux-fsdevel@vger.kernel.org, Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
In-Reply-To: <201109111208.25761.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Sun, 11/9/11, Martin Steigerwald <Martin@lichtvoll.de> wrote:

> Cc to BTRFS mailinglist as it
> triggered the idea of mine again.
> 
> 
> Hi!
> 
> Today I did it again and removed a BTRFS partition that is
> written too. 
> That BTRFS as of Kernel 3.0.3 (debian package) does not
> like very much. I 
> think thats a known issue and I wrote a mail to BTRFS
> mailing list about 
> it.
> 
> In there I wrote:
> 
> > Expected results:
> > 
> > BTRFS fails gracefully except the loss of data from
> writes in flight, the 
> > machine remains usable and BTRFS can be mounted
> again.
> 
> And then cause the expected results IMHO are by no way the
> ideal results:
> 
> 
> > Ideal results (IMHO):
> > 
> > Linux behaved like AmigaOS and told me that I *must*
> insert the device 
> > again and *continues* writing after I did this. 
> 
> But I never saw any other OS that did that.
> 
> And I see the problems with high bandwidth writes piling up
> in memory 
> causing severe memory pressure.
> 
> But then could Linux just freeze processes that continue
> writing to the 
> drive until it is replugged again? Of course that
> shouldn´t happen to the 
> drive / resides on.
> 
> And there is a userspace part in it - the possibly udev and
> dbus  driven 
> notification to the user.

How do you cope with 
(1) headless systems (one where there is no udev/dbus notification or display).
(2) the user walking off in a hurry and never seeing the notification?
Should the kernel/user processes freeze indefinitely?

There is also a 3rd scenario - how how one malicious person or process doing a repeat insert/remove/write and get resource to pile up and crash the machine?

It is probably possible/recommended with Amiga because Amiga is seldomly run headless?

> 
> Yet despite all of this NetBSD has a gsoc 2011 project at
> least suggested 
> for exactly this behavior:
> 
> Graceful USB disk detach/reattach
> http://wiki.netbsd.org/projects/gsoc_2011/disk-removal/
> 
> They even mention the Amiga in there.
> 
> Okay, its only for USB, not for eSATA, but I think it
> should be made 
> generic for removable devices.
> 
> Would that be possible? I gladly file an enhancement
> request about it or 
> help testing it.
> 
> I think thats the only approach that makes sense here. USB
> sticks and 
> harddisks have no means to disallow device removal at any
> time. Thus the 
> OS should offer the user a way to rethink the decision and
> plug the device 
> in to prevent data loss. Actually I am surprised that no
> other operating 
> system except AmigaOS seemed to offer this behavior. Well I
> am not quite 
> sure about MS-DOS writing to disk. Maybe it even did that.
> But I did not 
> use MS-DOS often. 
> 
> All current mainstream operating systems I know of default
> to loose data 
> in that case. I think there is a better choice. What do you
> think? Might 
> not be much of a server feature, but important for the
> desktop.
> 
> Ciao,
> -- 
> Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
> GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599
> 84C7
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
