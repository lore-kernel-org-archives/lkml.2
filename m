Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab0CVC2e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 22:28:34 -0400
Received: from mail-iw0-f182.google.com ([209.85.223.182]:65087 "EHLO
	mail-iw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab0CVC2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 22:28:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=tq7QIzaORCV26fOaF/8mUyvI5VrmVs0rVC+ACTeiE0G98llwGte9MJGLTD5S/gnK+S
         gjImDbr8elbNjRorRQh0STbbq91S2oJOJiFF3v1Wv7GglsyCQmVM/Aa2XmQKhtsOjaSp
         Caq4ozle7CsW2UQ9AcWhAGLugsnDx+jWuSh0E=
MIME-Version: 1.0
Date: Sun, 21 Mar 2010 19:28:32 -0700
Message-ID: <9a158e2e1003211928y37d3bbfnac068f200128ddb6@mail.gmail.com>
Subject: SysV IPC message queues
From: Kyle Hubert <khubert@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, I recently found myself using SysV IPC message queues in a Linux
specific application. However, I have one concern, I'm using
IPC_PRIVATE for the key to instantiate the message queue (then doing
pthread_creates with the open file descriptor accessed from children
threads).

Anyways, upon reception of signals, the message queue lingers around
taking up memory. I wouldn't mind this if I was using a key_t which I
could use to reopen the message queue at a later instantiation.
However, IPC_PRIVATE just grabs an available queue, and I don't have
access to the key, so I can't exactly open and remove it later. It's
my opinion that IPC_PRIVATE should cause the message queue to get
destroyed when all the open file descriptors are closed, not solely
when msgctl is used to remove it. Also, I don't want to capture
signals, since that's a slippery slope and SIGKILL will still leak
message queues. I also don't think ipcs/ipcrm are long term solutions,
since I'm handing the library off as an abstraction.

Would it be worth it to generate a patch to the Linux kernel to add
this functionality? Or, is there an undocumented ioctl I can call to
set that feature on?

IE: IPC_PRIVATE message queues should be freed when ref count drops to zero.

Thank you very much for your time,

-Kyle Hubert
