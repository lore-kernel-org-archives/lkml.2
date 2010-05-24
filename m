Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707Ab0EXJtQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 05:49:16 -0400
Received: from n9-vm0.bullet.mail.in.yahoo.com ([202.86.4.193]:35224 "HELO
	n9-vm0.bullet.mail.in.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753603Ab0EXJtP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 05:49:15 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 83089.93071.bm@omp105.mail.in2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:References:Date:From:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=vctVhrIIFWHis+72tyzAZLmdy66BuGgb7SDxzpzsU2bdmGb7+C2qZGv5RRccBRtYCLd/xPgXVsA8rJOpZF350jHJv+3uv7rSSdyUxN46Qa0A0H6AM13Yz/eiI6WmZjmydasWqzDFjIRenMJkdgChRmiokIca6tpEOFGsfEXh/LM=;
Message-ID: <8269.56017.qm@web95620.mail.in.yahoo.com>
X-YMail-OSG: iNaEU0sVM1kThNniWSEe4MUEVOnI7iUwPaekGjKEEVQ8LI1
 NComDPuf7_TfWTz4hcVPXYEsxw2.X0gQTOpVNIYvz.S4qsajsK6T_EUPvW8B
 aODM.wfTiqdB2GB1dr32HwgagOEuhXXl3cYzr8Ygqvjg5TSx1W7CJEY70gHf
 XkwsRD1TzW30ls7wVi_8jgHbRVLRs6SYm3acN
X-Mailer: YahooMailRC/374.4 YahooMailWebService/0.8.103.269680
References: <214673.68504.qm@web95620.mail.in.yahoo.com>
Date: Mon, 24 May 2010 15:19:12 +0530 (IST)
From: Oza Oza <ozaoza1982@yahoo.com>
Subject: [PROPOSAL] NMI & register clash handling infrastructure
To: linux-kernel@vger.kernel.org
In-Reply-To: <214673.68504.qm@web95620.mail.in.yahoo.com>
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




