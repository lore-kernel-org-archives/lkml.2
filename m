Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab0EKE46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 00:56:58 -0400
Received: from web34405.mail.mud.yahoo.com ([66.163.178.154]:38572 "HELO
	web34405.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751559Ab0EKE44 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 00:56:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.br;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=0kCNoyMdfapzpqIplCREXdI+cy8po6ljaV+rem4+6s1Njgju+qNZ2L0/CLDKwX8atgm33n1ejmUaaY5aI9CMUsump/GTGpM3bsoN51t654oxwKBfYOFOw0+jJOdvajsaEIqebQ8M3CV2iKARvBsjvadYNYUsyIBT5vYAehDnX9o=;
Message-ID: <873867.32648.qm@web34405.mail.mud.yahoo.com>
X-YMail-OSG: O7umHisVM1mGDPTBAeuO9bTm0.zS641JyXrWtp.pNHopysY
 c5Dd8EZOO9lNREHp2BEvMbtlNJSox4zDpO7Hdez_0bTqQy3Chi2zSZK4V0H7
 Mu_XV77p_yx8SLADQDuH8T96pFGdE1uNHLtaY5EF3uf0.uCbBLRg0Aromw0g
 psp69ltQx8_MwtuiFUh_vQMWhE7EnFTYzX1Lhy1fK1ggONv2EcJ_VOKqv66d
 nW5.emTXVPz1fuuEcNWDdGq8CQH8yHjPVjV7llpEKoOKXCnyju6QVRYL5ozR
 UiZetV25DSTodVJ8dNYQHvRMj_DO86czAG44lY.J0gftFTmwa7gJ12A--
X-Mailer: YahooMailClassic/10.1.11 YahooMailWebService/0.8.103.269680
Date: Mon, 10 May 2010 21:56:55 -0700 (PDT)
From: Jose Luis Marchetti <joseluismarchetti@yahoo.com.br>
Subject: What locks are needed to safely use vma->vm_file ?
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It appears that doing down_read(&mm->mmap_sem) is enough to safely use vma->vm_file, is it correct ?

Also in the lock subject, to get to all vm_files in the system, is the following correct or something is missing ?

read_lock(&tasklist_lock);
for_each_process(p)
{
    mm = get_task_mm(p);
    down_read(&mm->mmap_sem);

    // ... Here what I need to do with this mm vm_file objects

    up_read(&mm->mmap_sem);
    mmput(mm);
}
read_unlock(&tasklist_lock);

Thanks in advance for your answer
José Luís Marchetti


      
