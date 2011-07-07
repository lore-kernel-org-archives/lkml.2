Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab1GGHZU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 03:25:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37264 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105Ab1GGHZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 03:25:17 -0400
Message-ID: <4E155F6F.6070506@suse.de>
Date: Thu, 07 Jul 2011 12:55:35 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110616 SUSE/3.1.11 Thunderbird/3.1.11
MIME-Version: 1.0
To: Sven-Haegar Koch <haegar@sdinet.de>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        Linux-Kernel-Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: 3.0-rc+git OOPS losetup on cifs
References: <alpine.DEB.2.02.1107042132500.18300@aurora>
In-Reply-To: <alpine.DEB.2.02.1107042132500.18300@aurora>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2011 01:18 AM, Sven-Haegar Koch wrote:
> hello,
> 
> Since a short while (I know it worked with 3.0-rc1) loopback-mounting an 
> image on a samba server mounted with cifs oopses the kernel.
> 
> Szenario:
> - Client system: Thinkpad T60, 32bit, Debian Unstable
> - Server system: Lacie edmini NAS device, exporting 500GB disk with 
>   samba, 450GB crypto image file on it
> - mount -t cifs -o username=backups,uid=1000,gid=0,file_mode=0664,dir_mode=0775,rw //192.168.10.98/backups /mnt/real-backups
> - losetup /dev/loop7 /mnt/real-backups/loop.img
> - cryptsetup luksOpen /dev/loop7 cifsloop
> - mount -t ext4 -o rw,noatime,delalloc,barrier=0 /dev/mapper/cifsloop /mnt/backups
> 
> This worked since ages, but since some time after 2.6.39 (last test 
> with 3.0-rc5+git ba466c74d99b91b2) this throws a kernel oops at the 
> "losetup" stage.

I couldn't reproduce this with 3.0-rc6 with a smaller image file (1GB).
But I see no relevant fixes between -rc5 and -rc6.

Can you try to reproduce the same problem with a smaller non-encrypted file?


Thanks,

-- 
Suresh Jayaraman
