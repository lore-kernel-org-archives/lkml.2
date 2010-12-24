Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab0LXNBn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 08:01:43 -0500
Received: from inx.pm.waw.pl ([195.116.170.130]:50582 "EHLO inx.pm.waw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281Ab0LXNBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 08:01:42 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Cc: Greg Freemyer <greg.freemyer@gmail.com>,
        Bruno =?utf-8?Q?Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Slow disks.
References: <20101220141553.GA6088@bitwizard.nl>
	<20101220190630.66084e1d@neptune.home>
	<AANLkTi=VAJbVSzX_DH9_==a3RonLJmawYu3MzF-uqGXC@mail.gmail.com>
	<20101222104306.GB30941@bitwizard.nl>
Date: Fri, 24 Dec 2010 14:01:29 +0100
In-Reply-To: <20101222104306.GB30941@bitwizard.nl> (Rogier Wolff's message of
	"Wed, 22 Dec 2010 11:43:06 +0100")
Message-ID: <m3aajvz5na.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rogier Wolff <R.E.Wolff@BitWizard.nl> writes:

> ata6.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
> scsi 5:0:0:0: Direct-Access     ATA      WDC WD10EARS-00Y 80.0 PQ: 0 ANSI: 5
> sd 2:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931
> GiB)

WD10EARS are "green" drives, 5400 rpm. They aren't designed exactly for
speed. Never used them, though.

No NCQ? Sil 3114 doesn't support of course. ICH7 (without letters)
doesn't do AHCI either IIRC.

>   9 Power_On_Hours          0x0032   091   091   000    Old_age
> Always       -       7189
> 193 Load_Cycle_Count        0x0032   164   164   000    Old_age   Always
>       -       109955

Hmm, some agressive power savings? May reduce performance significantly.
I'd disable all this "green" crap first.

> Where it seems that WD simply says not to use these drives in a RAID.

That smells like "don't use them in any serious application".

I'd start with a RAID-1 or RAID-10 if possible.
-- 
Krzysztof Halasa
