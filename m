Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414Ab2EMKFs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 06:05:48 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:39657 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab2EMKFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 06:05:47 -0400
Date: Sun, 13 May 2012 12:05:32 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Chen Gong <gong.chen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH 2/2] x86/mce: Add instruction recovery signatures to
 mce-severity table
Message-ID: <20120513100532.GC28863@aftab.osrc.amd.com>
References: <cover.1336674796.git.tony.luck@intel.com>
 <0e89440bf6444635bde0b876eedd26e5c51f9ca3.1336674796.git.tony.luck@intel.com>
 <4FACC25B.80305@linux.intel.com>
 <3908561D78D1C84285E8C5FCA982C28F192ED617@ORSMSX104.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F192ED617@ORSMSX104.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 05:42:09PM +0000, Luck, Tony wrote:
> > For IFU, on affected logical processors, RIPV and EIPV both are 0,
> > since now new IFU entries are added into severity table, the old
> > entry as below should be removed:
> >
> > /* Neither return not error IP -- no chance to recover -> PANIC */
> >        MCESEV(
> >                PANIC, "Neither restart nor error IP",
> >                MCGMASK(MCG_STATUS_RIPV|MCG_STATUS_EIPV, 0)
> >                ),
> 
> We need to keep this. If EIPV is not set, then CS and IP on the
> stack are not guaranteed ... so we can't tell whether the error
> happened in user or kernel mode. This makes recovery "challenging".
> 
> I'm trying to figure out a quirk for processors that do generate
> EIPV=RIPV=0 signature for IFU errors. There are some case where
> we can work around the lack of EIPV.

__mcheck_cpu_apply_quirks?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
