Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763Ab1K2VPj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 16:15:39 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:36000 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756501Ab1K2VPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 16:15:37 -0500
Message-ID: <4ED54B0E.5030403@oracle.com>
Date: Tue, 29 Nov 2011 13:13:50 -0800
From: Maxim Uvarov <maxim.uvarov@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: linux-nfs@vger.kernel.org
CC: linux-kernel@vger.kernel.org, rlove@rlove.org, eparis@parisplace.org,
        john@johnmccutchan.com, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: nfs no inotify IN_DELETE  event
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4ED54B77.00BD,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm looking on inotify02 test future in mainline kernel on nfs:

inotify_init()                          = 3
inotify_add_watch(3, ".", IN_ALL_EVENTS)
creat("test_file1", 0755)               = 5
rename("test_file1", "test_file2")      = 0
getcwd("/mnt/nfs2/tmp", 256)            = 14
rename("/mnt/nfs2/tmp", "/mnt/nfs2/tmp.rename1") = 0
unlink("test_file2")                    = 0

After unlink() if file sytem is not nfs there is event:
IN_DELETE               0x00000200      /* Subfile was deleted */
for file test_file2. If file system is nfs there is no such event.

For the first time I thought that this is nfs sever bug related to nfs 
"silly renamed files" feature. But logically - file test_file2 was not 
deleted. It was removed with his directory from event watch directory to
non event watch directory.

1. is it ok that unlink() in that test returns 0, not -1 ENOENT?

2. should we get IN_DELETE for all files and sub folders for event watch 
directory? Or there should be only one event that directory was removed?

To reproduce:
http://ltp.sourceforge.net/
make
cd testcases/kernel/syscalls/inotify
export TMPDIR=/mnt/nfs/tmp/
export TDIRECTORY=/mnt/nfs/tmp/
./inotify02

Best regards,
Maxim Uvarov.
