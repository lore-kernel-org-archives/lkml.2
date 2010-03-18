Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab0CRRiw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 13:38:52 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39655 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667Ab0CRRip convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 13:38:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=c3N21hifQtcFfO7dScUxrlHGKLzvGFsOzNEMX6hAzap9wlRo4KWhi8X22+6hZ/TXJE
         CgRGHKBjDpkwaZXIt6ztXSqBdcg8bq9oOzPn8TQ9XpqEFMRuNiO1qdPamBuFiHBxDQgF
         mnoQyJVh0i1xw+sYXP/ySlGkSjf8lNK74LUeA=
MIME-Version: 1.0
Date: Thu, 18 Mar 2010 10:38:44 -0700
Message-ID: <bb057cd21003181038j56992f68p6d72d0058d72f82f@mail.gmail.com>
Subject: should we use $(__USER_DS) or $(__KERNEL_DS) when entering interrupt 
	handlers?
From: Yang <teddyyyy123@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in handling an interrupt, kernel first saves all the register contents , in
the SAVE_ALL macro, in the last part of this macro,  it adjusts the
data segment selectors for kernel mode.

in kernel 2.4, the __KERNEL_DS segment is loaded into %ds and %es, at line
98 of:

http://lxr.linux.no/#linux-old+v2.4.31/arch/i386/kernel/entry.S


but in kernel 2.6, __USER_DS segment is loaded into %ds and %es, at line
227 of :
http://lxr.linux.no/#linux+v2.6.33/arch/x86/kernel/entry_32.S


I understand that on x86, all the data segment selector contents are
basically the same, but semantically it's better to use the KERNEL_DS
because we are working in kernel mode?



Thanks!
Yang
