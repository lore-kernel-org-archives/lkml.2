Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759375Ab0GPWCx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 18:02:53 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61198 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907Ab0GPWCw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 18:02:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=TVc/3JE1NrgB9R5ZTkBYLa/OX3RGv9V9jRE3CvFJwHPl3o+bn56xXrKF4oB30yg3Nr
         2vnxavZtfXYapPDIeIVp/vUckkD51blin8vzbHEVsp7kWzV6vI7Dx0aX/ifx9tzyQF/n
         ZqvU6s4GqenoDr2VIcmBvBmw9SmgCLrgbG+yo=
MIME-Version: 1.0
Date: Fri, 16 Jul 2010 16:02:50 -0600
Message-ID: <AANLkTineI34tKDMPYN4SPY0W432cv8ZPc55IEW5hwmed@mail.gmail.com>
Subject: Re: [patch 2/2] x86 NMI-safe INT3 and Page Fault
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Date Fri, 16 Jul 2010 14:39:50 -0700
>From Linus Torvalds

> Linus Torvalds wrote:
> But we're not talking about non-NMI code.Yes, we are. We're talking about breakpoints (look at the subjectline), and you are very much talking about things like that _idiotic_vmalloc_sync_all() by module
> loading code etc etc.Every _single_ "solution" I have seen - apart from my suggestion - hasbeen about making code "special" because some other code might run inan NMI. Module init sequences having to > do idiotic things just becausethey have data structures that might get accessed by NMI.And the thing is, if we just do NMI's correctly, and allow nesting,ALL THOSE PROBLEMS GO AWAY. And there is no > reason what-so-ever to dostupid things elsewhere.In other words, why the hell are you arguing? Help Mathieu write thelow-level NMI handler right, and remove that idiotic"vmalloc_sync_all()" that is
> fundamentally broken and should notexist. Rather than talk about adding more of that kind of crap.
>
> Linus

So Linus, my understanding of Intel's processor design is that the
processor will NEVER singal a nested NMI until it sees an iret from
the first NMI exception.  At least that's how the processors were
working
when I started this unless this behavior has changed.    Just put a
gate on the exception that uses its own stack (which I think we do
anyway).

Jeff
