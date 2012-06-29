Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab2F2OGM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 10:06:12 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:55018 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751968Ab2F2OGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 10:06:10 -0400
Message-ID: <4FEDB64C.2040208@stericsson.com>
Date: Fri, 29 Jun 2012 16:06:04 +0200
From: Pierre PEIFFER <pierre.peiffer@stericsson.com>
Organization: STEricsson
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
Subject: inotify: notify IN_DELETE_SELF when file is deleted or inode deleted
 ?
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

By playing with inotify (on user side) to know whether the file I'm 
using is deleted by someone else,  I have noted that I do not receive 
the IN_DELETE_SELF event, exactly because I'm using it. By checking into 
kernel area, I see that at unlink(), an IN_ATTRIB event is sent, but 
IN_DELETE_SELF is, indeed, sent only when the inode is deleted.

But such IN_ATTRIB event doesn't tell to the user what has changed among 
permissions, timestamps, link count, etc...
So it doesn't much help. Of course, I have noted that I can monitor the 
parent directory for IN_DELETE and then check which file has been 
deleted; few more stuff to do but it works, no pb.

But I'm still wondering after reading in the man.:
            IN_DELETE_SELF    Watched file/directory was itself deleted.
Is this really the expected behavior ? Shouldn't the kernel trig such 
event at unlink() ? Or is inotify clearly inode oriented ?

Thanks,

Pierre

PS: keep me in cc, I'm not subscribed to the list.
