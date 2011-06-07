Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab1FGI1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 04:27:42 -0400
Received: from smtpout02.highway.telekom.at ([195.3.96.113]:44222 "EHLO
	email.aon.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752080Ab1FGI1k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 04:27:40 -0400
Date: Tue, 7 Jun 2011 10:27:35 +0200 (CEST)
From: Johannes Bauer <hannes_bauer@aon.at>
Reply-To: hannes_bauer@aon.at
To: Peter Zijlstra <peterz@infradead.org>, hannes_bauer@aon.at
Cc: Monica Puig-Pey <puigpeym@unican.es>,
        Rolando Martins <rolando.martins@gmail.com>,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx <tglx@linutronix.de>
Message-ID: <17185480.5304.1307435255996.JavaMail.root@WARSBL214.highway.telekom.at>
Subject: Re: Changing Kernel thread priorities
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Priority: 3
X-MSMail-Priority: Normal
Sensitivity: Normal
X-Originating-IP: 81.223.102.6
X-Mailer: aon Webmail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Absolutly correct!

However, if you are running the system on an embedded platform, where the _WHOLE_ system (including priorities) is preconfigured and never touched, starting a irq thread with the right prio from start is a more straightforward method than having to invoke a script that changes it using userspace chrt tool.

Regards JB
----- Ursprüngliche Nachricht -----
Von: "Peter Zijlstra" <peterz@infradead.org>
Erhalten: 07.06.2011 00:36
An: hannes_bauer@aon.at

"Monica Puig-Pey" wrote:
> 
> I need to change the priority from inside the driver, when creating the 
> kernel thread.

No you don't. How does you driver know about what priority is correct
wrt all the other running RT tasks on the system?

Determining the right priority in a fixed priority scheduling system is
a system wide problem, nobody but the administrator can possibly even
begin to solve it.

There's a reason all RT irq threads are started at 50, its plain
impossible to do better.

--
To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at http://vger.kernel.org/majordomo-info.html
