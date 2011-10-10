Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab1JJSl6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 14:41:58 -0400
Received: from unicorn.mansr.com ([78.86.181.103]:37849 "EHLO
	unicorn.mansr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219Ab1JJSl5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 14:41:57 -0400
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Greg KH <gregkh@suse.de>
Cc: Mikael Pettersson <mikpe@it.uu.se>,
        =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
        Nicolas Pitre <nico@fluxnic.net>, linux-usb@vger.kernel.org,
        Harro Haan <hrhaan@gmail.com>, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Lennert Buytenhek <kernel@wantstofly.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] fix ehci alignment error
References: <20111010124154.464239811@gmail.com>
	<20111010141402.GA21856@suse.de> <yw1xipnwzu7a.fsf@unicorn.mansr.com>
	<20111010170042.GB24166@suse.de>
	<20115.11246.991917.639835@pilspetsen.it.uu.se>
	<20111010173845.GB25114@suse.de>
Date: Mon, 10 Oct 2011 19:41:55 +0100
In-Reply-To: <20111010173845.GB25114@suse.de> (Greg KH's message of "Mon, 10
	Oct 2011 10:38:45 -0700")
Message-ID: <yw1x4nzgzo24.fsf@unicorn.mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> writes:

> On Mon, Oct 10, 2011 at 07:31:26PM +0200, Mikael Pettersson wrote:
>> Greg KH writes:
>>  > On Mon, Oct 10, 2011 at 05:29:13PM +0100, Måns Rullgård wrote:
>>  > > Greg KH <gregkh@suse.de> writes:
>>  > > 
>>  > > > On Mon, Oct 10, 2011 at 02:38:27PM +0200, Harro Haan wrote:
>>  > > >> The Kirkwood gave an unaligned memory access error on
>>  > > >> line 742 of drivers/usb/host/echi-hcd.c:
>>  > > >> "ehci->last_periodic_enable = ktime_get_real();"
>>  > > >
>>  > > > What is "The Kirkwood"?  What size processor is this?
>>  > > 
>>  > > It's an ARM926-like CPU from Marvell.
>>  > 
>>  > 32 or 64bit?
>> 
>> All ARMs are 32-bit, but some have instructions for loading or
>> storing 2 x 32 bits at a time, but also require the corresponding
>> memory address to be 64-bit aligned.

To be perfectly accurate, all ARMs have the dual load/store instructions,
but only some (ARMv5 and earlier) require a 64-bit aligned address for
these.  The Kirkwood is an ARMv5 so it does need this alignment.

Furthermore, the standard ARM ABI requires 8-byte alignment for 64-bit
data types regardless of CPU version, which is perhaps a bit unusual for
a 32-bit architecture.

-- 
Måns Rullgård
mans@mansr.com
