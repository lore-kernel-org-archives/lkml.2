Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab1FLWjC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 18:39:02 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:57543 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218Ab1FLWi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 18:38:59 -0400
Date: Mon, 13 Jun 2011 00:38:40 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 08/10] NOTIFIER: Take over TIF_MCE_NOTIFY and implement
 task return notifier
Message-ID: <20110612223840.GA23218@aftab>
References: <4df13a522720782e51@agluck-desktop.sc.intel.com>
 <4df13cea27302b7ccf@agluck-desktop.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4df13cea27302b7ccf@agluck-desktop.sc.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 09, 2011 at 05:36:42PM -0400, Luck, Tony wrote:
> From: Tony Luck <tony.luck@intel.com>
> 
> Existing user return notifier mechanism is designed to catch a specific
> cpu just as it returns to run any task in user mode.  We also need a
> machanism to catch a specific task.

Why do we need that? I mean, in the remaining patches we end up either
running memory_failure() or sending signals to a task. Can't we do it
all in the user return notifier and not have a different notifier for
each policy?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
