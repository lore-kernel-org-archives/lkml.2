Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964881Ab2KOKnj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 05:43:39 -0500
Received: from us01smtp2.synopsys.com ([198.182.44.80]:39137 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964838Ab2KOKnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 05:43:37 -0500
Message-ID: <50A4C6B5.9010500@synopsys.com>
Date: Thu, 15 Nov 2012 16:10:53 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tglx@linutronix.de>
Subject: Re: [RFC Patch v1 38/55] ARC: Low level event capture/logging
References: <1352720953-24321-1-git-send-email-vgupta@synopsys.com> <1352720953-24321-8-git-send-email-vgupta@synopsys.com> <201211121355.23947.arnd@arndb.de>
In-Reply-To: <201211121355.23947.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 November 2012 07:25 PM, Arnd Bergmann wrote:
> On Monday 12 November 2012, Vineet.Gupta1@synopsys.com wrote:
>> +EXPORT_SYMBOL(take_snap);
>> +
>> ...
>> +EXPORT_SYMBOL(take_snap2);
> Where are these functions called?

These are called from various parts of ARCH code, such as before
handling signal or TLB flush etc.

> Shouldn't this all just be part of the perf module?

These are for low level ARCH specific event snapshotting. Maybe
perf/ftrace already have some of these in the generic code which
eventually call the ARCH APIs. Our current perf support is just husk of
an implementation. Once we have the full perf / ftrace support this
module - except for the even t capture part could just go away.
OTOH, I've not seen much usage of this from loadable modules - so if you
deem correct, I can even remove the export.

> If not, can you make the exports GPL-only?

Am I right in understanding that this is more related to discouraging
non GPL modules "in general" than having to do with port itself.

>
> 	Arnd

