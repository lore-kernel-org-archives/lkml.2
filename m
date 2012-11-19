Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab2KSK7t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 05:59:49 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42909 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab2KSK7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 05:59:48 -0500
Message-ID: <50AA1140.70103@linaro.org>
Date: Mon, 19 Nov 2012 16:30:16 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "patches@linaro.org" <patches@linaro.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] [PATCH 09/14] xen: events: Remove redundant check
 on unsigned variable
References: <1353048646-10935-1-git-send-email-tushar.behera@linaro.org>  <1353048646-10935-10-git-send-email-tushar.behera@linaro.org>  <20121116160923.GP22320@phenom.dumpdata.com>  <b0cd27cf-919f-46b0-afa1-4566f6ea0f61@email.android.com>  <50A9AD05.5080201@linaro.org> <1353321075.18229.29.camel@zakaz.uk.xensource.com>
In-Reply-To: <1353321075.18229.29.camel@zakaz.uk.xensource.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2012 04:01 PM, Ian Campbell wrote:
> On Mon, 2012-11-19 at 03:52 +0000, Tushar Behera wrote:
>> On 11/16/2012 10:23 PM, Jeremy Fitzhardinge wrote:
>>> To be honest I'd nack this kind of patch. The test is only redundant in the most trivial sense that the compiler can easily optimise away. The point of the test is to make sure that the range is OK even if the type subsequently becomes signed (to hold a -ve error, for example).
>>>
>>> J
>>>
>>
>> The check is on the function argument which is unsigned, so checking '<
>> 0' doesn't make sense. We should force signed check only if the argument
>> is of signed type. In any case, even if irq has been assigned some error
>> value, that would be caught by the check irq >= nr_irqs.
> 
> Jeremy is (I think) arguing that this check is not redundant because
> someone might change the type of the argument to be signed and until
> then the compiler can trivially optimise the check away, so what's the
> harm in it?
> 
> I'm somewhat inclined to agree with him.
> 
> Ian.
> 
Ok, I don't have much argument against this.

-- 
Tushar Behera
