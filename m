Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635Ab1EXJ25 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 05:28:57 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:6818
	"EHLO AM1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755421Ab1EXJ24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 05:28:56 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zzbb2cK1432N98dKzz1202hzz8275dh8275chz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LLP0YC-02-0U0-02
X-M-MSG: 
Date: Tue, 24 May 2011 11:27:47 +0200
From: Robert Richter <robert.richter@amd.com>
To: Eric B Munson <emunson@mgebm.net>
CC: "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "paulus@samba.org" <paulus@samba.org>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] oprofile, powerpc: Handle events that raise an exception
 without overflowing
Message-ID: <20110524092747.GS20052@erda.amd.com>
References: <1306160560-5309-1-git-send-email-emunson@mgebm.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1306160560-5309-1-git-send-email-emunson@mgebm.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.05.11 10:22:40, Eric B Munson wrote:
> Commit 0837e3242c73566fc1c0196b4ec61779c25ffc93 fixes a situation on POWER7
> where events can roll back if a specualtive event doesn't actually complete.
> This can raise a performance monitor exception.  We need to catch this to ensure
> that we reset the PMC.  In all cases the PMC will be less than 256 cycles from
> overflow.
> 
> This patch lifts Anton's fix for the problem in perf and applies it to oprofile
> as well.
> 
> Signed-off-by: Eric B Munson <emunson@mgebm.net>
> Cc: <stable@kernel.org> # as far back as it applies cleanly
> ---
>  arch/powerpc/oprofile/op_model_power4.c |   24 +++++++++++++++++++++++-
>  1 files changed, 23 insertions(+), 1 deletions(-)

I applied the fix to oprofile/urgent.

Thanks Eric,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

