Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab2DBRZa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 13:25:30 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41862 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab2DBRZ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 13:25:28 -0400
MIME-Version: 1.0
In-Reply-To: <CA+8MBbLROfbyfAGZ0xn1tZVHsndeTUNrn=-gHhsfzkocBLh=iQ@mail.gmail.com>
References: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
	<1333102459-23750-1-git-send-email-lenb@kernel.org>
	<1a022e3f1be11730bd8747b1af96a0274bf6356e.1333101989.git.len.brown@intel.com>
	<CA+8MBbLROfbyfAGZ0xn1tZVHsndeTUNrn=-gHhsfzkocBLh=iQ@mail.gmail.com>
Date: Mon, 2 Apr 2012 10:25:27 -0700
X-Google-Sender-Auth: tEI2LWmf53rRMTAcfZ6GcyH0ARo
Message-ID: <CA+8MBbJnrhKmy5f_pbL8Ogi1ihM-51hfqCDY5gUQ1hkvw7p22Q@mail.gmail.com>
Subject: Re: [PATCH 58/76] idle, x86: Allow off-lined CPU to enter deeper C states
From: Tony Luck <tony.luck@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Len Brown <len.brown@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +       while (1) {
>> +
>> +               if (cx->entry_method == ACPI_CSTATE_HALT)
>> +                       halt();

What's the intent here?  I think that I can just set up a function pointer
named "halt" on ia64 and point it to my cpu_halt() function (which looks
for the deepest C-state, and then calls PAL to enter it. Is that equivalent
to what the x86 "halt()" function does?

-Tony
