Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806Ab1FUWBI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 18:01:08 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:45953 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873Ab1FUWBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 18:01:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=sgKWdfrH3oerbBcoOXicjHSfewYt9CnhDmwu5WOalG/0SSrjMvmqUUBuWV7lqSacoh
         MA+AVb/qAxK9xRAgg6n1qMKBbSC4HMqY/NDZ/zynDQJL3dMg1v1UEg7ikTsY6P+hv0/Q
         0AKnPShHTneeCrNxzrUt4zu5RQGfge/4mjJRg=
MIME-Version: 1.0
Date: Tue, 21 Jun 2011 15:01:05 -0700
Message-ID: <BANLkTin7FZLkjqY1-Z_7DvQRgrFe3zYtwQ@mail.gmail.com>
Subject: initramfs size & crashkernel reserved area
From: Sujit V <sujit.linux@gmail.com>
To: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am observing the following.

We are using linux 2.6.23 kernel
crashkernel=128M@16M

We also have few kernel modules in our code base.

The kernel modules are gzip'ed in the cpio archive which is included
in the .init.ramfs section of vmlinux

When the size of the .init.ramfs section goes beyond certain limit
then it corrupts the crash kernel reserved area.

If the .init.ramfs size is 0x33d0f6 then things work ok.

If the init.ramfs size is 0x4be430 then it corrupts the crashkernel area.

Any pointers for further debugging?
