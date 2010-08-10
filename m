Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab0HJHxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 03:53:51 -0400
Received: from web37605.mail.mud.yahoo.com ([209.191.87.88]:47143 "HELO
	web37605.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754407Ab0HJHxq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 03:53:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=N8OX5L1mcv4eGpraIWk75yEzqPUZVvj1vvrwW6kwdBtYYbHciRvdrC5Ql2BtO7/lEjtnqWY7IoXMyFsk1py9/37/WmVw2IMadmZMI8SLYDfILDKiGz6lBq1Ej5ho2zWb+8ar2wxgpGLsVDDQHcXlT0p4IPGLq2QosuFoLQH1MEw=;
Message-ID: <950622.87676.qm@web37605.mail.mud.yahoo.com>
X-YMail-OSG: kzWBRuwVM1k4IcfvEXi36OjyK.7QPrQUehvBXyDkTHZv2rZ
 OZmgC6QB_qfjmuvZsMKsgVRsblxu_e5kIkZsmdyfEGW0KeUZ_Lvx_J6iOiye
 u4m5tC_fpBEM1i.Y5VmzgUDJ7ywM0k0sdflYDZkZEJ33Zz2fVqP.G4jKMCeU
 1kRAiwom6g5Ekg7e9BnQKTdhwzyctf4KTkyoNlTV0d.eVsWc3TdcDuW2Fyo8
 1pRvOhTQmSpuVnTTdG7LM5qxjrMGg5awIzPvbS15wMVEyBPd3piPucG1Xkfv
 Ti799s7P5WRLe0HsXN8Sr6Wnm4e2Y1dp4ityEE08-
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Tue, 10 Aug 2010 00:53:43 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 2/2] MEMSTICK: Add driver for Ricoh R5C592 Card reader.
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1281381548.22777.39.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> About INT bits, I still don't
> understand them exactly.
> 
> First of all we have 4 meaningful bits.
> In parallel mode these are exposed on data lines, in serial
> mode only 
> MEMSTICK_INT_CED is.
> And I can always send MS_TPC_GET_INT or just read the
> registers.
> 
> #define MEMSTICK_INT_CMDNAK 0x01

This bit means command was not acknowledged by the media (media not ready).

> #define MEMSTICK_INT_BREQ   0x20

This bit means media is ready for long data transfer (either in or out).

> #define MEMSTICK_INT_ERR    0x40

This bit means that some error had occurred during command execution. 

> #define MEMSTICK_INT_CED    0x80

This bit marks a completion of the command, but it may switch value in
between, so it is not that reliable by itself.

> 
> 
> Now, I send a command to device, say MS_CMD_BLOCK_READ.
> What bits I need to poll until I can be sure that command
> is completed?

All of them.

> 
> Also the MEMSTICK_INT_BREQ tells that input is available in
> firmware
> buffer (to read using TPC_READ_LONG_DATA)?
> 

Not exactly. BREQ signal indicated that media's state machine is in the
mode to pump data in or out. You wait for it, than you do the data
transfer (it works the same with READ and WRITE).

> 
> 
> Is that true that MEMSTICK_INT_BREQ is a summary of fifo
> full/empty bits
> in status0?

This can not be relied upon. Sony states, that only BREQ bit must be used
in block transfer operations. BE/BF bits are probably of more use in
memstick IO cards (there exists such a beast).

> 
> And same about MEMSTICK_INT_ERR and status1.

status1 errors apply only to data errors (bit flips).
There are errors in command execution that do not result in bit flips,
rather data can not be delivered at all or command/parameters are invalid.


> 
> I try my best to create a driver that actually works,
> simple, and error
> free, even in unusual conditions.
> Thats why I am asking all these questions.
> 
> Thanks for help,
> Best regards,
> Maxim Levitsky
> 
> 


      
