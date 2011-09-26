Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab1IZVDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 17:03:48 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:44958 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294Ab1IZVDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 17:03:46 -0400
To: Joshua Scoggins <theoretically.x64@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Arun <engineerarun@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Detection of Advanced Format drives
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <CANLaLhaEnyPchqOPp65Y0hvotM30E5daX=XNG=fAAmf1dchxCA@mail.gmail.com>
	<20110926111522.2a053ceb@lxorguk.ukuu.org.uk>
	<CAK3HsqvkpEiDWcCP_+eO0va4+io7pVV-aWCzQ1=DdpPi_jxy6g@mail.gmail.com>
Date: Mon, 26 Sep 2011 17:01:42 -0400
In-Reply-To: <CAK3HsqvkpEiDWcCP_+eO0va4+io7pVV-aWCzQ1=DdpPi_jxy6g@mail.gmail.com>
	(Joshua Scoggins's message of "Mon, 26 Sep 2011 12:48:46 -0700")
Message-ID: <yq1ehz3f26h.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.110017 (No Gnus v0.17) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A020203.4E80E8AA.0073,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Joshua" == Joshua Scoggins <theoretically.x64@gmail.com> writes:

Joshua> Keep in mind that some AF drives will not report their actual
Joshua> sector sizes. I have this issue with the WD AV-25 series. This
Joshua> is to provide compatibility with older operating systems that
Joshua> don't support AF drives. These are called generation 1
Joshua> devices. Newer drives will directly report their sector size as
Joshua> 4096 through the drive identify data older ones will say 512. 

AF drives continue to report a logical block size of 512. There's an
additional parameter in IDENTIFY DEVICE that describes the physical
block size. Legacy operating systems do not check the physical block
size parameter. Linux does, and will bubble this additional information
up the stack.

There have been a few attempts at switching ATA drives over to 4KB
logical blocks as well. We are ready. However, both boot and legacy OS
compatibility concerns make this a bit of an uphill battle.

As you mention there's one vendor that pretty consistently gets their
physical block size reporting wrong. We've pointed this out to them many
times. Apparently it's been fixed with the latest green drive
firmware...

-- 
Martin K. Petersen	Oracle Linux Engineering
