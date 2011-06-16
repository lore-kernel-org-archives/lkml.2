Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447Ab1FPJeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 05:34:19 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:63527 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756462Ab1FPJeG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 05:34:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=FATigzj5sB7KsO5rJKW3kNIgeUbSEgcJVGOZnt1wCiuF9+4smu/I3gJGHCwxT9Uz99
         mzOHW06X/9B1KDfdzCC5uEIb9IPyvNOQR6NAHa+EU4oup0t8BqojpC/YRcpUzRKibu76
         IVzfi3ygCbwhFV9iG481ruQTpdw2QbVXHKKbc=
MIME-Version: 1.0
In-Reply-To: <20110616092429.GA5484@infradead.org>
References: <1308153214.7566.6.camel@jaguar>
	<4DF8DE26.1070301@redhat.com>
	<BANLkTi=SHENDBHdtFY_7_qtfqJb_+qKJSw@mail.gmail.com>
	<BANLkTinMDz-sqaX0cyWEoLXt70dowxofvg@mail.gmail.com>
	<4DF92C80.3030106@codemonkey.ws>
	<7A30A509-47AA-4E72-ABF3-937005900F9D@suse.de>
	<4DF93010.1040006@codemonkey.ws>
	<4DF935C1.4020000@codemonkey.ws>
	<BANLkTikmUpF_fsZcpiuMzZQZa17U-cPQAw@mail.gmail.com>
	<BANLkTi=mS43KwRG13ROmZX+HmbrPMVgV=g@mail.gmail.com>
	<20110616092429.GA5484@infradead.org>
Date: Thu, 16 Jun 2011 12:34:04 +0300
X-Google-Sender-Auth: TVn9Osuv1v0phaCKsiSxsJ47ocw
Message-ID: <BANLkTinnSW=EEunCu_d51Mapiv=V03ncQw@mail.gmail.com>
Subject: Re: [ANNOUNCE] Native Linux KVM tool v2
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Anthony Liguori <anthony@codemonkey.ws>, Alexander Graf <agraf@suse.de>,
        Prasad Joshi <prasadjoshi124@gmail.com>, Avi Kivity <avi@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Sasha Levin <levinsasha928@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Asias He <asias.hejun@gmail.com>,
        Jens Axboe <jaxboe@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Thu, Jun 16, 2011 at 09:21:03AM +0300, Pekka Enberg wrote:
>> And btw, we use sync_file_range()

On Thu, Jun 16, 2011 at 12:24 PM, Christoph Hellwig <hch@infradead.org> wrote:
> Which doesn't help you at all.  sync_file_range is just a hint for VM
> writeback, but never commits filesystem metadata nor the physical
> disk's write cache.  In short it's a completely dangerous interface, and
> that is pretty well documented in the man page.

Doh - I didn't read it carefully enough and got hung up with:

    Therefore, unless the application is strictly performing overwrites of
    already-instantiated disk blocks, there are no guarantees that the data will
    be available after a crash.

without noticing that it obviously doesn't work with filesystems like
btrfs that do copy-on-write.

What's the right thing to do here? Is fdatasync() sufficient?

                        Pekka
