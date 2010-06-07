Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab0FGRfz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 13:35:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46169 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288Ab0FGRfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 13:35:54 -0400
Message-ID: <4C0D2BFB.2090200@zytor.com>
Date: Mon, 07 Jun 2010 10:27:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Len Brown <len.brown@intel.com>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] [RFC] Save/restore MISC_ENABLE register
References: <201006071814.53583.linux@rainbow-software.org>
In-Reply-To: <201006071814.53583.linux@rainbow-software.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2010 09:14 AM, Ondrej Zary wrote:
> Save/restore MISC_ENABLE register on suspend/resume.
> This fixes OOPS (invalid opcode) on resume from STR on Asus P4P800-VM, which
> wakes up with MWAIT disabled.
> 
> Is this a correct thing to do? Is it OK on x86_64?

This MSR isn't available on all processors, and thus cannot be saved and
restored unconditionally like this.  On the save path, one can use
rdmsr_safe(); on the wakeup path it's not clear to me it is safe to do
so, so it would be better to save a presence flag on the save path and
conditionalize the write.

	-hpa
