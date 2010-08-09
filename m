Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153Ab0HITTO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 15:19:14 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34236 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844Ab0HITTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 15:19:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kV5bJE2IQRQ5cn/x+VAoli1OMMObZPtZ3AvSSL+FN6huPV8RqWMfM2+tlf8CRGkKao
         ae7rlH1mmjZsYjx+63ykbFmlMsMi5AZga2KTDkKuE2FeFdxAmoFS912aXyWn+2FLFnoG
         giUIXgLxEU7NbFL3RAY6qJ57i2R7USqeogDZU=
Subject: Re: [PATCH 2/2] MEMSTICK: Add driver for Ricoh R5C592 Card reader.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <397573.48417.qm@web37608.mail.mud.yahoo.com>
References: <397573.48417.qm@web37608.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Aug 2010 22:19:08 +0300
Message-ID: <1281381548.22777.39.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

About INT bits, I still don't understand them exactly.

First of all we have 4 meaningful bits.
In parallel mode these are exposed on data lines, in serial mode only 
MEMSTICK_INT_CED is.
And I can always send MS_TPC_GET_INT or just read the registers.

#define MEMSTICK_INT_CMDNAK 0x01
#define MEMSTICK_INT_BREQ   0x20
#define MEMSTICK_INT_ERR    0x40
#define MEMSTICK_INT_CED    0x80


Now, I send a command to device, say MS_CMD_BLOCK_READ.
What bits I need to poll until I can be sure that command is completed?

Also the MEMSTICK_INT_BREQ tells that input is available in firmware
buffer (to read using TPC_READ_LONG_DATA)?



Is that true that MEMSTICK_INT_BREQ is a summary of fifo full/empty bits
in status0?

And same about MEMSTICK_INT_ERR and status1.

I try my best to create a driver that actually works, simple, and error
free, even in unusual conditions.
Thats why I am asking all these questions.

Thanks for help,
Best regards,
Maxim Levitsky

