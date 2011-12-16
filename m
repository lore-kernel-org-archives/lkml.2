Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932774Ab1LPTuG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 14:50:06 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:6085 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab1LPTte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:49:34 -0500
X-Authority-Analysis: v=2.0 cv=bJuU0YCZ c=1 sm=0 a=/DbS/tiKggfTkRRHPZEB4g==:17 a=zQGhUK9Iw4MA:10 a=WZqaRsArvagA:10 a=8nJEP1OIZ-IA:10 a=lPosg8qUyE6n-cMyO8MA:9 a=wPNLvfGTeEIA:10 a=/DbS/tiKggfTkRRHPZEB4g==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.78.168.186
Message-ID: <4EEBA0CB.1050006@cfl.rr.com>
Date: Fri, 16 Dec 2011 14:49:31 -0500
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
> As you are opening the tty node once, that's when atime is set, right?
> The fact that you keep it open still keeps the atime to the original
> open time, you aren't supposed to check for every single read/write of
> the node once it was opened.
>
> But to be sure, what does POSIX say about this?

Actually it looks like POSIX 4.8 "File Times Update" requires the 
timestamps to be updated on every read/write, which is probably why 
Linux does that.

So the problem is just the /dev/tty alias having a different inode than 
the actual controlling tty.  It also makes the output of lsof less 
useful, so maybe the real fix is to somehow make opening /dev/tty 
actually open the correct tty inode and dentry.

I have a feeling that will require changing /dev/tty from being a 
devnode to a symlink to something in /dev/pts.
