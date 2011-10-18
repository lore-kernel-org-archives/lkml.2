Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861Ab1JRNgE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 09:36:04 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63072 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265Ab1JRNgC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 09:36:02 -0400
MIME-Version: 1.0
In-Reply-To: <20111018130843.170b71b2@lxorguk.ukuu.org.uk>
References: <20110705141038.23872.55303.stgit@localhost.localdomain>
	<20110705144140.23872.86541.stgit@localhost.localdomain>
	<alpine.LSU.2.00.1107071742250.10362@sister.anvils>
	<20110708093859.299958df@lxorguk.ukuu.org.uk>
	<alpine.LSU.2.00.1107080917430.1781@sister.anvils>
	<20110711172517.46907e62@lxorguk.ukuu.org.uk>
	<alpine.LSU.2.00.1107111033440.1752@sister.anvils>
	<CAMeQTsb7ZMbyt8avYNOiBssERmk6vEbg7RR6TQw7CaD55MK22A@mail.gmail.com>
	<alpine.LSU.2.00.1110101102330.21957@sister.anvils>
	<CAN_cFWNkYGSajh7eG1qK+A5tWSHNR2gH4EPiPg9tKd+yw8nRYQ@mail.gmail.com>
	<alpine.LSU.2.00.1110171031290.2545@sister.anvils>
	<20111017223928.4d5ed2c6@lxorguk.ukuu.org.uk>
	<alpine.LSU.2.00.1110171528520.6878@sister.anvils>
	<CAN_cFWP9jOGTPuoXQaXan_P1AKYrbvfLoB8hzG-YdCddfsu3Vw@mail.gmail.com>
	<20111018114518.5610a8c2@lxorguk.ukuu.org.uk>
	<CAN_cFWNKeD8sf-nmv9ZtVxKu1XMf3caNRKHtkzdq9zfSMig6-w@mail.gmail.com>
	<20111018130843.170b71b2@lxorguk.ukuu.org.uk>
Date: Tue, 18 Oct 2011 08:36:01 -0500
Message-ID: <CAN_cFWNKQxKnfZGd8zxvL_Z6J9h59rp-K5pe5f=s65zWJw9K0Q@mail.gmail.com>
Subject: Re: [PATCH 34/49] gma500: the GEM and GTT code is device independant
From: Rob Clark <rob.clark@linaro.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Hugh Dickins <hughd@google.com>,
        Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, greg@kroah.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 7:08 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Tue, 18 Oct 2011 06:59:28 -0500
> Rob Clark <rob.clark@linaro.org> wrote:
>
>> On Tue, Oct 18, 2011 at 5:45 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> >> What troubles could you see for swap+uncached (or more likely,
>> >> writecombine) pages?
>> >
>> > That should never occur. I would argue the driver is responsible for
>> > putting the cache state of the page back sensibly before it unpins it.
>> > That's a simple enough rule and one I think all the drivers follow at
>> > this point.
>>
>> no, what I'm trying to avoid is having two virtual mappings to the
>> same physical page with different cache attributes.  This is not
>> allowed on some architectures (like ARM)
>
> Nor x86... that's a matter for the core architecture code to deal with
> not the drivers.
>

hmm, maybe I'm missing something, but how is this ensured on x86?
Default drm_gem_mmap() maps pages to userspace as writecombine..  but
if page comes from kernel linear map (not highmem), that will be a
cached kernel virtual mapping in addition to the wc userspace mapping.

BR,
-R

> Alan
>
