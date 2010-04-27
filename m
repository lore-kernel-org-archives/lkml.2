Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab0D0RNR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 13:13:17 -0400
Received: from vms173007pub.verizon.net ([206.46.173.7]:14184 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114Ab0D0RNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 13:13:15 -0400
Date: Tue, 27 Apr 2010 13:12:49 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: linux-acpi@vger.kernel.org, rui.zhang@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: fix fan module removal when ACPI_PROCFS is disabled
In-reply-to: <1272385158-4080-1-git-send-email-cascardo@holoscopio.com>
Message-id: <alpine.LFD.2.00.1004271309190.4006@localhost.localdomain>
References: <1272385158-4080-1-git-send-email-cascardo@holoscopio.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When ACPI_PROCFS is disabled, /proc/acpi/fan/ directory is not created.
> So, it should not be removed during the module removal either.

Yes, this patch would make the #ifdefs consistent.
But it looks like remove_proc_entry() just silently does nothing
if the directory is not there, yes?

What I'd really like to see is a patch removing fan.c's proc code 
completely.  It was scheduld for removal in July 2008.

thanks,
Len Brown, Intel Open Source Technology Center
