Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab0DZHEi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 03:04:38 -0400
Received: from n8-vm0.bullet.mail.in.yahoo.com ([202.86.4.189]:28254 "HELO
	n8-vm0.bullet.mail.in.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753717Ab0DZHEh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 03:04:37 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 123015.69176.bm@omp102.mail.in2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=ahYxE0EaEKX3FjMm6/6wA0APSAx9hWGK17p9yFRKi7AnUoPxTpf1i9g5r12pqe8jHfJnNhU1SpRRonefDaLoL5t7zppOlh4NhrW+uz9HGzGdnTTmY+8r9PxpYtUuNJyKLPrsSVgNjttMEf7zB2efVzfAA+D7ic6vV/16v2NqDms=;
Message-ID: <994542.25479.qm@web95602.mail.in.yahoo.com>
X-YMail-OSG: icmPmZcVM1lJPXNOxCle3uGbClsd6.mMCgcJgaDGFKgg1TB
 NMdauXfBOHAxGAluOlglCpqTX0.E1TSPC1zUfF7Haj_rwCRRSfMUeIq8vUN.
 tFHXUVgFf3X3OGQ3FMzHKtmQ6Wh3OR8RHzmqz2AWgFLobwrTeTGv1Vh8VdZt
 GuaEABM9lt.Lq2AswhLYJdyC3Mfn3Y.6rWU7P
X-Mailer: YahooMailRC/348.5 YahooMailWebService/0.8.102.267879
Date: Mon, 26 Apr 2010 12:34:34 +0530 (IST)
From: Oza Oza <ozaoza1982@yahoo.com>
Subject: NMI callback & register handling infrastructure in linux kernel (arch - x86)
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



