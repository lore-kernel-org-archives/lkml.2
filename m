Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051Ab0DWQdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 12:33:12 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62818 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758111Ab0DWQdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 12:33:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=UuleklzjFeE/YeKSrb+XX6aYiiy8zXb5KCjnFwJwQmZ72AZCZe6Oa2fA4Rp9tRVRHh
         xfRt1HHPWekss7QzPZK8kkAdLhkyfO2B0WE5Bh8AYy5IdlFlGBDYDWI7B3yzHBMdDrg3
         MN0GhYn5sI5oMP5TxzIuC+6CDL4rBJLf6TtBQ=
MIME-Version: 1.0
Date: Fri, 23 Apr 2010 12:33:06 -0400
Message-ID: <p2pff6de6f21004230933t6fdeb985jeca51a550e3dbc5b@mail.gmail.com>
Subject: parport_pc.c and parport_serial.c need improvements
From: Joseph Krahn <joseph.krahn@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 2005, Russel King cleaned up parport_serial.c to remove redundancy
with 8250_pci.c (http://lwn.net/Articles/141484/). In working on
fixing the ITE-887x driver, I realized that there is still a lot of
redundancy with parport_pc.c. Furthermore, parport_pc seems to have
some deficiencies. It does not call pci_disable_device() when
unloading the driver (as pci.txt says it should) and seems to be
missing power suspend/resume code.

Also, the Super IO code looks rather messy. To work with
parport_serial, struct pci_parport_data could include a device_private
pointer to attach  the serial-port data. The SuperIO code could use
this to attach struct superio_struct. Maybe the SuperIO code should be
in a separate module (i.e. parport_superio) that depends on
parport_pc, similar to parport_serial. In any case, it would be nice
to see more comments on why the SuperIO code is designed as it is.

 OTOH, maybe parport hardware is simple enough that it is not worth
messing with the code as long as it seems to work OK.

Thanks,
Joe Krahn
