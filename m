Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab0CSK3a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 06:29:30 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45275 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab0CSK32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 06:29:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=VH8Xmjw4nvGkukzXtjfzNlfSQnJGSVwMRnXwCFiyKFEgdTSWdAeqlYxciIGB7whQg/
         joAzj4KrrRiKieTVjRI2diCeJ5eENo5TxZ3mZTVlVJUZqa4dmkxAwOj7e2tJCKjA5HFb
         6gVeA+pM5avgq4afWNdcqW9wvA4rN7YH/AyUY=
MIME-Version: 1.0
Date: Fri, 19 Mar 2010 18:29:28 +0800
Message-ID: <de04351e1003190329l2f33447bhe37b963bd4b48c70@mail.gmail.com>
Subject: BUG:write data to degrade raid5
From: jin zhencheng <zhenchengjin@gmail.com>
To: neilb@suse.de, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi;

i use kernel is 2.6.26.2

what i do as follow:

1, I create a raid5:
mdadm -C /dev/md5 -l 5 -n 4 /dev/sda /dev/sdb /dev/sdc  /dev/sdd
--metadata=1.0 --assume-clean

2, dd if=/dev/zero of=/dev/md5 bs=1M &

write data to this raid5

3, mdadm --manage /dev/md5 -f /dev/sda

4 mdadm --manage  /dev/md5 -f /dev/sdb

if i faild 2 disks ,then the OS kernel display OOP error and kernel down


do somebody know why ?

Is MD/RAID5 bug ?
