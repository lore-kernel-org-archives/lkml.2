Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab2A3IKK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 03:10:10 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:46356 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab2A3IKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 03:10:08 -0500
Message-ID: <bf0d05d510da3650d12fb66a65a3ce37.squirrel@webmail.greenhost.nl>
In-Reply-To: <20120129141920.497d96d4@pyramind.ukuu.org.uk>
References: <20120128203250.090abec6@easytoremember.us>
    <4F24BEB5.5070402@gmail.com>
    <20120129141920.497d96d4@pyramind.ukuu.org.uk>
Date: Mon, 30 Jan 2012 09:10:03 +0100
Subject: Re: /proc/[pid]/mem write implications
From: "Indan Zupancic" <indan@nul.nu>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: "Cong Wang" <xiyou.wangcong@gmail.com>,
        "Bryan Jacobs" <its@easytoremember.us>, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.0
X-Scan-Signature: 66f4fda096222dd2b2010deb1ce817c5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, January 29, 2012 15:19, Alan Cox wrote:
>> > But I think that allowing arbitrary processes to write to **their own**
>> > memory via a file descriptor might in itself be problematic. Please,
>> > help me understand how this is safe.
>>
>> You will have a sysctl to control if it is writable.
>
> The problem is not that the check is done in write, the problem is more
> fundamental - the open should bind to the memory of the executable image
> currently running, instead it effectively late binds each write to the
> image now being run. That is the root cause.
>
> What's sad about this is that people went and re-introduced the bug and
> clearly didn't think to spend 2 minutes asking Google why the checks were
> there originally.

How did the patch enabling it get past review?

>
> 2006 thread
>
> http://lkml.indiana.edu/hypermail/linux/kernel/0605.2/1359.html
>
> 2004 thread
>
> http://lkml.indiana.edu/hypermail/linux/kernel/0407.0/1169.html
>
> 2002 thread
>
> http://www.eros-os.org/pipermail/cap-talk/2002-May/000922.html
>
>
> If you really want to fix this then you need to bind /proc/self/mem to
> the executable image in question, and you need to effectively revoke()
> that on exec so it can't be used to pin old images into memory.
>
> Fix that and the rest falls out in the wash.

There is process_vm_writev() now, so there is no need for a writeable
/proc/*/mem. User space can't count on it being writeable anyway.

Actually, as there is process_vm_readv() too now, I think /proc/*/mem
should be removed altogether.

Greetings,

Indan


