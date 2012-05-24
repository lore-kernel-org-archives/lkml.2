Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124Ab2EXEpo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 00:45:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44719 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab2EXEpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 00:45:41 -0400
Date: Wed, 23 May 2012 21:45:39 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: ethan zhao <ethan.kernel@gmail.com>
cc: linux-kernel@vger.kernel.org, Kurt Garloff <kurt@garloff.de>,
        Len Brown <len.brown@intel.com>
Subject: Re: ACPI and NUMA guys, please help to check if this patch is OK
In-Reply-To: <CABawtvM-ZzFvT3LLb5V2bm52odeSyxeQwwvbVXgrNcMX5WMrbQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1205232142120.10366@chino.kir.corp.google.com>
References: <CABawtvNSYENtrJTaB5Vfd+j5MahE=xv4Ueb6-zmd1CHShuU0iQ@mail.gmail.com> <alpine.DEB.2.00.1205222029590.28165@chino.kir.corp.google.com> <CABawtvM-ZzFvT3LLb5V2bm52odeSyxeQwwvbVXgrNcMX5WMrbQ@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2012, ethan zhao wrote:

> David,
>     What we can do to help improving Linux OS is only about fatal
> error ? Can I do something to give more clear warning information and
> easy to find the root cause ?
> 

The warning you already quoted in your changelog is sufficient warning 
that the SLIT is bad and it suppresses setting that distance.  Your 
change, however, completely invalidates the SRAT if the number of 
localities does not match the number of pxms.  We'd much rather simply 
suppress the bad distance rather than invalidate the SRAT, especially 
considering there is nothing in the ACPI spec that requires it.
