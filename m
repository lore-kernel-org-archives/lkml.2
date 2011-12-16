Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760368Ab1LPSWJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 13:22:09 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:6740 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759872Ab1LPSWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 13:22:05 -0500
X-Authority-Analysis: v=2.0 cv=bJuU0YCZ c=1 sm=0 a=/DbS/tiKggfTkRRHPZEB4g==:17 a=zQGhUK9Iw4MA:10 a=WZqaRsArvagA:10 a=8nJEP1OIZ-IA:10 a=Ci3M8c6B1GLafKNyCvMA:9 a=wPNLvfGTeEIA:10 a=/DbS/tiKggfTkRRHPZEB4g==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.78.168.186
Message-ID: <4EEB8C4A.5080809@cfl.rr.com>
Date: Fri, 16 Dec 2011 13:22:02 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: tty idle time and hooking inode_ops from a chardev
References: <4EEB774D.1070407@cfl.rr.com> <20111216175735.GA5404@suse.de>
In-Reply-To: <20111216175735.GA5404@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2011 12:57 PM, Greg KH wrote:
> Don't worry about it, as it's not really an important issue at all? :)

That's why it has been broken for years; because nobody cares enough 
about it to fix it, but that kind of thing irks me.

> It seems that your userspace programs aren't properly measuring the
> correct thing here, it's not that the kernel is doing something wrong,
> right?

I thought so at first, but it appears that the tty layer was originally 
written specifically to work this way.

> And atime on a character node is pretty undefined, isn't it?

Is it?  I would have thought so but after looking at all of this code, 
it looks like it is one of those things that has just been around for 
decades, but nobody knows about, kind of like FIONREAD.

I wonder if that's how who has always worked going back to AT&T Unix. 
If it is, then I'd like to stick with it ( but fix it ) rather than say, 
add an ioctl to read the idle time and change coreutils to use that instead.
