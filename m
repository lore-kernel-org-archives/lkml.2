Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965717Ab2KAU2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 16:28:53 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:40040 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964942Ab2KAU2u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 16:28:50 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH] xhci: fix null-pointer dereference when destroying half-built segment rings
From: Julius Werner <jwerner@google.com>
In-Reply-To: <20121101201552.GA9472@xanatos>
Date: Thu, 1 Nov 2012 13:28:46 -0700
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
        Julius Werner <jwerner@chromium.org>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vincent Palatin <vpalatin@chromium.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <95F2AD07-450E-422C-AB0B-9DFC4734CA1C@google.com>
References: <20121101175217.GJ29270@xanatos> <1351799279-23824-1-git-send-email-jwerner@chromium.org> <CAHp75VfqYNMxxDKKvHOVOdtf0+ZkC_N3Zfy0Ahb0nNdG4Xh9xA@mail.gmail.com> <20121101201552.GA9472@xanatos>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
X-Mailer: Apple Mail (2.1499)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Is it just
>> for (prev = *first; prev; prev = prev->next)
>>    xhci_segment_free(xhci, prev);
>> 
>> ?
> 
> Yeah, that seems cleaner.
> 
> Sarah Sharp

I can submit it that way if you want, but I would advise against it. This way you access the prev pointer after it has been freed already… that's probably not a problem in the current kernel, but it depends on how the underlying memory is managed and is generally just not a good idea in my opinion.