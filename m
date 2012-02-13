Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab2BMMdK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 07:33:10 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:37180 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193Ab2BMMdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 07:33:08 -0500
Message-ID: <4F3902F8.3090905@free-electrons.com>
Date: Mon, 13 Feb 2012 13:32:56 +0100
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: ranjith kumar <ranjithproxy@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: how to know list of files accessed
References: <CAG9fbzb=B66ku7bPWjJOZ7_EcShYqORypP8-hsvD-g7z9t4oHA@mail.gmail.com>
In-Reply-To: <CAG9fbzb=B66ku7bPWjJOZ7_EcShYqORypP8-hsvD-g7z9t4oHA@mail.gmail.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ranjith,

On 02/13/2012 12:30 PM, ranjith kumar wrote:
> Hi,
> Suppose I downloaded linux kernel.
> When I run "make", many of the .c files will be compiled.
> I want to know which .c files are compiles and which .c files are not compiled.
> Is there any way to know in linux?
An easy way is to run your command with 'strace' to trap all the calls
to 'open':

strace make 2>&1 | grep open
>
> Access time of the files which are compiled is not getting modified
> when I run "make" . why?
That's correct. As long as you don't read these files, there's no reason
to update their latest access time. Comparing access time with modified
time is a useful way to know which files haven't been read after being
modified.

Cheers

Michael.
-- 
Michael Opdenacker, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
+33 484 253 396

