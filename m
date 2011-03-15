Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758424Ab1COTgq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 15:36:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63840 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013Ab1COTgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 15:36:44 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=x0iAWRUKOI8A:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=Re_9hRYCgRcPCmlh8hAA:9 a=T2-Qz7AvSvfm0kfBvr0VOB-U8tMA:4 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Tue, 15 Mar 2011 15:36:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Alexey Mikhailov <karma@galois.botik.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: lseek() on debugfs entries in 2.6.37
Message-ID: <20110315193642.GA19446@home.goodmis.org>
References: <874o74ilxl.wl%karma@galois.botik.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874o74ilxl.wl%karma@galois.botik.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 03:54:14PM +0300, Alexey Mikhailov wrote:
> Hello!
> 
> I use simple debugfs entries for user-space <-> kernel-space
> interaction. Basically I read unsigned integers from debugfs
> files like this:

What debugfs file? Is this something you created?

> 
>    ...
>    char buf[64];
>    lseek(timesync_fd, 0, SEEK_SET);
>    read(timesync_fd, buf, sizeof(buf));
>    ...
> 
> It works perfectly with 2.6.32 kernel. But with 2.6.37 kernel,
> lseek() fails with errno=29(Illegal seek). So second read()
> call just fails or returns garbage. Can someone please shed
> some light on it?
> 

There's been a lot of clean ups in the debugfs to patch lseek in files
that just didn't support it. Could be one of the files that got the
clean up. The lseek may have failed silently before, but now it
produceses an error.

-- Steve

