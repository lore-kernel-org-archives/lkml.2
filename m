Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953Ab2B2NGk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 08:06:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754620Ab2B2NGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 08:06:38 -0500
Message-ID: <4F4E22B1.6020505@redhat.com>
Date: Wed, 29 Feb 2012 10:05:53 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] mce: Add a msg string to the MCE tracepoint
References: <1330445487-15020-1-git-send-email-bp@amd64.org> <1330445487-15020-2-git-send-email-bp@amd64.org> <4F4D7BF9.9070104@jp.fujitsu.com> <20120229101047.GA21224@aftab> <4F4E145E.4040901@redhat.com> <20120229121914.GD21224@aftab>
In-Reply-To: <20120229121914.GD21224@aftab>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 29-02-2012 09:19, Borislav Petkov escreveu:
> On Wed, Feb 29, 2012 at 09:04:46AM -0300, Mauro Carvalho Chehab wrote:
>> Not all information is packed in the record. The record packs only what it
>> is inside the MCE registers. However, for certain errors, it is needed to
>> parse other hardware registers to decode the error (for example, on Sandy
>> Bridge, the MCE registers don't contain the affected dimms).
> 
> If SB is not using MCA to report the error, it should use either a
> generic TP like the trace_hw_error() example I gave last week, or rather
> a TP which matches the hw registers of the reporting hardware scheme.

This is not what I said. On intel, both SB and Nehalem use MCA to report errors.
Older chipsets don't use MCA.

However, there's a fundamental difference between SB and Nehalem:

- on Nehalem, the MCE status register encodes not only the error message; it
  also encodes the DIMM that generated the  error. So, it is possible to 
  completely decode the error on userspace, using only the MCE registers.

- on SB, the MCE status register only has the error message. In order to get
  the DIMM location, the driver needs to parse the registers that describe
  how the DIMM's are organized (this is spread on dozens of PCI devices, and
  200+ registers), and how they're interlaced, in order to convert the error 
  address reported by the MCA into a DIMM location.

So, just storing the values of the MCE registers is not enough to completely
decode the error.

Regards,
Mauro


