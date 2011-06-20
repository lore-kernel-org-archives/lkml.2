Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab1FTHhW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 03:37:22 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:50077 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144Ab1FTHhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 03:37:19 -0400
Date: Mon, 20 Jun 2011 09:36:56 +0200
From: Borislav Petkov <bp@amd64.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH 1/8] x86, mce: stop calling del_timer_sync() from
 interrupt
Message-ID: <20110620073656.GC9070@aftab>
References: <4DFB1242.90404@jp.fujitsu.com>
 <4DFB1304.10604@jp.fujitsu.com>
 <20110617135634.GF18054@aftab>
 <4DFED0A4.1060002@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DFED0A4.1060002@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 12:46:28AM -0400, Hidetoshi Seto wrote:
> > You're adding the mce_available(..) check just to remove it in the next
> > patch. Since all those sysfs nodes are behind such a check, there's no
> > need for it here too.
> 
> Maybe it would be better to change the order of patches to make
> this fix after the removal of unnecessary mce_available().

Yes, and then don't add it to mce_timer_delete_all because this functionality is
guarded my mce_available() checks in the sysfs nodes init path.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
