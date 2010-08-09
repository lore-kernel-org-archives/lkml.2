Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905Ab0HIPaK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 11:30:10 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45944 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756697Ab0HIPaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 11:30:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=BEkHzeQ8OpsV8b+49LCRtTXI0/Kv81vZlVMPvL+pD78HJicg6ZpbGJdjd925vWBhzR
         zbb1hkVkkXcaKbazJGtEyekuvg++HTAfb/m5Wx2Yyckz4N35lZWjivHdFmTKo7+oFdfM
         jJZ4ZnUcuDxue7Jno5byHXFFPt6KcwAg8u3oo=
Subject: Re: [PATCH 2/2] MEMSTICK: Add driver for Ricoh R5C592 Card reader.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <397573.48417.qm@web37608.mail.mud.yahoo.com>
References: <397573.48417.qm@web37608.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Aug 2010 18:30:01 +0300
Message-ID: <1281367801.22777.19.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have another question.

Looking at ms_block.c, I see that it sometimes changes register window.
This doesn't look good.
I see it does put the register window back, but still its a bit obscure.

I added tracking of current register window, so every time I send
MS_TPC_SET_RW_REG_ADRS I note the ranges.
And read/write functions now always attempt to send
MS_TPC_SET_RW_REG_ADRS. If the window is same as was  set last time, TPC
is skipped.

However, I am thinking, that maybe I should always write both param and
extra register? I just write 0xFF to extra register and thats all.
Windows driver does that partially. It writes 0xFF to managmemt and
0xF8 to overwrite flag (why???), but doesn't touch the LBA. I don't
think that matters.
It also always sends the MS_TPC_SET_RW_REG_ADRS, which I don't like.

Best regards,
Maxim Levitsky

