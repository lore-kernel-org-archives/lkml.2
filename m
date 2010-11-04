Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab0KDF6s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 01:58:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43629 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577Ab0KDF6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 01:58:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=Wwy7GvTlZr7XECCuxulzBQ7Q16pAQyH1NxoBVD/MSyOV3fOe7cRJpGC+5jyKOrGr6C
         zO19hGXamEVB7+HsooSleWaVz4tsjmOuoC+BE1hZ+QJxidlk9W5PIXZn67ERncJOiBhZ
         KWZNo5aXIqj64/o1yayr3SiidtgUxhsM79AUA=
Subject: out of memory error from kernel when I open hundred of thousands
 of TCP connections
From: springzhong <davidmahorse@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Nov 2010 13:58:36 +0800
Message-ID: <1288850316.5575.1.camel@zhongjiu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The source of serve is like:
ListeningThread listeningThread(this, nPortNum);
listeningThread.nPortNum=6475;
listeningThread.Start();
ListeningThread listeningThread2(this, 6476);
listeningThread2.nPortNum=6476;
listeningThread2.Start();
ListeningThread listeningThread3(this, 6477);
listeningThread3.nPortNum=6477;
listeningThread3.Start();
ListeningThread listeningThread4(this, 6477);
listeningThread4.nPortNum=6478;
listeningThread4.Start();

The source of client is like:
for (int i = 0; i < 60000; i++)
{
this->Connect("127.0.0.1", nPortNum, false, pClientSocket);
this->Connect("127.0.0.1", 6476, false, pClientSocket);
this->Connect("127.0.0.1", 6477, false, pClientSocket);
this->Connect("127.0.0.1", 6478, false, pClientSocket);
}

I want to test the maximum tcp connections of linux in my netbook with
2G memeory.
But I just found It cannot exceed 240000 connections.Then an 
"out of memory error" occured. But it looks like there is still a lot of
free memory in my computer.

I want to rechange the kernel to accept more TCP connections like one
million tcp connections in my network.
But I find there are too many source codes in it. 
Could you give me any suggestions?
I have changed my environment like this with epoll:
/etc/security/limits.conf
* soft nofile 802400
* hard nofile 802400
# End of file

cat /proc/sys/fs/file-max
2204218

cat /etc/sysctl.conf
net.ipv4.ip_local_port_range = 1024 65000

cat /proc/sys/fs/epoll/max_user_watches
2500873

It is not the limitation of file ids of linux.It is an error from kernel
of LINUX

spring zhong


