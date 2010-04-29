Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab0D2DXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 23:23:31 -0400
Received: from n11-vm0.bullet.mail.in.yahoo.com ([202.86.4.227]:29390 "HELO
	n11-vm0.bullet.mail.in.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751345Ab0D2DXa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 23:23:30 -0400
X-Greylist: delayed 333 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Apr 2010 23:23:29 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 64569.42492.bm@omp109.mail.in2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:References:Date:From:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=0L9IbKaTUVghqR0G5dfnrqQs9u1UmhZl+0Rhrht9Q4yemAd4xkVYBNUJ5rru4ZsEwVjAfYD69/hiOu4tiRV8EqN7Je/ufzhoLRFtwTpTgCe59k6FZ8rooGgYB8l0/QxuHOT1W15qiTo3yHFTDBto1Q9ZuALK1pYZ4B9g3VSu31c=;
Message-ID: <774168.91484.qm@web95616.mail.in.yahoo.com>
X-YMail-OSG: A53zGzMVM1lY2BbcZnjYJ_ceYinu49uFD_Wggpwaop1avjr
 FAS7sRnMJ_sNV2EORKO.NfmoSUnhzgdGQteY5AnF1AzGYoNHCTguK1iCAkrV
 O8DzRmRNtqydOIu9vZeIDJz2cuhXgFO9ucgpMgircS62Oz7uOqmy7w60uEwC
 2TtSDgTUgK0vcmo0uH0Qw5QmaJPK4MpUyS.9.OtuMzSwUUanUiuz3kO5m2GK
 oHRabIkM-
X-Mailer: YahooMailRC/348.5 YahooMailWebService/0.8.103.269680
References: <994542.25479.qm@web95602.mail.in.yahoo.com>
Date: Thu, 29 Apr 2010 08:41:11 +0530 (IST)
From: Oza Oza <ozaoza1982@yahoo.com>
Subject: NMI & register handling infrastructure - x86 (my first post)
To: linux-kernel@vger.kernel.org
In-Reply-To: <994542.25479.qm@web95602.mail.in.yahoo.com>
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




