Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab2CXEly (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 00:41:54 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65324 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231Ab2CXEli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 00:41:38 -0400
MIME-Version: 1.0
In-Reply-To: <201203240226.35314.trenn@suse.de>
References: <1332512984-79664-1-git-send-email-trenn@suse.de>
	<CAE9FiQVFd=Zef2bH_3MinLEV_V+cEShrmRTe7Sr8HT2R46yHHw@mail.gmail.com>
	<201203240226.35314.trenn@suse.de>
Date: Fri, 23 Mar 2012 21:41:37 -0700
X-Google-Sender-Auth: Knl3zM65ine8RdRI6oxOpMHchlM
Message-ID: <CAE9FiQVxH4cSotaTOKrNe-W+EQEdg=r5AbUaejD3FtyY2bRCsQ@mail.gmail.com>
Subject: Re: [PATCH] ACPI: Implement overriding of arbitrary ACPI tables via initrd
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Renninger <trenn@suse.de>
Cc: eric.piel@tremplin-utc.net, vojcek@tlen.pl, dsdt@gaugusch.at,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, Lin Ming <ming.m.lin@intel.com>, lenb@kernel.org,
        robert.moore@intel.com, hpa@zytor.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 6:26 PM, Thomas Renninger <trenn@suse.de> wrote:
>> maybe could have dmi checking for more strict checking.
> I do not understand what should get checked?
> Hm, I guess you mean if a general table is always added that is distributed
> on different platforms and you want to white/blacklist machines to
> explicitly load/not load the table?
> This must not happen.
> The tables are always platform specific and you provide tables for
> a specific machine only for debugging purposes.
>
>> also would help if have one boot command that could skip overriding.
> Same. Both should not be needed.
>
> Or you have a use-case in mind I cannot not think of...

For known broken system,  could be old, or vendor does not want to
provide updated firmware anymore.
if the user could boot system with debug parameter
like "noapic maxcpus=1...."
then have user space util to extract acpi tables, and patch them and
repack them into initrd.
next boot will have system running with optimal ...

If we could do that, we could avoid or kill workaround and quirks in the kernel.

So we may need some strict check or skip when you are moving disk
around or update different bios later.

Thanks

Yinghai
