Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510Ab1K3SoC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 13:44:02 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:56229 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895Ab1K3SoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 13:44:00 -0500
Message-ID: <1322678599.2414.1.camel@js-netbook>
Subject: Re: clocksource.c "margin"
From: John Stultz <johnstul@us.ibm.com>
To: "Yang Honggang(Joseph)" <ganggexiongqi@gmail.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 30 Nov 2011 10:43:19 -0800
In-Reply-To: <4ED6C5CE.2030105@gmail.com>
References: <4ED6C5CE.2030105@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11113018-5930-0000-0000-000002C1C896
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-30 at 19:09 -0500, Yang Honggang(Joseph) wrote:
> Hi John Stultz,
> I'm very sorry to trouble you. A problem puzzled me when I reading your 
> code in kernel/time/clocksource.c.
> In the following functions, your said in the comments that >>5 was used 
> to leave a margin of 12.5%.
> I don't know how to get the result. I think is should be >> 3 in order 
> to leave a margin of 12.5%.
> The operation of >> 5 only left 3.125% margin.
> 
> __clocksource_updatefreq_scale
> ...
> sec = (cs->mask - (cs->mask >> 5));
> ...
> clocksource_max_deferment
> ...
>      /*
>       * To ensure that the clocksource does not wrap whilst we are idle,
>       * limit the time the clocksource can be deferred by 12.5%. Please
>       * note a margin of 12.5% is used because this can be computed with
>       * a shift, versus say 10% which would require division.
>       */
>      return max_nsecs - (max_nsecs >> 5);
> ...

Indeed. This looks wrong.

Would you like to send a patch in correcting this issue? If not, let me
know and I'll do so.

thanks
-john


