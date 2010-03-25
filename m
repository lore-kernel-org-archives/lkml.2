Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab0CYOz2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 10:55:28 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59773 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741Ab0CYOz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 10:55:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=TiH5zY3ionJScEr5HZQ7Rx/8HL6OgaKHrhJWD3QT5Ph7eu8z9pMnB16t0syJslcA/o
         7vQ2tV+Qdfrjq8E31Nov4qud12bn9VDYZQPt5dwHfZXQSU21PZ3Sj0AZ2mgDF7dNrO8j
         Qo9EHFepOl9pfX52jnT1rcO9Ay9dUA3ziDTVk=
MIME-Version: 1.0
Date: Thu, 25 Mar 2010 20:25:26 +0530
Message-ID: <f750ee71003250755kf02f87au714f634070b94d26@mail.gmail.com>
Subject: disabling kernel preemption from user space
From: kartikeyan sadasivuni <s.kartikeyan@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a system where bootloader supports
core0 running linux (control plane).
core1 running application without OS (a data plane app).

(core0 and core1 share some physical memory)

Because of this setup and application requirements
I want to ocassionally disable preemption of linux kernel
for very small periods from user space process.


Is the following valid solution to achive this ?

I will load a kernel module foo.ko which supports the following
ioctl's from user space.


PREEMPT_DISABLE:
 calls preempt_disable() from the driver (foo.ko)

PREEMPT_ENABLE:
 calls premept_enable() from the driver (foo.ko)

user space process does

ioctl(FOO_FD,  PREEMPT_DISABLE, ..);
do some short critcal work
ioctl(FOO_FD,  PREEMPT_ENABLE, ..);


Basically I want to know, if preempt_disable() and preempt_enable()
are legal across user to kernel space swtiches are only within kernel.

I don't mind if the solution is wierd/stupid
but works on all 2.6.* kernels.

-- 
S.Kartikeyan
