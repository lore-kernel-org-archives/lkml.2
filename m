Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367Ab0FDDEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 23:04:43 -0400
Received: from n13-vm0.bullet.mail.in.yahoo.com ([202.86.5.183]:30758 "HELO
	n13-vm0.bullet.mail.in.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932346Ab0FDDEk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 23:04:40 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 589272.73894.bm@omp109.mail.in2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=wi21B8YviufKhUbsq5A+55c0RDtwNzvd91TQScDJkq7A739G3VovE9+jKucAnsH+ZCfVfN7hEZ9CAliXTH+jqjmZDXt3wZjYisIDED+fzaBW5H++NKNLObMnFiD8LzpISlhGOQvjPmlsi3K1B0cuAN0smL+sr37XUQ44J+QaCqs=;
Message-ID: <498215.15423.qm@web95620.mail.in.yahoo.com>
X-YMail-OSG: FbouzFEVM1mU5PpPH57EfwthQC792r4bBUyW8wx_q69WrFv
 ikGctirg1H4Ez7v53ie3DPNta_jE6rDHj9vPEaf9jTipZGtzdZSwbCMHVX.l
 kuDIxkWXCHf.ocJVklx6t5wn_KovSYkk4HpuxPDaACoXgmCsvt16bUm7pjyH
 JhX_vMAQWCMesvsEZHtomyfIuyn.GGVJgq2cXEZ_pm9gvTojznFTgMninx7g
 gB2ezyUhv730-
X-Mailer: YahooMailRC/397.8 YahooMailWebService/0.8.103.269680
Date: Fri, 4 Jun 2010 08:34:37 +0530 (IST)
From: Oza Oza <ozaoza1982@yahoo.com>
Subject: Re: [PROPOSAL] NMI & register clash handling infrastructure
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



--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/



