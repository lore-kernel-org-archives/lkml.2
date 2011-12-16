Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760391Ab1LPTJQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 14:09:16 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:21404 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760301Ab1LPTJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:09:07 -0500
X-Authority-Analysis: v=2.0 cv=APbyNIPv c=1 sm=0 a=/DbS/tiKggfTkRRHPZEB4g==:17 a=zQGhUK9Iw4MA:10 a=WZqaRsArvagA:10 a=8nJEP1OIZ-IA:10 a=Qa1yocA8eKZ1jg2egzgA:9 a=wPNLvfGTeEIA:10 a=/DbS/tiKggfTkRRHPZEB4g==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.78.168.186
Message-ID: <4EEB9751.7030000@cfl.rr.com>
Date: Fri, 16 Dec 2011 14:09:05 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: tty idle time and hooking inode_ops from a chardev
References: <4EEB774D.1070407@cfl.rr.com> <20111216175735.GA5404@suse.de> <4EEB8C4A.5080809@cfl.rr.com> <20111216183613.GA3612@suse.de>
In-Reply-To: <20111216183613.GA3612@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2011 1:36 PM, Greg KH wrote:
> But you said that your userspace programs are opening the wrong tty
> device for what you are trying to look at, right?

They are opening /dev/tty, which is supposed to be an alias for the 
process's controlling tty, but it isn't quite so.  It routes read/write 
calls to the correct tty, but is a separate inode, so has its own 
timestamps.

> That's not "fixing" it at all, adding an ioctl is the same as adding a
> new system call, do you really think that is ok here?

I would prefer not to, which is why I'm trying to figure out how to make 
the atime correct no matter how you opened the tty.

> As you are opening the tty node once, that's when atime is set, right?
> The fact that you keep it open still keeps the atime to the original
> open time, you aren't supposed to check for every single read/write of
> the node once it was opened.

tty_io.c updates the atime of the inode on every successful read(), and 
the mtime on every successful write().  The problem is that several 
different inodes can all point to the same tty, so which inode gets 
updated depends on which process is doing the IO.

> But to be sure, what does POSIX say about this?

No clue.

