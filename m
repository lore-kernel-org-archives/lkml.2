Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab1HRN5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 09:57:31 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:58744 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204Ab1HRN5V convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:4:1>);
	Thu, 18 Aug 2011 09:57:21 -0400
Message-Id: <4E4D36980200007800051D6E@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 18 Aug 2011 14:58:16 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Tejun Heo" <tj@kernel.org>
Cc: <mingo@elte.hu>, <stable@kernel.org>, <tglx@linutronix.de>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] i386/bigsmp: eliminate false warnings regarding
	 logical APIC ID mismatches
References: <4E4D27B40200007800051D40@nat28.tlf.novell.com>
 <20110818130424.GC20085@htj.dyndns.org>
In-Reply-To: <20110818130424.GC20085@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 18.08.11 at 15:04, Tejun Heo <tj@kernel.org> wrote:
> On Thu, Aug 18, 2011 at 01:54:44PM +0100, Jan Beulich wrote:
>> Fix this (for the time being, i.e. until x86_32_early_logical_apicid()
>> will get removed again, as Tehun says ought to be possible) by
>> overriding the previously stored values at the point where the APIC
>> driver gets overridden.
> 
> Hmmm... how about just removing the WARN_ON() in setup_local_APIC()?
> We already don't depend on the value so just overriding it isn't
> dangerous at all.

I was not able to prove for myself that all of the uses of
early_per_cpu(x86_cpu_to_logical_apicid, ...) are actually only
possible to be hit after setup_local_APIC(), so I can't really
propose a patch like this.

Jan

