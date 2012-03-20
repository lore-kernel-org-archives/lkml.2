Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362Ab2CTVcO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 17:32:14 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:50940
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932195Ab2CTVcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 17:32:12 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2dI9371I103dK1432N98dKzz1202hzzz2fh668h839h93fhd25h)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4F68F748.7010304@am.sony.com>
Date: Tue, 20 Mar 2012 14:31:52 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: "kgdb-bugreport@lists.sourceforge.net" 
	<kgdb-bugreport@lists.sourceforge.net>,
        linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kdb:  Avoid using dbg_io_ops until it is initialized
References: <4E7A46C0.6010804@am.sony.com> <4F68CF7E.8070605@windriver.com>
In-Reply-To: <4F68CF7E.8070605@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2012 11:42 AM, Jason Wessel wrote:
> On 09/21/2011 03:19 PM, Tim Bird wrote:
>> This fixes a bug with setting a breakpoint during kdb initialization
>> (from kdb_cmds). Any call to kdb_printf() before the initialization
>> of the kgdboc serial console driver (which happens much later during
>> bootup than kdb_init), results in kernel panic due to the use of
>> dbg_io_ops before it is initialized.
> 
> I added this patch to the merge queue for the 3.4 kernel.
> 
> In the test and review of this patch, I thought there might be another
> race condition with kdb pager, but this is not the case.  The run time
> validation shows that the kdb pager can only get activated by entering
> and configuring the kdb shell and it is turned off on exit, so we are
> all set and no further changes are needed.

Thanks!
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Workgroup of the Linux Foundation
Senior Staff Engineer, Sony Network Entertainment
=============================

