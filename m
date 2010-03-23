Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab0CWKCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 06:02:51 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:47179 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572Ab0CWKCt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 06:02:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RpIznxex6gaE3N6yz7yNzp8j8Q1+I/PfbptMsKqxU/tKcZ0PS45633Nqtp/B7QKYoT
         RH1YFPCW+1tHG/YfROF87qk6fofLzL3oh9jebrO8bfKHFPUN9skfjniXTiNNOwDasZ5v
         yKOb+Wx1Re1Jaj5t2Yo/FFkIFAh2TA8e4K4zI=
MIME-Version: 1.0
In-Reply-To: <20100322205704.ac4cd9ae.akpm@linux-foundation.org>
References: <1268258994.2183.14.camel@carter>
	 <ca2dc2821003102331x3d1a7a0fgadb63612e49f77db@mail.gmail.com>
	 <20100311083404.GG6896@zhen-devel.sh.intel.com>
	 <ca2dc2821003110754r65ab170at39a61fb11fa285e0@mail.gmail.com>
	 <20100319132723.118cc16a.akpm@linux-foundation.org>
	 <ca2dc2821003200604m7c8cdea4r64ab8c98e7ec8242@mail.gmail.com>
	 <20100321135836.GA11661@zhen-devel.sh.intel.com>
	 <ca2dc2821003210830h2025df79r477cca7d81ddd28d@mail.gmail.com>
	 <20100322205704.ac4cd9ae.akpm@linux-foundation.org>
Date: Tue, 23 Mar 2010 11:02:45 +0100
Message-ID: <ca2dc2821003230302u5b746569u6796f8220f935dce@mail.gmail.com>
Subject: Re: [PATCH] intel-agp.c: Fix crash when accessing nonexistent GTT 
	entries in i915
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Zhenyu Wang <zhenyuw@linux.intel.com>, linux-kernel@vger.kernel.org,
       David.Woodhouse@intel.com, dwmw2@infradead.org, eric@anholt.net,
       ben@decadent.org.uk, gregkh@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 1:57 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Sun, 21 Mar 2010 16:30:20 +0100 Miguel Ojeda <miguel.ojeda.sandonis@gmail.com> wrote:
>
>> On Sun, Mar 21, 2010 at 2:58 PM, Zhenyu Wang <zhenyuw@linux.intel.com> wrote:
>> > On 2010.03.20 14:04:56 +0100, Miguel Ojeda wrote:
>> >> On Fri, Mar 19, 2010 at 9:27 PM, Andrew Morton
>> >> <akpm@linux-foundation.org> wrote:
>> >> > On Thu, 11 Mar 2010 16:54:26 +0100
>> >> > Miguel Ojeda <miguel.ojeda.sandonis@gmail.com> wrote:
>> >> >
>> >> >> Attached dmesg, lspci -vv, config and xorg.
>> >> >>
>> >> >> When the X server crashes, the kernel does not report anything
>> >> >
>> >> > This seems to have gone all quiet?
>> >>
>> >> It seems so, I was about to ping Zhenyu.
>> >
>> > Could you try recent X.org intel driver release? Your failure X log
>> > showed some pretty old UMS driver's render flush time out message,
>> > I think whose version never has been well tested with new kms/gem stuff.
>> >
>>
>> Sure. Debian Stable got version 2.3.
>>
>> >>
>> >> >
>> >> > As this was a 2.6.32->2.6.32.4 regression, I assume that it's also a
>> >> > 2.6.32->2.6.33 regression?
>> >>
>> >> Yep. All kernels I tested since 2.6.32.4 crash, including 2.6.32.10,
>> >> 2.6.33 and 2.6.34-rc1. See my original message for more details about
>> >> the crash.
>> >>
>> >
>> > Could you bisect? I doubt it's caused by David's patch, as if it is, you
>> > will have trouble at early agp init time, instead of current problem looks
>> > like something causing rendering hang..and I can't think of how mapping GTT
>> > to a scratch page could cause problem in case GTT bar is truely 256K.
>>
>> I bisected in order to find the commit 5877960869333e42ebeb733e8d9d5630ff96d350.
>
> I have no 5877960869333e42ebeb733e8d9d5630ff96d350 here.  This is why
> we ask that people always identify patches by both the hash and the
> full title..

Sorry, I thought that saying 2.6.32.x and the commit would be enough:.
This is the one I meant:

http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.32.y.git;a=commit;h=5877960869333e42ebeb733e8d9d5630ff96d350

>
>
>> I don't know if such commit is really the true problem (does not seem
>> so if you are right); however, it is the commit that breaks the X
>> server as I stated in the original message.
>
>
