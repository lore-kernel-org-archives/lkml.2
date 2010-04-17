Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab0DQFhO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 01:37:14 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:41913 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab0DQFhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 01:37:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=apUPwxm8XriYqDQMMY7SBSMclDJ1+RkSzL1gA3XMHPF2RSEBkppA7SbXrW/zJcEUgw
         yqkHzPIWGFckuL90QJilUHxFNbupQohYpiOKArqjjETrVri9zkmczxgeDcnuVyQyWSlv
         1Sw3oNjb2yAOCK84fHR1gO6sltc4A2Od+w+QE=
MIME-Version: 1.0
In-Reply-To: <20100416152041.GA28863@sortiz.org>
References: <1271113496-6744-1-git-send-email-linus.walleij@stericsson.com>
	 <20100416152041.GA28863@sortiz.org>
Date: Sat, 17 Apr 2010 07:37:09 +0200
Message-ID: <r2n63386a3d1004162237k9095e85fz40fede9ad501fb5c@mail.gmail.com>
Subject: Re: [PATCH 1/3] MFD: renamed ab3100.h to abx500.h
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
       STEricsson_nomadik_linux@list.st.com,
       Mattias Wallin <mattias.wallin@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/4/16 Samuel Ortiz <sameo@linux.intel.com>:
> On Tue, Apr 13, 2010 at 01:04:56AM +0200, Linus Walleij wrote:
>> The goal here is to make way for a more general interface for the
>> analog baseband chips ab3100 ab3550 ab550 and future chips.
> I have an initial question for you:

> Do you plan to have one single driver supporting the 3100, 3550 and the 550
> chips ?

Not really, just one common interface. The 3100, 3550 and 5500 share
sub-blocks so for example the RTC driver in drivers/rtc/rtc-ab3100.c should
be possible to use with either of them, but the core driver implementation
will likely differ. (We might need to rename the file for clarity though.)

A main point of difference will be how these are accessed: right now the
AB3100 and AB3550 are on the I2C bus, the AB5500 will have access
through a special on-chip controller instead.

So the driver/mfd/ab3100.c|ab3550.c|ab5500.c will be different, but all
implement the API from include/linux/mfd/abx500.h and subdrivers will
hopefully be possible to share.

Yours,
Linus Walleij
