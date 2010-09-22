Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805Ab0IVBCc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 21:02:32 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47556 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755547Ab0IVBCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 21:02:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=A0OpJrEfqglGzbsfc6H7YluMQwaESuDFNXAmFjis9WLLnJHvibXa18iH9XQYNYXg4v
         VLXF5ZANVHb/O+H1Q5IBOnTYrBRRwI3zOtdAeVr+6jO4DUQ+FI1Sk6W2G6EAgC7y66rk
         J1uF1N0z/hwqmsblhN19wh8HA9IoK9aDBavsk=
Message-ID: <4C9955A5.9080604@gmail.com>
Date: Tue, 21 Sep 2010 19:02:29 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Thunderbird/3.1.3
MIME-Version: 1.0
To: Neeraj Kumar <neeraj.kumar01@ymail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Doing a zero-copy move of data from a kernel buffer to hard disk
References: <633175.66987.qm@web113411.mail.gq1.yahoo.com>
In-Reply-To: <633175.66987.qm@web113411.mail.gq1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2010 02:12 PM, Neeraj Kumar wrote:
> I am trying to move data from a buffer in kernel space into the hard
> disk without having to incur any additional copies from kernel buffer to
> user buffers or any other kernel buffers. Any ideas/suggestions would be
> most helpful.
>
> The use case is basically a demux driver which collects data into a
> demux buffer in kernel space and this buffer has to be emptied
> periodically by copying the contents into a FUSE-based partition on the
> disk. As the buffer gets full, a user process is signalled which then
> determines the sector numbers on the disk the contents need to be copied
> to.
>
> I was hoping to mmap the above demux kernel buffer into user address
> space and issue a write system call to the raw partition device. But
> from what I can see, the this data is being cached by the kernel on its
> way to the Hard Disk driver. And so I am assuming that involves
> additional copies by the linux kernel.
>
> At this point I am wondering if there is any other mechansim to do this
> without involving additional copies by the kernel. I realize this is an
> unsual usage scenario for non-embedded environments, but I would
> appreciate any feedback on possible options.
>
> BTW - I have tried using O_DIRECT when opening the raw partition, but
> the subsequent write call fails if the buffer being passed is the
> mmapped buffer.

O_DIRECT would be the right way to do it - I think you'd need to figure 
out why that write is failing. Keep in mind you need to observe the 
alignment restrictions of O_DIRECT (man 2 open).
