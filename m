Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460Ab0JBTQV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 15:16:21 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:60746 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab0JBTQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 15:16:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type;
        b=R8zihf2FCFZLaOkpgEqwx8YMUWTEWu0D91Z13ZB8/3RvfUG2g68nG6iL64+NS2TqDw
         2/F8GVnIaaor3WYHmZ7Xj0Y/BTrLco6fsdFcD/3sEkfVZzkRKcy0XeJCIt/9wG384S5J
         h10pSKf9f/szdq1NMC4KATB3Z4QtTtWPmhwG8=
MIME-Version: 1.0
Date: Sat, 2 Oct 2010 20:16:19 +0100
X-Google-Sender-Auth: lgPQk0o1zxVpaE4HlZuVzomBQP0
Message-ID: <AANLkTimF2tcksBkww50MhiO0YY=MCt4rcnfDR+tJhTUJ@mail.gmail.com>
Subject: Dynamic nop selection breaks boot on Geode LX
From: Daniel Drake <dsd@laptop.org>
To: jbaron@redhat.com
Cc: Andres Salomon <dilinger@queued.net>, Chris Ball <cjb@laptop.org>,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

linux-next fails to boot on OLPC's XO-1 laptop based on Geode LX processor.

This is because of

commit f49aa448561fe9215f43405cac6f31eb86317792
Author: Jason Baron <jbaron@redhat.com>
Date:   Fri Sep 17 11:08:51 2010 -0400

    jump label: Make dynamic no-op selection available outside of ftrace

http://git.kernel.org/?p=linux/kernel/git/mingo/linux-2.6-x86.git;a=commitdiff;h=f49aa44

The Geode hangs inside the asm() statement inside arch_init_ideal_nop5.

Any thoughts?

I'm a bit out of my depth debugging assembly code, but will happily
take pointers and patches to help diagnose.

cheers
Daniel
