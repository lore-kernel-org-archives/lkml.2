Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966345Ab2CAP2H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 10:28:07 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:51271 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755512Ab2CAP2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 10:28:05 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jrnieder@gmail.com designates 10.182.0.48 as permitted sender) smtp.mail=jrnieder@gmail.com; dkim=pass header.i=jrnieder@gmail.com
Date: Thu, 1 Mar 2012 09:27:55 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Jim Green <student.northwestern@gmail.com>,
        Lin Ming <ming.m.lin@intel.com>, Bob Moore <robert.moore@intel.com>,
        Len Brown <len.brown@intel.com>, Arne Nordmark <nordmark@mech.kth.se>
Subject: Re: [PATCH 04/50] ACPICA: Fix to allow region arguments to reference
 other scopes
Message-ID: <20120301152754.GA3167@burratino>
References: <1326802902-21583-1-git-send-email-lenb@kernel.org>
 <8931d9ea78848b073bf299594f148b83abde4a5e.1326802229.git.len.brown@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8931d9ea78848b073bf299594f148b83abde4a5e.1326802229.git.len.brown@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Len Brown wrote[1]:

> From: Lin Ming <ming.m.lin@intel.com>
[...]
> http://www.acpica.org/bugzilla/show_bug.cgi?id=937
> http://marc.info/?l=linux-acpi&m=131636632718222&w=2
>
> ACPI Error: [RAMB] Namespace lookup failure, AE_NOT_FOUND (20110112/psargs-359)
> ACPI Exception: AE_NOT_FOUND, Could not execute arguments for [RAMW] (Region) (20110112/nsinit-349)
>
>     Scope (_SB)
>     {
>         Name (RAMB, 0xDF5A1018)
>         OperationRegion (\RAMW, SystemMemory, RAMB, 0x00010000)
>     }
>
> For above ASL code, we need to save scope node(\_SB) to lookup
> the argument node(\_SB.RAMB).
>
> Reported-by: Jim Green <student.northwestern@gmail.com>
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> Signed-off-by: Bob Moore <robert.moore@intel.com>
> Signed-off-by: Len Brown <len.brown@intel.com>

Arne Nordmark reports[2] that this patch, when applied to 3.2.5, fixes
a resume failure.  Thanks!

Would it be safe and useful to backport this fix to stable/longterm
kernels?  If so, which ones?

Jonathan

[1] commit 8931d9ea7884
[2] http://bugs.debian.org/661581
