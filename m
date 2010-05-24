Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163Ab0EXJto (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 05:49:44 -0400
Received: from n8-vm0.bullet.mail.in.yahoo.com ([202.86.4.189]:23501 "HELO
	n8-vm0.bullet.mail.in.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753603Ab0EXJtm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 05:49:42 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 434217.99501.bm@omp109.mail.in2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=0fsW7Fuv9KoSvO1KWHVSJMkm1V7pMuTAeUjwU9kOEzj0GwTg4gotRFcZAf97sYgIYVVHYetJaJKCF6QhJqRtEYgOhgld6a6vrLHH+kwDL/fngu2ErdeurraRvATxfDxyjDSLtcOAllGWrkUYyL/joH0uG0OIo+Bx6RnaidGTm6I=;
Message-ID: <324779.32661.qm@web95608.mail.in.yahoo.com>
X-YMail-OSG: 74YPmecVM1l4u7S9ah108EwKluTpbTB.ET0MuwtLU3heXek
 Qd6sVZijwDzFmC6p63Ok3h.HSH9tFb7vE6iNUXePp_xJMewN20hJqDRMtYru
 4p2zZToayv6_05MZQi2.tSryVsr_rMUHN5T.xfCM0ZnTHZnOQdcGYH77shev
 i5YftOIYGt9BHJd.kbkFWcVv_AHUnpjZvFH.n
X-Mailer: YahooMailRC/374.4 YahooMailWebService/0.8.103.269680
Date: Mon, 24 May 2010 15:19:40 +0530 (IST)
From: Oza Oza <ozaoza1982@yahoo.com>
Subject: [PROPOSAL] NMI & register clash handling infrastructure
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hi,

This is my first post to the group, please excuse me, If I unknowingly miss to follow writing ethics.

Proposal/Need: 

I was working on providing accurate process usage support, and writing a kernel module, 
I configured cpu-core-unhalted-event and configured LVT (local vector table) with NMI (non-maskable interrupt), and surprisingly Oprofile stopped working, 
Then I realized, that set_nmi_call back just overwrites nmi_callback function pointer. 

My proposal/idea/thinking is; 
have a kernel module which accepts NMI registration from any kernel component, and providing support to the the any kernel service which basically need to service NMI.
It may not only supports this, but also can provide central infrastructure which has capabilities such as granting MSR (model specific register) access to the the modules, which may avoid potential clash of MSRs (e.g. two modules are trying to configure same MSR), control NMI registration-unregisteration events etc..

I am not sure, whether this is a good idea or bad idea, but I thought it adds flexibility and some value addition in kernel, 
and I find this place precisely right to post this idea. 

Any feedback/suggestions/additions would be appreciated. 

Regards,
Oza.



