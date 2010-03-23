Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab0CWLkL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 07:40:11 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:62128 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab0CWLkJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 07:40:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=S/9qJ/5T63gWaQZkvjwlUuSwAMoouZV6G8j9zrzugkT5r0WyoQ1uVadNS1x6ELgs6J
         xnymLLd/n7Tem3t/b1TAHMiT01Ezp+AuTPhOEK26Cnpe6SMRf+llNWWgDMZTLx38gnHQ
         QQeISXvDbsO8RRkCN3swJWx5XgccCCuBpoBWg=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.01.1003222111070.5493@bogon.housecafe.de>
References: <1268258994.2183.14.camel@carter>
	 <ca2dc2821003102331x3d1a7a0fgadb63612e49f77db@mail.gmail.com>
	 <20100311083404.GG6896@zhen-devel.sh.intel.com>
	 <ca2dc2821003110754r65ab170at39a61fb11fa285e0@mail.gmail.com>
	 <20100319132723.118cc16a.akpm@linux-foundation.org>
	 <ca2dc2821003200604m7c8cdea4r64ab8c98e7ec8242@mail.gmail.com>
	 <20100321135836.GA11661@zhen-devel.sh.intel.com>
	 <ca2dc2821003210830h2025df79r477cca7d81ddd28d@mail.gmail.com>
	 <20100322205704.ac4cd9ae.akpm@linux-foundation.org>
	 <alpine.DEB.2.01.1003222111070.5493@bogon.housecafe.de>
Date: Tue, 23 Mar 2010 12:40:05 +0100
Message-ID: <ca2dc2821003230440w3d96612aja0d4e083d3cc8c02@mail.gmail.com>
Subject: Re: [PATCH] intel-agp.c: Fix crash when accessing nonexistent GTT 
	entries in i915
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Zhenyu Wang <zhenyuw@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, David.Woodhouse@intel.com,
       dwmw2@infradead.org, eric@anholt.net, ben@decadent.org.uk,
       gregkh@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 5:14 AM, Christian Kujau <lists@nerdbynature.de> wrote:
> On Mon, 22 Mar 2010 at 20:57, Andrew Morton wrote:
>> On Sun, 21 Mar 2010 16:30:20 +0100 Miguel Ojeda <miguel.ojeda.sandonis@gmail.com> wrote:
>> > I bisected in order to find the commit 5877960869333e42ebeb733e8d9d5630ff96d350.
>
> I believe this[0] is fc61901373987ad61851ed001fe971f3ee8d96a3 upstream:

Indeed. Also in

http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.32.y.git;a=commit;h=fc61901373987ad61851ed001fe971f3ee8d96a3

>
> --------
>  agp/intel-agp: Clear entire GTT on startup
>
>  Some BIOSes fail to initialise the GTT, which will cause DMA faults when
>  the IOMMU is enabled. We need to clear the whole thing to point at the
>  scratch page, not just the part that Linux is going to use.
>
>  Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
>  [anholt: Note that this may also help with stability in the presence of
>  driver bugs, by not drawing to memory we don't own]
>  Signed-off-by: Eric Anholt <eric@anholt.net>
> --------
>
> Christian.
>
> [0] http://github.com/pfactum/pf-kernel/commit/5877960869333e42ebeb733e8d9d5630ff96d350
> --
> BOFH excuse #384:
>
> it's an ID-10-T error
>
