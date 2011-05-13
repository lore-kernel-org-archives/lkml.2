Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab1EMEsZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 00:48:25 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45458 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab1EMEsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 00:48:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type;
        b=v1S54lLd80U1C2bfsgL+gjN548CouRQv/Q3qlf8sTtzs6wIzE1Lq4ARdy4nWeRdaYe
         5nhmq8rOBuNtgv5gQsdZo30H0YbiCa4QozoMRP/MH11mfboLBfopnni3q/YW41weNLnc
         demEb8XHwnStqgYEdF2RaWqywQOop0Zt0oeg0=
MIME-Version: 1.0
Date: Fri, 13 May 2011 00:48:22 -0400
X-Google-Sender-Auth: kC8QCNztfK4q6a4zJ63InOvKoFA
Message-ID: <BANLkTim_dH2skkaK5NKNrEMjfPSOyEq2rA@mail.gmail.com>
Subject: fork and sigprocmask as an atomic operation?
From: Till Varoquaux <till@pps.jussieu.fr>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If I understand properly the idiomatic way to set the signal mask in a
forked of process is to block all signals in the parent process before
calling fork and then setting the desired mask in both processes.

sigprocmask()
.....        <-- All the signals are going to be put in the pending list
clone ()
......
sigprocmask() <-- release all the pending signals that we care about.

Now; unless I am missing something this does not seem to play well
with threads. Providing several threads go through that exact dance at
the same time it seems as  could this result in the application ending
up with the wrong signal mask?

Is there any good reason to not add a new flag  to clone that would
block all signals in the child process?

Cheers,
Til
