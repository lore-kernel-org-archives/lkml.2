Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759294Ab2BJNlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 08:41:19 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:48760 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758799Ab2BJNlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 08:41:18 -0500
Date: Fri, 10 Feb 2012 14:41:15 +0100
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 01/31] events/hw_event: Create a Hardware Events
 Report Mecanism (HERM)
Message-ID: <20120210134115.GC16783@aftab>
References: <1328832090-9166-1-git-send-email-mchehab@redhat.com>
 <1328832090-9166-2-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328832090-9166-2-git-send-email-mchehab@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 09, 2012 at 10:01:00PM -0200, Mauro Carvalho Chehab wrote:
> In order to provide a proper hardware event subsystem, let's
> encapsulate hardware events into a common trace facility, and
> make both edac and mce drivers to use it. After that, common
> facilities can be moved into a new core for hardware events
> reporting subsystem. This patch is the first of a series, and just
> touches at mce.

I think it would work too if you had only one event:

* trace_hw_error(...)

which would have as an argument a string describing it, like
"Uncorrected Memory Read Error", "Memory Read Error (out of range)" "TLB
Multimatch Error" etc., followed by the rest of the error info.

Currently, you're introducing at least 5 trace_* calls _only_ for memory
errors. What about the remaining couples of tens of errors which haven't
been addressed yet?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
