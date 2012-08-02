Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121Ab2HBIGl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 04:06:41 -0400
Received: from nm5-vm1.bullet.mail.ukl.yahoo.com ([217.146.183.233]:40584 "HELO
	nm5-vm1.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752601Ab2HBIGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 04:06:36 -0400
X-Greylist: delayed 386 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Aug 2012 04:06:35 EDT
X-Yahoo-Newman-Id: 283318.47931.bm@smtp106.mail.ukl.yahoo.com
X-Yahoo-Newman-Property: ymail-5
X-YMail-OSG: wQP7TzwVM1nFUkQgHBrSplR.6MMjxDPODVSQRF4QQyhACLZ
 pFXYkbFOToAu1OAe8OpDPrMh_dYoYYLYQaY1oYp.cF6qeJrVB67T4b7iE8Gd
 U639p9gIsaEs0n8HeBiCwvptJmjkOcuSVQ6rU0HYb_7.v6Gt8oYY5Jsn.su4
 xKeJI89y0NyYW42k4tqL5jyQdlFqyVWFukXw9cgLkRYK9z1T82HMd4s29Hhc
 mghAmuJrD63yTM9eLHJzRmjWfqFiZPpdpIxEdUiWnmnSSFPg8_Qny03Elj.m
 Yd3_2g7mG3eBC0SU_g9APEgUF1LO1adHs7h4R3HofbPNLc_oZ0aPfLodUtis
 ugOjWlQb4mUg5hVbH1T7zR7Jw2iFhFRwLl8Vn7fX2j2M9R8EQJkipcGKW7Am
 W4T5lXOTCoCdKUwBMzbNWo7qAI4g91_lsDL91mM0o2TO0pudPTkw6T9f5rBg
 -
X-Yahoo-SMTP: mOFZFAuswBAG4_8a4ZBj.Wmvw2Qxc4R7nmE-
From: Schrober <franzschrober@yahoo.de>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: checkpatch.pl: Wrong check SINGLE_STATEMENT_DO_WHILE_MACRO
Date: Thu, 02 Aug 2012 10:00:04 +0200
Message-ID: <4204029.7cYAuJfu4T@bentobox>
User-Agent: KMail/4.8.4 (Linux/3.2.0-3-amd64; KDE/4.8.4; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I think your check for SINGLE_STATEMENT_DO_WHILE_MACRO is wrong. Just to give 
an example:

#define foobar(x) \
	do { \
		if (pizza_ready(x)) \
			eat_pizza(x); \
	} while (0)


if (hungry(y))
	foobar(x);
else
	barfoo(x);

checkpatch does now complain about something like "WARNING: Single statement 
macros should not use a do {} while (0) loop"

But we would have an ambiguous else when the do-while is removed. The code 
works as expected with the do-while but the else is "attached" to the wrong 
"if" when the do-while is removed.

And yes, this example is made that easy to make it easy to understand. There 
are examples were static inline code would not work very well (vararg for 
example).

Please fix or remove your check. Otherwise some people will be start to 
overeagerly change these macros and break the kernel doing that.
-- 
Franz Schrober
