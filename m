Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab1L2Kaa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 05:30:30 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:64850 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab1L2Ka1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 05:30:27 -0500
Message-ID: <4EFC413A.80302@gmail.com>
Date: Thu, 29 Dec 2011 12:30:18 +0200
From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Jeff Layton <jlayton@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org
Subject: Re: cifs: ls of mount point gives input/output error (probably related
 to CIFS: getdents() broken for large dirs)
References: <4EFBAF99.3010208@gmail.com> <20111228210420.2a422d11@corrin.poochiereds.net>
In-Reply-To: <20111228210420.2a422d11@corrin.poochiereds.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/12/2011 4:04 πμ, Jeff Layton wrote:
> On Thu, 29 Dec 2011 02:08:57 +0200
> Konstantinos Skarlatos<k.skarlatos@gmail.com>  wrote:
>
>> I mount via cifs a windows XP share, df gives me correct sizes, but when
>> I ls the mount point i get input/output error.
>> strace: http://pastebin.com/WXf8M1nu
>>
>> mount --verbose -t cifs -o username=administrator,password=blahblah
>> //192.168.0.11/jobs /mnt/backups/montaz/jobs
>> mount.cifs kernel mount options:
>> ip=192.168.0.11,unc=\\192.168.0.11\jobs,,ver=1,user=administrator,pass=********
>>
>> df
>> //192.168.0.11/jobs                                       114464
>> 105196      9268  92% /mnt/backups/montaz/jobs
>>
>> ls /mnt/backups/montaz/jobs/
>> ls: reading directory /mnt/backups/montaz/jobs/: Input/output error
>> total 0
>>
>> the fun thing is that i can cd to a lower level directory, and ls works
>> fine there! only the mount point has the problem
>>
>> ls /mnt/backups/montaz/jobs/test
>> total 44K
>> drwxr-xr-x 1 root root    0 Apr 30  2010 blah blah/
>> ......
>>
>> kernel version 3.2rc7
>>
>> this seems to be related to :
>> https://lkml.org/lkml/2011/8/1/427
>> Re: [3.0.0+][Regression][Bisected] CIFS: getdents() broken for large dirs
>>
> Hmmm, maybe. What makes you think that it's related? What sort of
> server are you seeing this against?
Windows XP service pack 2 (greek)
>
> What would be most helpful is a capture and/or some cifsFYI info.
> Instructions on how to capture that are here:
>
> http://wiki.samba.org/index.php/LinuxCIFS_troubleshooting
>
> Would you be able to provide those?
http://pastebin.com/XR9H5Kzj
>
> Thanks,
