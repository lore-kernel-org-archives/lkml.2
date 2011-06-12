Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab1FLNyL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 09:54:11 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:38288 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab1FLNyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 09:54:08 -0400
Date: Sun, 12 Jun 2011 15:53:48 +0200
From: Borislav Petkov <bp@amd64.org>
To: Avi Kivity <avi@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>, "Luck, Tony" <tony.luck@intel.com>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH 07/10] MCE: replace mce.c use of TIF_MCE_NOTIFY with
 user_return_notifier
Message-ID: <20110612135348.GA20439@aftab>
References: <4df13cae2729896ba5@agluck-desktop.sc.intel.com>
 <4DF478F5.6090507@redhat.com>
 <20110612102443.GA19060@aftab>
 <4DF4952F.5030808@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DF4952F.5030808@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 12, 2011 at 06:30:07AM -0400, Avi Kivity wrote:
> You're missing the flow.  The MCE handler calls irq_work_queue(), which 
> schedules a user return notifier, which does any needed processing in 
> task context.

Ah ok, this will obviate the need for atomic lists in the user return
notifier. This could work, yep.

Thanks for clarifying.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
