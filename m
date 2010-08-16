Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145Ab0HPTiO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 15:38:14 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38489 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756379Ab0HPTiI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 15:38:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=uNrkoncQZpgjnr5DTYAAxJ4k0GXsgQOlzxZEhXI0nWqaa3KJbCaqVdFHjHOiZoOjPv
         Du8jgJe7aW80RYtR85BCknkyIqtHKhCIvcYU952XIhoEP5Ism4QapG0m1NKXTUujlWef
         m7V9xys0gIy7dIQG7N+z358OEroT9QVS/v0nE=
MIME-Version: 1.0
In-Reply-To: <AANLkTik_2MKMhOuDGOmu8Kzyq-ipLe+Bxrb3FaD+Tv4U@mail.gmail.com>
References: <cover.1281956490.git.richard.cochran@omicron.at>
	<363bd749a38d0b785d8431e591bf54c38db4c2d7.1281956490.git.richard.cochran@omicron.at>
	<AANLkTik_2MKMhOuDGOmu8Kzyq-ipLe+Bxrb3FaD+Tv4U@mail.gmail.com>
Date: Mon, 16 Aug 2010 12:38:06 -0700
X-Google-Sender-Auth: wtqN5_mLFPzmobSvdYqxg22Jvvo
Message-ID: <AANLkTikb3HxRSjfnDbDr3DbOJcAONahkdTiNAngoGGnk@mail.gmail.com>
Subject: Re: [PATCH 1/5] ptp: Added a brand new class driver for ptp clocks.
From: john stultz <johnstul@us.ibm.com>
To: Richard Cochran <richardcochran@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, Krzysztof Halasa <khc@pm.waw.pl>,
        Rodolfo Giometti <giometti@linux.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 12:24 PM, john stultz <johnstul@us.ibm.com> wrote:
> On Mon, Aug 16, 2010 at 4:17 AM, Richard Cochran
> A few comments below....
>
>> +** PTP user space API
>> +
>> +   The class driver creates a character device for each registered PTP
>> +   clock. User space programs may control the clock using standardized
>> +   ioctls. A program may query, enable, configure, and disable the
>> +   ancillary clock features. User space can receive time stamped
>> +   events via blocking read() and poll(). One shot and periodic
>> +   signals may be configured via an ioctl API with semantics similar
>> +   to the POSIX timer_settime() system call.
>
> As I mentioned earlier, I'm not a huge fan of the char device
> interface for abstracted PTP clocks.
> If it was just the direct hardware access, similar to RTC, which user
> apps then use as a timesource, I'd not have much of a problem. But as
> I mentioned in an earlier private mail, the abstraction level concerns
> me.

[snip]

> 2) As Arnd already mentioned, the chardev interface seems to duplicate
> the clock_gettime/settime() and adjtimex() interfaces.

And maybe just to clarify, as I saw your response to Arnd, I'm not
suggesting using PTP clocks as clocksources for the internal
timekeeping core. Instead I'm trying to understand why PTP clocks need
the equivalent of the existing posix clocks/timer interface. Why would
only having a read-time interface not suffice?

thanks
-john
