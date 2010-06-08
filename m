Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab0FHJEW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 05:04:22 -0400
Received: from n13-vm0.bullet.mail.in.yahoo.com ([202.86.5.183]:24936 "HELO
	n13-vm0.bullet.mail.in.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754006Ab0FHJEU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 05:04:20 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 928228.39305.bm@omp113.mail.in2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=wkU7ZWf3TIcegXhyazfC4uVC6JA6mVDlD/7sfaqPXUxBXKG8nc/KJ02oFPCU/6yW97Sy80af/nraR6Cb+Z1m6m9TsKp7txDSdWvE7AAuvlnJrw/geHmxAx/wjFYKGmaZwJR1Rh7AUKb9eDu8zOJ7PpbN0tfssjYFpe9VXL1WkEk=;
Message-ID: <825203.31628.qm@web95605.mail.in.yahoo.com>
X-YMail-OSG: H5WMADUVM1nofg1_xEsm98P7CSOvdQ3lgnWVau_IgThEOna
 _J_kOz5Op9OxY..rn0pDmhYK5cmdnUEfcL1ldct2w2bnJ5X01_gBoYcIMEZv
 K_Kib2jux1XmM7.VR4A_1xnVcbky_hwitXKtdWbkEAsHIQpMHW.qf8HumNgb
 2omHFHI0q61UakQjr1vDxIM7ZIAEHrDhI6ORQ
X-Mailer: YahooMailRC/397.8 YahooMailWebService/0.8.103.269680
Date: Tue, 8 Jun 2010 14:34:17 +0530 (IST)
From: Oza Oza <ozaoza1982@yahoo.com>
Subject: [PROPOSAL - FIRST POST] NMI & register clash handling infrastructure
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




