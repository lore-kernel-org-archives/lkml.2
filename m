Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab1HUDyM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 23:54:12 -0400
Received: from nm1.bullet.mail.bf1.yahoo.com ([98.139.212.160]:33734 "HELO
	nm1.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751302Ab1HUDyJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 23:54:09 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 445410.87728.bm@omp1054.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=MfXQYPHn7wltqTkVL3m8FD2ocPb2rBvJxci5Aq+LS4flGsJn5oa+GYurLIxNggsNlMymc6rVmbJ+vFLMlkiwpfIUHRcjQwyQ1G7cNX5MMjG6S9kgjuqg0MgK2cEMUwg1q+ripINDwsJt9m2Dj79WYMsflrM83kVTMwZQgmRZOWs=;
X-YMail-OSG: eTQF6eEVM1lDC68VWnXH9ehXPnAAeuNczh1OzD13GDsMIOW
 ucFMExnmPkkW3TxmOKciMB5ndfWngWHzBUHXvWAc1C1YQGxWBuiUyIGWBcZU
 uObUIF8gvzAGEyOqAU4gi.JyCdVf45GOoF0EIIeveXUm_GVAahm879uBmi0W
 D8k8.gu7Fo1WKGqfVUb_UejnA.Dlaq_.OQ2UziQFS3_ZmhlE_wTttcX7GNF1
 FTAR.fnih62MP9W_fOrsOlHeCB3zzoyhOkggZT7kCTNwKIcpaylT0vZFOLqo
 1LMnB3Pz15CwD5AqleG.lgIc1Qk7YmmYk1yf2jhEojoIAG7q_XGANG2uKD_t
 zPlR9sD1yJpXpkJ5kmWmrkCc4aJCJXx60rWhtwwtms_vSGiIrSN3Taoa4y6N
 wOZcMhaUNSM8rTBnxARf4thkhdBtOfaggc.96cJwzdQH6KmF_3g--
X-Mailer: YahooMailWebService/0.8.113.313619
Message-ID: <1313898848.75462.YahooMailNeo@web162014.mail.bf1.yahoo.com>
Date: Sat, 20 Aug 2011 20:54:08 -0700 (PDT)
From: Pintu Agarwal <pintu_agarwal@yahoo.com>
Reply-To: Pintu Agarwal <pintu_agarwal@yahoo.com>
Subject: help for kernel initcall section (init.h)
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
 
I need some help in modifying initcall section in init.h.
 
That is :
 
#define __define_initcall(level,fn,id) \
 static initcall_t __initcall_##fn##id __used \
 __attribute__((__section__(".initcall" level ".init"))) = fn
 
I have to create two different kinds (and later more) of init section and use one of them based on some condition.
For example, I have one init section for normal mode and one init section for charger mode.
During charger mode, I do not have to execute all the initcall so a charger.initcall is create with lesser init function.
The charger initcall section is as follows:
#define __define_charger_initcall(level,fn,id) \
 static initcall_t __charger_initcall_##fn##id __used \
 __attribute__((__section__(".charger.initcall" level ".init"))) = fn
 
 
Now the problem is that during compile time both of them needs to be polulated based on CHARGER_MODE is enabled or disabled.
How can this decision be taken during compile time under the macro "__define_initcall" ??
 
Something like :
 
#define __define_initcall(level,fn,id)     \
                                                       static initcall_t __initcall_##fn##id __used \
                                                       __attribute__((__section__(".initcall" level ".init"))) = fn  \
                                                       #if defined(CHARGER_MODE)  \
                                                       static initcall_t __charger_initcall_##fn##id __used  \
                                                       __attribute__((__section__(".charger.initcall" level ".init"))) = fn   \
                                                       #endif
 
Right now this cannot be done, as macro cannot exists inside a macro statement.
 
If any body have any alternative or better idea of doing this please help.
 
In gernal, how can I take decision during compile time itself and decide which initcall to be used instead of calling all of them.
 
 
 
Thanks, Regards.
Pintu
