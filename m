Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276Ab1DJLrH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 07:47:07 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49794 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289Ab1DJLrF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 07:47:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type:content-transfer-encoding;
        b=i6eVRMPM5Y1ApnlbJzIwr9tqTVQh/YH+PC4CMbYNRVuYnEBiH+4yZFT2cpenDBiAZE
         XhlwdztbD9Nv/5+5ZZRqD52LxhY5dq/8GkXu3nxhGzTLG6JPKboj/YpYBHgJTC4F22Cb
         +enKSNXIK/MvEPFtHGAy+NWKEfNUJf2X4JGtg=
MIME-Version: 1.0
Date: Sun, 10 Apr 2011 13:47:02 +0200
X-Google-Sender-Auth: 9ZAbpYvNqmuWqCFp__-fI4RWU2M
Message-ID: <BANLkTinpmZHJt4guXoSPfjT9SoiSmEpJFw@mail.gmail.com>
Subject: irq_startup()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Thomas Gleixner <tglx@linutronix.de>,
        Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas, Sato-san,

struct irq_chip has:

        unsigned int    (*irq_startup)(struct irq_data *data);

while the internal wrapper has:

        int irq_startup(struct irq_desc *desc);

The return value and type are nowhere documented, but according to the
callers that
use it, it's flag to indicate that an interrupt was pending, right?

This mechanism seems to be used by startup_ioapic_irq() only, all other
irq_startup implementations always return 0...
Except for h8300_startup_irq(), which returns 0 or -EBUSY?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
