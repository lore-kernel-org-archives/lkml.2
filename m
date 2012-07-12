Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933295Ab2GLJCo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 05:02:44 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38065 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab2GLJCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 05:02:41 -0400
Content-Type: text/plain; charset=gbk; format=flowed; delsp=yes
Date: Thu, 12 Jul 2012 17:01:02 +0800
To: linux-kernel@vger.kernel.org
Subject: question about IO-sched
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: gaoqiang <gaoqiangscut@gmail.com>
Organization: qihoo
Message-ID: <op.whbsn0qvn27o5l@gaoqiang-d1.corp.qihoo.net>
User-Agent: Opera Mail/12.00 (Win32)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,all

	I have long known that deadline is read-prefered. but a simple test gives  
the opposite result.
	
	with two processes running at the same time,one for read and one for  
write.actually,they did nothing bug IO operation.
	while(true)
	{
		read();
	}
	the other:
	while(true)
	{
		write();
	}
	
	with deadline IO-sched  and ext4 filesystem.as a result, read ratio was  
about below 3M/s.and write about 100M/s. I have tested both kernel-2.6.18  
and kernel-2.6.32,getting the same result.
	
	I add some debug information in the kernel and recompile,found that,it  
has little to do with IO-sched layer because read request dropped into  
deadline was 5% of write request .from /proc/<pid>/stack,the read process  
hands on sync_page most of the time.
	what is the matter ? anyone help me ?
