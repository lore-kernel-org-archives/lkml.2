Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935259Ab2JaJHY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 05:07:24 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:48079 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933720Ab2JaJHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 05:07:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: ACPI errors with 3.7-rc3
Date: Wed, 31 Oct 2012 10:11:21 +0100
Message-ID: <2089727.VKpW8oC7hj@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
In-Reply-To: <20121031014527.GA2984@kroah.com>
References: <20121031014527.GA2984@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Tuesday, October 30, 2012 06:45:27 PM Greg KH wrote:
> Hi Len and Rafael,
> 
> With 3.7-rc3, I'm seeing a constant stream of these errors in the kernel
> log for my MacBook Pro:
> 
> [30443.430133] ACPI: EC: input buffer is not empty, aborting transaction
> [30443.430145] ACPI Exception: AE_TIME, Returned by Handler for [EmbeddedControl] (20120913/evregion-501)
> [30443.430162] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPCB.EC__.SMB0.SBRW] (Node ffff88045cc64618), AE_TIME (20120913/psparse-536)
> [30443.430179] ACPI Error: Method parse/execution failed [\_SB_.BAT0.UBST] (Node ffff88045cc64988), AE_TIME (20120913/psparse-536)
> [30443.430188] ACPI Error: Method parse/execution failed [\_SB_.BAT0._BST] (Node ffff88045cc648c0), AE_TIME (20120913/psparse-536)
> [30443.430202] ACPI Exception: AE_TIME, Evaluating _BST (20120913/battery-464)
> 
> They never showed up before in 3.7-rc2.
> 
> Anything I should try out to resolve this?

Well, there are the following two post-3.6 EC-related commits:

commit 67bfa9b60bd689601554526d144b21d529f78a09
Author: Feng Tang <feng.tang@intel.com>
Date:   Fri Sep 28 15:22:01 2012 +0800

    ACPI: EC: Add a quirk for CLEVO M720T/M730T laptop

commit a520d52e99b14ba7db135e916348f12f2a6e09be
Author: Feng Tang <feng.tang@intel.com>
Date:   Fri Sep 28 15:22:00 2012 +0800

    ACPI: EC: Make the GPE storm threshold a module parameter

Can you please check if reverting the second one helps?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
