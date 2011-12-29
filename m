Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473Ab1L2AJK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 19:09:10 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:60005 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087Ab1L2AJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 19:09:07 -0500
Message-ID: <4EFBAF99.3010208@gmail.com>
Date: Thu, 29 Dec 2011 02:08:57 +0200
From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-cifs@vger.kernel.org, jlayton@redhat.com
Subject: cifs: ls of mount point gives input/output error (probably related
 to CIFS: getdents() broken for large dirs)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I mount via cifs a windows XP share, df gives me correct sizes, but when 
I ls the mount point i get input/output error.
strace: http://pastebin.com/WXf8M1nu

mount --verbose -t cifs -o username=administrator,password=blahblah 
//192.168.0.11/jobs /mnt/backups/montaz/jobs
mount.cifs kernel mount options: 
ip=192.168.0.11,unc=\\192.168.0.11\jobs,,ver=1,user=administrator,pass=********

df
//192.168.0.11/jobs                                       114464  
105196      9268  92% /mnt/backups/montaz/jobs

ls /mnt/backups/montaz/jobs/
ls: reading directory /mnt/backups/montaz/jobs/: Input/output error
total 0

the fun thing is that i can cd to a lower level directory, and ls works 
fine there! only the mount point has the problem

ls /mnt/backups/montaz/jobs/test
total 44K
drwxr-xr-x 1 root root    0 Apr 30  2010 blah blah/
......

kernel version 3.2rc7

this seems to be related to :
https://lkml.org/lkml/2011/8/1/427
Re: [3.0.0+][Regression][Bisected] CIFS: getdents() broken for large dirs

Please CC because i am not subscribed
