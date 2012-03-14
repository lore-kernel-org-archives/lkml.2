Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965030Ab2CNAwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 20:52:17 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:54170 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758508Ab2CNAwO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 20:52:14 -0400
MIME-Version: 1.0
Date: Tue, 13 Mar 2012 20:52:11 -0400
X-Google-Sender-Auth: 2TeIIrRvSYLSaZP7Uz8tHOmQKYc
Message-ID: <CAP=VYLoQbNqHnc6_hzF5hYZq_=9L5qaGm7TNF1Mh5YZH57yjMQ@mail.gmail.com>
Subject: Re: pktgen -- arm build failures (Was: linux-next: triage for March
 13, 2012)
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>, tony@bakeyournoodle.com,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PG: adding netdev to CC list]

On Tue, Mar 13, 2012 at 8:41 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> On Tue, 13 Mar 2012 19:47:07 -0400 Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
>>
>> ARM:netx_defconfig,pnx4008_defconfig
>>       when:   Mar 14, 02:43
>>       why:    net/core/pktgen.c: can't find a register in class 'GENERAL_REGS'
>>       status:
>>       fix:
>>       ref:    http://kisskb.ellerman.id.au/kisskb/buildresult/5869486/
>
> This is this:
>
> net/core/pktgen.c:682:2775: error: can't find a register in class 'GENERAL_REGS' while reloading 'asm'
> net/core/pktgen.c:682:3153: error: can't find a register in class 'GENERAL_REGS' while reloading 'asm'
> net/core/pktgen.c:682:2775: error: 'asm' operand has impossible constraints
> net/core/pktgen.c:682:3153: error: 'asm' operand has impossible constraints
>
> Which is a do_div() call.  The relevant code does not appear to have
> changed, so this may well be a result of our toolchain changing from
> "arm-linux-gcc (GCC) 4.4.0, GNU ld (GNU Binutils) 2.19.1" to
> "arm-unknown-linux-gnueabi-gcc (GCC) 4.6.3, GNU ld (GNU Binutils) 2.22".
>
> Anyone have any thoughts?
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
