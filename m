Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab0CVIq0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 04:46:26 -0400
Received: from mail-yx0-f182.google.com ([209.85.210.182]:39997 "EHLO
	mail-yx0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669Ab0CVIqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 04:46:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=VmSUfCTr3l+MuZ/BIQAhjqfhgV+Z5p8mkRGszjNUHVRF42D3E/ZVZaw/nEkztGqz63
         oaaA+VHn+iXUZ2RHkOJDlrF9aI7gJUjtwBQ2VhZLRSOjue7/ZTXATW0MZHy6hqSan8nr
         zjDh9KlHb+taZhySD48y6NjOV5DZ7aUdihmZI=
MIME-Version: 1.0
In-Reply-To: <9a158e2e1003211928y37d3bbfnac068f200128ddb6@mail.gmail.com>
References: <9a158e2e1003211928y37d3bbfnac068f200128ddb6@mail.gmail.com>
Date: Mon, 22 Mar 2010 01:46:14 -0700
Message-ID: <9a158e2e1003220146p463e35b6u2615695ae9ddc1b9@mail.gmail.com>
Subject: Re: SysV IPC message queues
From: Kyle Hubert <khubert@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, so the Linux kernel implementation does syscalls for SysV IPC
message queues, hence the lack of freeing resources when IPC_PRIVATE
is used. If IPC_PRIVATE is used, can't we open a file descriptor for
the user process, and it's file operation on close would just call
freequeue?

Thanks,

-Kyle Hubert

On Sun, Mar 21, 2010 at 7:28 PM, Kyle Hubert <khubert@gmail.com> wrote:
> Hi, I recently found myself using SysV IPC message queues in a Linux
> specific application. However, I have one concern, I'm using
> IPC_PRIVATE for the key to instantiate the message queue (then doing
> pthread_creates with the open file descriptor accessed from children
> threads).
>
> Anyways, upon reception of signals, the message queue lingers around
> taking up memory. I wouldn't mind this if I was using a key_t which I
> could use to reopen the message queue at a later instantiation.
> However, IPC_PRIVATE just grabs an available queue, and I don't have
> access to the key, so I can't exactly open and remove it later. It's
> my opinion that IPC_PRIVATE should cause the message queue to get
> destroyed when all the open file descriptors are closed, not solely
> when msgctl is used to remove it. Also, I don't want to capture
> signals, since that's a slippery slope and SIGKILL will still leak
> message queues. I also don't think ipcs/ipcrm are long term solutions,
> since I'm handing the library off as an abstraction.
>
> Would it be worth it to generate a patch to the Linux kernel to add
> this functionality? Or, is there an undocumented ioctl I can call to
> set that feature on?
>
> IE: IPC_PRIVATE message queues should be freed when ref count drops to zero.
>
> Thank you very much for your time,
>
> -Kyle Hubert
>
