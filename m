Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932917Ab0HLH11 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 03:27:27 -0400
Received: from web37601.mail.mud.yahoo.com ([209.191.87.84]:37658 "HELO
	web37601.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755778Ab0HLH10 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 03:27:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=iAonhL+m9HYHuWoe3wOeqZ1VfYYugwJLjFd4H1mW+nX0gdC6TCR3OL8cR7RyPVHJ8Yhp/W5JszyJVwjKqdzYqwGAKbx6K+WMflUiohrccY+o6dMVLLIf1+koQSo1uajL4gVxEPFKti/xFf6XTmR/B1wP6CBKEg45Km+NnLKu8TE=;
Message-ID: <535171.19301.qm@web37601.mail.mud.yahoo.com>
X-YMail-OSG: td47kiEVM1l79MUE8otncdv4zZJtPhWWT2t9mnKSylHwGYR
 qP9RkdPCfw3BHkP4E0WvV_G3TXaL1vl0lpEDvSdrp4Uzj4NAwfqPnqhYXbIR
 pxntYeOUwnxGQVFjopZsDYOKzVEchSQ2BXB0TYKS1kusREeIbSU4jrZV5j0L
 Qb8bbQductfvOpToMOTPa.wdKcKC6aFL4sBEA2WK94291wpxIkcwEpkVDmav
 EMYESoHYEa1FXau5MlMYMLXRZ3VF20NwMXEcf.ormmNYTqZupLSVUo54.JYF
 .xjalQxlVIhwdR09LRi4y0HPs9_346YvbkNOyTf30rr0Ea15cJt5UCg--
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Thu, 12 Aug 2010 00:27:24 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: JMicron chipset update
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1281515524.21459.14.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apparently, the values I was using to configure a jmicron memstick
interface only work with some chipset revisions. So they've sent me the
following message.

If you've got a working jmicron adapter handy, you may want to try these
changes.

-----------------
We found that there is a definition problem in your code about
JMicron MS Controller.
    Our new product would get problem with this part.
    Following is the bit definition in our code.

    // --- Clock Control Register - Offset 0x48 --- //
    // D[31:4] Reserved
    // D[3]    Force MMIO Control.  0: Control by PCI CNFG, 1: Control
by MMIO.
    // D[2:0]  Clock MUX Select
    #define MSHC_CLKMUX_CONTROL_BY_MMIO   0x00000008
    #define MSHC_CLKMUX_CLK_40MHZ                  0x00000001
    #define MSHC_CLKMUX_CLK_50MHZ                  0x00000002
    #define MSHC_CLKMUX_CLK_62_5MHZ              0x00000004
    #define MSHC_CLKMUX_CLK_60MHZ                  0x00000010  // Must
set PCICnfg Offset BCh D[0] to 1
    #define MSHC_CLKMUX_CLK_OFF                      0x00000000
    #define MSHC_CLKMUX_CLK_MASK                   0x00000017

    Driver have to set this register to 0x08 to clear default clock
setting.
    And then set its value with specfic clock setting (EX:  40MHz ->
0x09, 50MHz -> 0x0A) to change clock.
    (For MS Pro-HG, we suggest to use 50MHz with 8-bit parallel mode.)
   
    Besides, driver have to set the register to 40MHz setting before
identify MS card for safe.





      
