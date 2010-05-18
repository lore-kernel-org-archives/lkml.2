Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab0ERGnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 02:43:19 -0400
Received: from n13-vm0.bullet.mail.in.yahoo.com ([202.86.5.183]:30093 "HELO
	n13-vm0.bullet.mail.in.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753035Ab0ERGnR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 02:43:17 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 401074.22724.bm@omp105.mail.in2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=ov2QK7amiTzQGNBVJzTzcRW7zacN8G6HkqKHtFhL/eWSI3G9rwmcbmIjernnQLX7HwQVBxZIWmT3dXClbHJuyV3wupm+tGXHuAHnkpf9dfoxrPu+CCIXw9kzntFssCkZN37f6yUUk4nY7cF7n3lEhwy5/FIuf/gH4gygS3ZUTfk=;
Message-ID: <240806.57587.qm@web95616.mail.in.yahoo.com>
X-YMail-OSG: lKw1UaUVM1mM6g6n53zh8K3qgjyNmiPrOlWqIdEJVtDF8Eh
 R3qRL12AJQvyao5ot3k8g.fpHZzO7U_dps7y1zzgQfagcIp3CkvdjYpaIYmi
 V039z9c3zvT8J4Dv0zaACscHDDxJxxod96fuUBTO51WG9ED8YW.ZwjZUAcrZ
 yXx4A.b6z5ldIYuqRx2jx1O7XiC15ev8SSC7u
X-Mailer: YahooMailRC/374.4 YahooMailWebService/0.8.103.269680
Date: Tue, 18 May 2010 12:06:32 +0530 (IST)
From: Oza Oza <ozaoza1982@yahoo.com>
Subject: [ !! PROPOSAL !! ] NMI & register handling infrastructure
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
I configured cpu-core-unhalted event and configured LVT (local vector table) with NMI (non-maskable interrupt), and surprisingly Oprofile stopped working, 
Then I realized, that set_nmi_call back just overwrites nmi_callback function pointer. 

My proposal/idea/thinking is:

have a kernel module which accepts NMI registration from any kernel component, and providing support to the the any kernel service which basically need to service NMI.
It may not only supports this, but also can provide central infrastructure which has capabilities such as granting MSR (model specific register) access to the the modules, which may avoid potential clash of MSRs (e.g. two modules are trying to configure same MSR), control NMI registration-unregisteration events etc..

I am not sure, whether this is a good idea or bad idea, but I thought it adds flexibility and some value addition in kernel, 
and I find this place precisely right to post this idea. 

Any feedback/suggestions/additions would be appreciated. 

Regards,
Oza.



