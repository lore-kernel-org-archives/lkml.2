Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab0ESBzW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 21:55:22 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48954 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115Ab0ESBzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 21:55:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ABuGsei4Ay10CGT4h6ue6qtGj+5tB6mp8tQGpC2Mk0no13pSLNnQmBwZmeO+6uaW76
         hwPpDm6+s6Dw/9P9s9f376bD3FH+qRZMR5Ngurbo+EIeoXTDK67a0Ok4YGysgK0iTuIz
         T9LF2A16HrnlknQgPPWSR09EsIOhqynKli+Mk=
MIME-Version: 1.0
In-Reply-To: <201005051757.o45HvPmY005954@amcc.com>
References: <201005051757.o45HvPmY005954@amcc.com>
Date: Wed, 19 May 2010 10:49:59 +0900
Message-ID: <AANLkTiljlMJKimdT-ptwXrMMBhSxFuPdVdyUuKJ8BZve@mail.gmail.com>
Subject: Re: [PATCH]460EX on-chip SATA driver <Kernel 2.6.33> < resubmission >
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Rupjyoti Sarmah <rsarmah@amcc.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       sr@denx.de, linuxppc-dev@ozlabs.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 6, 2010 at 2:57 AM, Rupjyoti Sarmah <rsarmah@amcc.com> wrote:
> This patch enables the on-chip DWC SATA controller of the AppliedMicro processor 460EX.

The controller seems to be a thrid party IP (from Synopsys) in your
SoC and there are many chances the IP will appear in some other
SOCs too. This implementation doesn't seem to take care of that
scenario.
So, please either call the driver something like sata_460ex.c
or, better still, segregate the driver in two parts - SoC specific stuff
and DWC IP core driver that can be reused by other SoCs having the
same IP in future.
