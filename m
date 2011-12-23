Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757660Ab1LWTlG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 14:41:06 -0500
Received: from mail.snarked.org ([67.43.172.250]:36781 "EHLO mail.snarked.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757644Ab1LWTlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 14:41:04 -0500
X-Envelope-From: <newsserv> (mail.snarked.org)
To: linux-kernel@vger.kernel.org
From: "D. Stussy" <spam+newsgroups@bde-arc.ampr.org>
Newsgroups: linux.kernel
Subject: Re: Possible logic bug in SATA driver. [Follow-up]
Date: Fri, 23 Dec 2011 11:41:02 -0800
Message-ID: <jd2lgd$648$1@snarked.org>
References: <i9S0p-6Tc-3@gated-at.bofh.it>
Reply-To: "D. Stussy" <replies+newsgroups@kd6lvw.ampr.org>
X-No-Archive: Yes
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1478
X-Priority: 3
X-Newsreader: Microsoft Outlook Express 6.00.2800.1478
X-MSMail-Priority: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"D. Stussy" <spam+newsgroups@bde-arc.ampr.org> wrote in message
news:i9S0p-6Tc-3@gated-at.bofh.it...
> Syslog:
> kernel: ata1: illegal qc_active transition (3fffffff->fffffffe)

I found this message in the SATA driver, in libata.c

It has gotten worse in 3.1.6.  I have downgraded to 3.0.14 and have yet to
see it.  Therefore, I suspect one of the changes in the 3.1 series is at
falt, but haven't been able to identify which change yet.  For some reason,
it only happens to my primary disk (/dev/sda) despite having an second,
identical disk mounted on /dev/sdb.

> When this happens, the filesystem on the offending disk is auto-remounted
> as read-only.  Is this an indication of a bug in the ext4 filesystem or
in
> the SATA driver?
>
> I am seeing this bug with a 3.1.5 kernel compiled from source about every
> 3-4 days.  Soft rebooting does not work; a hard reset is required.
>
> System:  AMD Opteron 4184 stepping 01 (6-core) 2.8GHz (2794.027 MHz)
64-bit
> MB:  Supermicro H8SCM-F / 32GB ECC Ram
> HD:  ATA-8: ST32000644NS, SN11, max UDMA/133
>      3907029168 sectors, multi 16: LBA48 NCQ (depth 31/32)
>      (1.81 TB) SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>      Write Protect is off / Mode Sense: 00 3a 00 00
>      Write cache: enabled, read cache: enabled, doesn't support DPO or
FUA


