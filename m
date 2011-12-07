Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988Ab1LGLCc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 06:02:32 -0500
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:59735 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751973Ab1LGLCa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 06:02:30 -0500
MIME-Version: 1.0
In-Reply-To: <201112071011.03525.arnd@arndb.de>
References: <1322816252-19955-1-git-send-email-sumit.semwal@ti.com>
 <201112051718.48324.arnd@arndb.de> <CAB2ybb8-0_HupO95UUvLN9ovVxnU+uvn4UXbwqZLSFuC9MZs0w@mail.gmail.com>
 <201112071011.03525.arnd@arndb.de>
From: "Semwal, Sumit" <sumit.semwal@ti.com>
Date: Wed, 7 Dec 2011 16:32:08 +0530
Message-ID: <CAB2ybb9yiHLzB9iW_EhBvEkvo3n82phkfS+d1J7yXi+ZZt=kDw@mail.gmail.com>
Subject: Re: [RFC v2 1/2] dma-buf: Introduce dma buffer sharing mechanism
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux@arm.linux.org.uk, jesse.barker@linaro.org,
        m.szyprowski@samsung.com, rob@ti.com, daniel@ffwll.ch,
        t.stanislaws@samsung.com, Sumit Semwal <sumit.semwal@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 7, 2011 at 3:41 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 07 December 2011, Semwal, Sumit wrote:
>> >
>> > Do you have a use case for making the interface compile-time disabled?
>> > I had assumed that any code using it would make no sense if it's not
>> > available so you don't actually need this.
>>
>> Ok. Though if we keep the interface compile-time disabled, the users
>> can actually check and fail or fall-back gracefully when the API is
>> not available; If I remove it, anyways the users would need to do the
>> same compile time check whether API is available or not, right?
>
> If you have to do a compile-time check for the config symbol, it's better
> to do it the way you did here than in the caller.
>
> My guess was that no caller would actually require this, because when you
> write a part of a subsystem to interact with the dma-buf infrastructure,
> you would always disable compilation of an extire file that deals with
> everything related to struct dma_buf, not just stub out the calls.

Right; that would be ideal, but we may not be able to ask each user to
do so - especially when the sharing part might be interspersed in
existing buffer handling code. So for now, I would like to keep it as
it-is.
>
>        Arnd
>
BR,
~Sumit.
> --
