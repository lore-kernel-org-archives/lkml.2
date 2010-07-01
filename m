Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab0GAW5H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:57:07 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50184 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab0GAW5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 18:57:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=eiL/e8narJ0kRxzwPa+fsTdG/lhkiMKE0ZKb8JOT5N9uvvgaBvp1xsnlVikUXT4/Wk
         UmHBkZaYhiuhi+/hqJ9NK/8KB3cW6EsIGDz66D6ARmciI2Ga/Hnmb0N7GXSKU5Ef5jrz
         ZBFuLwDu9zGt13jnujSicADXg19N/GbFT7Tns=
MIME-Version: 1.0
In-Reply-To: <1278024678.7738.54.camel@c-dwalke-linux.qualcomm.com>
References: <AANLkTikfYwkxF5CXgt-fGMIYTlcmt99lOz_VyA3Kr-4R@mail.gmail.com>
	<AANLkTimgH-DiQyg0f-an5FS3Wyb2b6He3fxxB1L8Ziol@mail.gmail.com>
	<1278024678.7738.54.camel@c-dwalke-linux.qualcomm.com>
Date: Fri, 2 Jul 2010 08:57:02 +1000
Message-ID: <AANLkTinNrpcBg0TXTS78qaI5kPQKD-IbnLpDStu4_BIg@mail.gmail.com>
Subject: Re: Closed source userspace graphics drivers with an open source 
	kernel component
From: Dave Airlie <airlied@gmail.com>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 2, 2010 at 8:51 AM, Daniel Walker <dwalker@codeaurora.org> wrote:
> On Fri, 2010-07-02 at 08:36 +1000, Dave Airlie wrote:
>> On Fri, Jul 2, 2010 at 8:10 AM, Dave Airlie <airlied@gmail.com> wrote:
>> > Now this is just my opinion as maintainer of the drm, and doesn't
>> > reflect anyone or any official policy, I've also no idea if Linus
>> > agrees or not.
>> >
>> > We are going to start to see a number of companies in the embedded
>> > space submitting 3D drivers for mobile devices to the kernel. I'd like
>> > to clarify my position once so they don't all come asking the same
>> > questions.
>> >
>> > If you aren't going to create an open userspace driver (either MIT or
>> > LGPL) then don't waste time submitting a kernel driver to me.
>
> If , for whatever reason, you changed you mind on this what sort of
> connection between kernel and userspace would these components use?
>
> I ask only because I think UIO hold most (if not all) the driver in
> userspace .. So you would have to use some other interface if you wanted
> a more half and half solution ..
>

The thing is UIO doesn't solve the problem 3D graphics drivers need to
solve. Which is we need to let unprivileged users access the graphics
device in an efficient manner, hence why DRI/DRM exists. Now I think
the tegra guys have done some evil hacks with a userspace daemon to
replace the kernel functionality, so all they have in-kernel is a
framebuffer device, since they can't really get away with shipping the
binary nvidia driver linked to the kernel in a real device. So all
their userspace closed bits talk to the daemon running as root with
direct access to the lowlevel hw.

Dave.
