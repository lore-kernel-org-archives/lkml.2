Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777Ab0HGFdK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 01:33:10 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44378 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab0HGFdI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 01:33:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=hFxcr/0xRxOGUZLuqWLliNzt5fp227To23OT7Y+XwT9Z48zPBBUZG5JctCW6xckA5D
         whltTucyByRcLIIPi73Lnc7xc4OYhxJmkDORZoC6Yad/QO8BtoxP0qlgFN/DDrLD0sMR
         e4mPjnTGsRgFKQa81OTshQcU+D2Y4a4iwcr7w=
MIME-Version: 1.0
In-Reply-To: <1281126198.3352.6.camel@gandalf.stny.rr.com>
References: <1268462987-8271-1-git-send-email-rabin@rab.in>
	<1268462987-8271-8-git-send-email-rabin@rab.in>
	<20100803164247.GA6133@debian>
	<1281126198.3352.6.camel@gandalf.stny.rr.com>
Date: Sat, 7 Aug 2010 11:03:06 +0530
X-Google-Sender-Auth: MfuFhXHocyXmOOyh_tWL7wbSjDE
Message-ID: <AANLkTi=Y7WsfrKy2db9j2v8b6PsEhOF2o953R-CvhmhQ@mail.gmail.com>
Subject: Re: [PATCH 07/10] ftrace: pass KBUILD_CFLAGS to record_mcount.pl
From: Rabin Vincent <rabin@rab.in>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 7, 2010 at 1:53 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> >     "$(if $(CONFIG_CPU_BIG_ENDIAN),big,little)" \
>> >     "$(if $(CONFIG_64BIT),64,32)" \
>> > -   "$(OBJDUMP)" "$(OBJCOPY)" "$(CC)" "$(LD)" "$(NM)" "$(RM)" "$(MV)" \
>> > +   "$(OBJDUMP)" "$(OBJCOPY)" "$(CC) $(KBUILD_CFLAGS)" \
>> > +   "$(LD)" "$(NM)" "$(RM)" "$(MV)" \
>
> Hmm, this changes the number of parameters passed to the
> recordmcount.pl. shouldn't this be part of the change to
> recordmcount.pl? Otherwise, we can break a bisect.

No, this doesn't change the number of parameters.  KBUILD_CFLAGS
is included inside the CC argument.

Rabin
