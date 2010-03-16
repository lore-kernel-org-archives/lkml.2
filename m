Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935630Ab0CPF6s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 01:58:48 -0400
Received: from smtp137.mail.ukl.yahoo.com ([77.238.184.68]:20258 "HELO
	smtp137.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S935356Ab0CPF6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 01:58:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.es;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=Z6rtIHL9Dp13oUr1ikwUKLSc8NK6E2VocMcZdeiHd60XFVIRmYvBflAJglP2jvIbeULJGTRcxCV0L84EDSXWW5vFyYyqmGMO4YK4p9de5KK1LSwCDD0pFQirXR/KTbBv6Rm7Ib5Pxrnj/ZeNPdfvvGZ7m+/s1luivFCBWzyKCkM=  ;
X-Yahoo-SMTP: czee06uswBAtfIYshc.kP27UlfEXaxwWNSjJ
X-YMail-OSG: hGdzDPgVM1mLH6Mcuc5K_XSS3wCZMP52BE5jJzIKHiB1Bb.BzSl7CpWxR.umLDqGIwyWty1XWZxYv9bKvaamV_QSB6s029utbDyldboz7fwnzHaHu9vCEIA6rlkiu7_JIy97wwAZ.yhY.54TJFuYYM6k6kDy3OLCYq_o5REmE1lrYI86aHZZuP3IFpJwETrhjt8w.Fm02vpTVGmaLnBRkmdWAPakuvBokka1eqtISM81yb_ioWS0yJWLms_JmY1kXzBJ3SlnZFgqVGZSHd3QgiYwzTtnrtAsGw--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4B9F1E11.80201@yahoo.es>
Date: Tue, 16 Mar 2010 06:58:41 +0100
From: Albert Herranz <albert_herranz@yahoo.es>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: linux-usb@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
       linux-kernel@vger.kernel.org, x86@kernel.org,
       linux-ia64@vger.kernel.org
Subject: Re: [PATCH v4 05/11] swiotlb: add swiotlb_set_default_size()
References: <1268421166-4791-1-git-send-email-albert_herranz@yahoo.es>	<1268421166-4791-6-git-send-email-albert_herranz@yahoo.es> <20100316104440Y.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100316104440Y.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> On Fri, 12 Mar 2010 20:12:40 +0100
> Albert Herranz <albert_herranz@yahoo.es> wrote:
> 
>> The current SWIOTLB code uses a default of 64MB for the IO TLB area.
>> This size can be influenced using a kernel command line parameter "swiotlb".
>> Unfortunately, the parsing of the kernel command line is done _after_ the
>> swiotlb is initialized on some architectures.
>>
>> This patch adds a new function swiotlb_set_default_size() which can be used
>> before swiotlb_init() to indicate the desired IO TLB area size in bytes.
>>
>> This will be used later to implement a smaller IO TLB on the Nintendo Wii
>> video game console which just comes with 24MB + 64MB of RAM.
>>
>> CC: linuxppc-dev@lists.ozlabs.org
>> CC: linux-kernel@vger.kernel.org
>> CC: x86@kernel.org
>> CC: linux-ia64@vger.kernel.org
>> Signed-off-by: Albert Herranz <albert_herranz@yahoo.es>
>> ---
>>  include/linux/swiotlb.h |    2 ++
>>  lib/swiotlb.c           |   20 ++++++++++++++++++++
>>  2 files changed, 22 insertions(+), 0 deletions(-)
> 
> Please fix the powerpc swiotlb initialization instead.
> 
> Calling swiotlb_init() before parsing kernel parameters sounds
> wrong. Any reasons why you can't fix it?
> 

I think that this would be better asked by a PowerPC maintainer. Ben?

If this is really a problem the swiotlb late init may be a solution too in this particular case.

Thanks,
Albert
