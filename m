Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215Ab0HJJuM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 05:50:12 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35430 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab0HJJuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 05:50:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=KdQuv8fJs5ze0maQeJJOoP2a34g04co84G2lFJAyxXetF4HCU+6tlFjd0zBA7Xr/U6
         p4Aomf4lQ4oLIyspnoYH+3pNUhhVJB8HVlVvsIOatYTTrd4TzV7ziR/p5tlsJuS/5xBk
         z9j0qoF2AaWzUJYE5HcFyKtq5NRUfmCwMBdvU=
Subject: Re: [PATCH 2/2] MEMSTICK: Add driver for Ricoh R5C592 Card reader.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <950622.87676.qm@web37605.mail.mud.yahoo.com>
References: <950622.87676.qm@web37605.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Aug 2010 12:50:05 +0300
Message-ID: <1281433805.2016.36.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-10 at 00:53 -0700, Alex Dubov wrote: 
> > About INT bits, I still don't
> > understand them exactly.
> > 
> > First of all we have 4 meaningful bits.
> > In parallel mode these are exposed on data lines, in serial
> > mode only 
> > MEMSTICK_INT_CED is.
> > And I can always send MS_TPC_GET_INT or just read the
> > registers.
> > 
> > #define MEMSTICK_INT_CMDNAK 0x01
> 
> This bit means command was not acknowledged by the media (media not ready).
> 
> > #define MEMSTICK_INT_BREQ   0x20
> 
> This bit means media is ready for long data transfer (either in or out).
> 
> > #define MEMSTICK_INT_ERR    0x40
> 
> This bit means that some error had occurred during command execution. 
> 
> > #define MEMSTICK_INT_CED    0x80
> 
> This bit marks a completion of the command, but it may switch value in
> between, so it is not that reliable by itself.
> 
> > 
> > 
> > Now, I send a command to device, say MS_CMD_BLOCK_READ.
> > What bits I need to poll until I can be sure that command
> > is completed?
> 
> All of them.
> 
> > 
> > Also the MEMSTICK_INT_BREQ tells that input is available in
> > firmware
> > buffer (to read using TPC_READ_LONG_DATA)?
> > 
> 
> Not exactly. BREQ signal indicated that media's state machine is in the
> mode to pump data in or out. You wait for it, than you do the data
> transfer (it works the same with READ and WRITE).
> 
> > 
> > 
> > Is that true that MEMSTICK_INT_BREQ is a summary of fifo
> > full/empty bits
> > in status0?
> 
> This can not be relied upon. Sony states, that only BREQ bit must be used
> in block transfer operations. BE/BF bits are probably of more use in
> memstick IO cards (there exists such a beast).
Even better. 
> 
> > 
> > And same about MEMSTICK_INT_ERR and status1.
> 
> status1 errors apply only to data errors (bit flips).
> There are errors in command execution that do not result in bit flips,
> rather data can not be delivered at all or command/parameters are invalid.
Understood.
However if I get MEMSTICK_INT_ERR, I should also look at status1,
because there might be correctable error.


Thank you very much.

Best regards,
Maxim Levitsky

