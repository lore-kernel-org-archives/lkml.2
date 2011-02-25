Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab1BYPfM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 10:35:12 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46825 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262Ab1BYPfK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 10:35:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type:content-transfer-encoding;
        b=SgPFteAR8rtn+HFBhLAdy+fuGhK9zPUjb1nW+e++Jzrc1znm1kUVctmn4cgXeoNtO/
         dPkKFQjVW0tYkRk5i9oWLQgS72afdeS9z+UZiumw4tUgv8HEKdhTS+XQwPfXgyb7e152
         Wfu1fdTkBj/QGQNBeaxFOmmRGwx8Um0eJ2raw=
MIME-Version: 1.0
Date: Fri, 25 Feb 2011 15:35:08 +0000
X-Google-Sender-Auth: 2aSzNzy-Jpnq-H346VUtGRr3bTA
Message-ID: <AANLkTin-2FH-c_5DVpW29zvARW827Ebun31=z2b+jB00@mail.gmail.com>
Subject: OF IOAPIC bindings compile error
From: Daniel Drake <dsd@laptop.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        Andres Salomon <dilinger@queued.net>, tglx@linutronix.de
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Testing linux-2.6-x86.git, I encountered a compile error which seems
to caused by the following commit with X86_IO_APIC=n:

commit bcc7c1244fcfd852b9f4590935491057e1cab9dd
Author: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Date:   Tue Feb 22 21:07:44 2011 +0100

    x86: ioapic: Add OF bindings for IO_APIC

Error is:
arch/x86/kernel/devicetree.c: In function ‘x86_dtb_find_config’:
arch/x86/kernel/devicetree.c:288:3: error: lvalue required as left
operand of assignment

It can be fixed by inserting #ifdef CONFIG_X86_IO_APIC inside
x86_dtb_find_config, but I'm not sure if this is the correct approach.

.config file in question:
http://dev.laptop.org/~dsd/20110225/ioioapic-problem-config.txt

Daniel
