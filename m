Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093Ab0FKRns (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 13:43:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58617 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755744Ab0FKRnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 13:43:47 -0400
Message-ID: <4C1275BF.3070605@zytor.com>
Date: Fri, 11 Jun 2010 10:43:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org
Subject: Re: [PATCH 2/4] x86: ioremap: fix physical address check
References: <4C11FF10.4060203@jp.fujitsu.com> <4C11FFC0.1030006@jp.fujitsu.com>
In-Reply-To: <4C11FFC0.1030006@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2010 02:20 AM, Kenji Kaneshige wrote:
> If the physical address is too high to be handled by ioremap() in
> x86_32 PAE (e.g. more than 36-bit physical address), ioremap() must
> return error (NULL). However, current x86 ioremap try to map this too
> high physical address, and it causes unexpected behavior.

What unexpected behavior?  It is perfectly legitimately to map such a
high address in PAE mode.  We have a 36-bit kernel-imposed limit on
*RAM* in 32-bit mode (because we can't manage more than that), but there
is no reason it should apply to I/O.

	-hpa
