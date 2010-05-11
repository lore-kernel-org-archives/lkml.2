Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab0EKFSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 01:18:32 -0400
Received: from n14-vm0.bullet.mail.in.yahoo.com ([202.86.5.219]:35946 "HELO
	n14-vm0.bullet.mail.in.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753005Ab0EKFS2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 01:18:28 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 742987.35385.bm@omp102.mail.in2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=q+Se9AzkP/1F1jW3m7h2NnHXBk2CE6EsjaIuZ0FX+mJZ1jkWd9v8kVr07eLdWHRmNTX/G8mvU0yxqhaIgV9Eegsa/KCpzeokV5Y7nM3I4hA1AmC5xTCoNpVSU09KaEid+iN34BJNBsf+Rjm2G7XGnIKRR1jBVlegKwN369keM7U=;
Message-ID: <214673.68504.qm@web95620.mail.in.yahoo.com>
X-YMail-OSG: il_uxDoVM1k73V6ZW06LKpgwctEvGfUjaA23bRVq64cCwpX
 n2S6esVMZ62a3dBzXsyVMwHaIl74F4mL9ft3.UaJvkoQAEr9x.QQl.yTZiOx
 fHSx.21qcuLykMVOgUxAPLGdHuDdQGtlKWA7QP_6I4cJRSkt_9w9O.c.6gOP
 8JEDFRSqEpJZGL..Br6.Hoe2riBXw.xmelSid
X-Mailer: YahooMailRC/374.4 YahooMailWebService/0.8.103.269680
Date: Tue, 11 May 2010 10:21:43 +0530 (IST)
From: Oza Oza <ozaoza1982@yahoo.com>
Subject: [PROPOSAL] NMI & register handling infrastructure
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




