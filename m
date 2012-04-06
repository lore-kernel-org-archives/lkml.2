Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920Ab2DFTtp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 15:49:45 -0400
Received: from mga06.intel.com ([134.134.136.21]:7035 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757764Ab2DFTtm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 15:49:42 -0400
MIME-Version: 1.0
In-Reply-To: <20120406191451.GA14211@kroah.com>
References: <20120406184346.21744.18004.stgit@dwillia2-linux.jf.intel.com>
	<20120406191451.GA14211@kroah.com>
Date: Fri, 6 Apr 2012 12:49:39 -0700
Message-ID: <CABE8wwuLjqF1um8eJMap+6f_L3_upJL1VkQrxRfHXn-6R1Kuwg@mail.gmail.com>
Subject: Re: [PATCH 0/6] rework quirks for the "kt" serial port
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        alan@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 6, 2012 at 12:14 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Fri, Apr 06, 2012 at 11:44:22AM -0700, Dan Williams wrote:
>> The kt serial port intermittently reports unreliable data in its IIR
>> register and needs to reset fifos to stay in sync with firmware when the
>> device is reset.
>>
>> The IIR fixes that went into 3.3 were not complete so patch 3 replaces
>> them with an explicit way to turn on UART_BUG_THRE (i.e. the "I don't
>> trust my iir" flag).
>>
>
> So the first 3 patches should go into 3.4 (and 3.3-stable) kernels,
> right?

Yes, since this fixes the workaround that went into 3.3 properly and
addresses a regression.

>> A new fix for resetting the fifos on device reset is patch 5.  Alan
>> asked to make this a new quirk rather than add more workarounds to the
>> core (patch 4).
>
> These can wait for 3.5?

I think they can wait especially because of the cross tree changes.

>> Patch 6 is an untested RFC / RFT from anyone that has a serial
>> suspend/resume use case with an 'init' quirk that has resources that
>> need de-allocation at 'exit'.
>
> And I'll hold off on this one entirely for now, right?

Yeah, if anyone runs into a similar problem with serial suspend /
resume they may want to take a look at this patch.  But for now I
don't have a valid test case for it.

--
Dan
