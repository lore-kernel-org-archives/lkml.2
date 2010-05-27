Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935028Ab0E0Sam (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 14:30:42 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37750 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934486Ab0E0Sak convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 14:30:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=LVWHS8Bp5ruOLoi6Gqtk1PCczYAst9SvWR4WhoJqLIczEaV7bPLmqpcatJZpPsQlZY
         dZ/0NuTtCf15XwtomcBEQim/0Xfp9HRTQZIzqpQpdXyulutvjLnskiouHpnu4w62GEfO
         zOOIy43FUzVsILRGg/XlFFaV3Gyh5XRsX5oyA=
MIME-Version: 1.0
In-Reply-To: <4BFE2C3E.5090704@monstr.eu>
References: <1274815467-14584-1-git-send-email-vapier@gentoo.org> 
	<1274863506-14168-1-git-send-email-vapier@gentoo.org> <4BFE2C3E.5090704@monstr.eu>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 27 May 2010 14:30:19 -0400
Message-ID: <AANLkTinD5VI-piiv6CWnZMei4ARTLDF61r0O7wvddRDP@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH 1/2 v2] FLAT: split the stack & data 
	alignments
To: monstr@monstr.eu
Cc: linux-m32r@ml.linux-m32r.org, uclinux-dev@uclinux.org,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       microblaze-uclinux@itee.uq.edu.au,
       Hirokazu Takata <takata@linux-m32r.org>, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>, Paul Mundt <lethal@linux-sh.org>,
       Greg Ungerer <gerg@uclinux.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       David McCullough <davidm@snapgear.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 04:24, Michal Simek wrote:
> Mike Frysinger wrote:
>> The stack and data have different alignment requirements, so don't force
>> them to wear the same shoe.  Increase the data alignment to match that
>> which the elf2flt linker script has always been using: 0x20 bytes.  Not
>> only does this bring the kernel loader in line with the toolchain, but
>> it also fixes a swath of gcc tests which try to force larger alignment
>> values but randomly fail when the FLAT loader fails to deliver.
>>
>> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>
> Solve the problem on Microblaze:
>
> Tested-by: Michal Simek <monstr@monstr.eu>
>
> Who will add it to mainline?

if we can get the misc nommu peeps to agree on this (looking mostly at
David [McCullough] and Greg), then akpm will most likely expedite the
merge.  i like to think they're the best FLAT experts out there ;).
-mike
