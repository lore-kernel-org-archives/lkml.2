Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932707Ab1EFUqK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 16:46:10 -0400
Received: from edu-smtp-01.edutel.nl ([88.159.1.175]:49380 "EHLO
	edu-smtp-01.edutel.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932451Ab1EFUqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 16:46:09 -0400
X-Greylist: delayed 574 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 May 2011 16:46:08 EDT
Message-ID: <4DC45BA3.7@neli.hopto.org>
Date: Fri, 06 May 2011 22:35:47 +0200
From: Micha Nelissen <micha@neli.hopto.org>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: get_user_pages + put_task_struct
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am writing a (pci) device driver, in which I'm doing userspace DMA 
with get_user_pages. After some complicated locking, it occurred to me 
to use reference counting instead, after finding the functions 
get_task_mm and get_task_struct. However, put_task_struct cannot be used 
in a module, linker will complain about __put_task_struct_cb being 
undefined. I saw it explicitly being removed as a symbol, "we do not 
want device drivers holding references to task structs". Why exactly is 
this?

mmput is exported, so no problem for the mm. BTW, I'm also not exactly 
sure why I (conceptually) need a task to get the pages; but I think it's 
for statistics.

I need to hold on to this task because the DMA transaction may need to 
be split in multiple pieces, continuing after the initial call by the 
user; during which time that process may have exited (e.g. unexpected kill).

Micha
