Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab0LHREB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 12:04:01 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:48254 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab0LHREA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 12:04:00 -0500
Message-ID: <4CFFBA7D.6060802@psi5.com>
Date: Wed, 08 Dec 2010 18:03:57 +0100
From: Christian Brandt <brandtc@psi5.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: swap storage alignment and stride size
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preamble:

Hi fellow linux tamers, the following question has bounced around for
some days in local lists and newsgroups without conclussion and was
escalated upstream several times, here we are...

We are discussing semi-professional storage systems, e.g. ext4 on luks
on lvm on raid on gpt-partitions on 4k sector harddrives or 512k sector
SSDs. Usually every level profits a lot from aligning the data to the
underlying sector/stride/chunk size, e.g. ext4 with a 128k stripe size
will run a lot better on a well aligned 64k stride raid5.

In other words, partition tables, LVM, RAID, luks and filesystems know
how to handle and profit from aligned larger chunks.

In detail:

As far as we can read mm/swapfile.c linux is only concerned about cpu
page size and does not know anything about underlying
chunk/sector/stride sizes and alignment.

Therefore we think every small 1/2/4/8kiB page-sized write access leads
to a read-modify-write cycle for the whole chunk, taking more then twice
as long than simply writing the whole chunk at once.

Questions:

Is this the right place to ask?

Does or could linux swapping make use of aligning chunks?

And if, how?

If not, would it be an improvement?

Will this effect be mostly compensated by the block elevator?

Does it make any sense to change the mkswap page size to the chunk size?
We think those are two totally different beasts and should be left
seperated.

Is Linux already aware of chunk sizes within swap?

How to set up and controlled by the administrator?

-- 
Christian Brandt

 life is short and in most cases it ends with death
 but my tombstone will carry the hiscore
