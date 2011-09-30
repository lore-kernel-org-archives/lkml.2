Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179Ab1I3Syc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 14:54:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37356 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754863Ab1I3Syb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 14:54:31 -0400
Message-ID: <4E86105B.3070901@zytor.com>
Date: Fri, 30 Sep 2011 11:54:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org, rientjes@google.com,
        James.Bottomley@HansenPartnership.com
Subject: Re: [RFC][PATCH 2/4] break out unit selection from string_get_size()
References: <20110930180241.D69D5E9C@kernel> <20110930180242.D89C1A59@kernel>
In-Reply-To: <20110930180242.D89C1A59@kernel>
X-Enigmail-Version: 1.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2011 11:02 AM, Dave Hansen wrote:
> string_get_size() can really only print things in a single
> format.  You're always stuck with a space, and it will
> always zero-pad the decimal places:
> 
> 	4.00 KiB
> 	40.0 KiB
> 	400 KiB
> 
> Printing page sizes in decimal KiB does not make much sense
> since they are always nice powers of two.  But,
> string_get_size() does have some nice code for selecting
> the right units and doing the division.
> 
> This breaks that nice code out so that we can reuse it.
> find_size_units() is a bit of a funky function since it has
> so many outputs.  I don't think it's _too_ crazy though.
> 
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>

For powers of two, wouldn't it make a lot more sense to just do ilog2()
to get the power of two and then the moral equivalent of:

	sprintf("%u %s", 1 << (pw2 % 10), units_str[pw2 / 10]);

	-hpa
