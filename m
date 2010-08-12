Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758818Ab0HLHWp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 03:22:45 -0400
Received: from web37607.mail.mud.yahoo.com ([209.191.87.90]:23833 "HELO
	web37607.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753601Ab0HLHWo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 03:22:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=JGJ5h5+OJsDh8eP4kOkI+Rga0lW6bQz+ieosjtxKO2Kz0RHYNE4Q+oxyvE81IKNRH1lUnGSo0JGv1uxIvHM7rUAx3TrMYd3TeH5Uqu8HM7SIgxWSqTdgF04xPmkP5Sz2LvpQ+TCq4CEkTHeZbRFypqt0fi9sPV8YdlYKUI4VYuo=;
Message-ID: <667152.31831.qm@web37607.mail.mud.yahoo.com>
X-YMail-OSG: mteLbt4VM1leTfGlxLRJqwoKMrXkcpQyW0VhZW6moU27F7h
 YwmIFrQnHMlYRHBtHnQP6tqrbPkjOL1BrB7oOBcX5wkCl.Ni.FNaSjcMLBpb
 fByGpasXo4qHryEeJmYYQX6Y8h1N92wb3g1f_grsGGMwjz0yvjP_MUmqaswz
 qa6pbJRro2JCMpmIuqMtyu_Jrh4fS7Eyt6V18HHIO6rICKvEGTPgIKYxwibr
 h4EUdqcvO4ONPp9VakKhbbZfSXRpWfyaGpSCdTLlB6DxXXyWSZcSNBa12wvE
 qhYBsRaHUiFv8mJvpRy.l0zgG5r0-
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Thu, 12 Aug 2010 00:22:43 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 2/2] MEMSTICK: Add driver for Ricoh R5C592 Card reader.
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1281515524.21459.14.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Maximum I might need to clear page status bits, but I can
> do that later
> after I write the block.
> This won't be any performance impact because amount of bad
> pages
> shouldn't be normally greater that zero.
> (Otherwise there will be data loss...)


These things do degrade. I think, memsticks do write-verify, so bad blocks
will appear during write and can be marked as such without any data loss.

> 
> One interesting thing that I just want your opinion on is
> what to do
> with correctable errors.
> Common sense suggests to relocate the sector + and mark it
> bad.
> But I don't know how common such sectors are, and thus I
> could do more
> harm that good by marking too many sectors as bad.

I agree that number of writes to the media should be kept minimal.
So bad (in either way) blocks encountered should be logged, but not
touched, unless the error appears during an actual write/modify operation.

> 
> I hope I create ms_block.c soon, and put that old problem
> to the rest.

If you have time and desire, try to put a low level format option in - 
some function to erase all blocks, except the system ones.

> 
> As time permits I will also port your driver for xD portion
> of jMicron
> device (which I have).

By the way, I've got some errata for the newer JMicron chipsets. If they
have not contacted you yet, I'll forward it to you.



      
