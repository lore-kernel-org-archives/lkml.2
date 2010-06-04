Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357Ab0FDDER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 23:04:17 -0400
Received: from n10-vm0.bullet.mail.in.yahoo.com ([202.86.4.194]:32606 "HELO
	n10-vm0.bullet.mail.in.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932280Ab0FDDEN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 23:04:13 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 937757.15214.bm@omp105.mail.in2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:References:Date:From:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=gu2fs+q6feBXfGctB0k8vaFD945PaOR3puGNDSPUjXpBoPqjj48v4w/wCjk5YL22uhS2eFrJ8nZ7j1q9CTJ+Cebuc3i3KZE17CEJfV3fnWc+hv4X6cIV1gr8GWxhNW0dbxPJnLrgQxBdClkzbFDOPbjToPhqVrpYn1UH70WvA34=;
Message-ID: <831753.25032.qm@web95619.mail.in.yahoo.com>
X-YMail-OSG: Iq1LspMVM1kCksXOp7dBZSoYYrEKB6ndSuENj6yzTkKGNCh
 GZoqsE_916evck.8id7.Lu9BJx6uPJ4E2nvqpwm2qHAv9swPpgLn0uGyvVHh
 HDx9VMxhMfQHDH7utudYiGtriAFT_36hb7myRtUFzlOYVOKFbZO.YWD8FnON
 7s_yTozEcSRvmz.voSdJAKWVKPuXibbs3VyQuVYDkqz_LEPxqPEbnNaz1HjV
 dxWQmKm86.b0-
X-Mailer: YahooMailRC/397.8 YahooMailWebService/0.8.103.269680
References: <324779.32661.qm@web95608.mail.in.yahoo.com>
Date: Fri, 4 Jun 2010 08:34:10 +0530 (IST)
From: Oza Oza <ozaoza1982@yahoo.com>
Subject: Re: [PROPOSAL] NMI & register clash handling infrastructure
To: linux-kernel@vger.kernel.org
In-Reply-To: <324779.32661.qm@web95608.mail.in.yahoo.com>
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



--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/




