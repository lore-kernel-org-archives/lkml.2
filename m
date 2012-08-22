Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933166Ab2HVQzX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 12:55:23 -0400
Received: from mga05.intel.com ([192.55.52.89]:57640 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932992Ab2HVQzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 12:55:19 -0400
MIME-Version: 1.0
In-Reply-To: <87628e5kve.fsf@rustcorp.com.au>
References: <cover.1345055638.git.dmitry.kasatkin@intel.com>
	<f5c7c0f9ef113263bf17c39e9b7927f085872107.1345055639.git.dmitry.kasatkin@intel.com>
	<87628e5kve.fsf@rustcorp.com.au>
Date: Wed, 22 Aug 2012 19:38:59 +0300
Message-ID: <CALLzPKZhDg0b7XF7A_MH1gtXafe2OfKr=c5hH-KGM7J_oXXCrQ@mail.gmail.com>
Subject: Re: [RFC v2 1/7] integrity: added digest calculation function
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: zohar@linux.vnet.ibm.com, jmorris@namei.org, dhowells@redhat.com,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 5:59 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Wed, 15 Aug 2012 21:43:06 +0300, Dmitry Kasatkin <dmitry.kasatkin@intel.com> wrote:
>> +     } else {
>> +             struct {
>> +                     struct shash_desc shash;
>> +                     char ctx[crypto_shash_descsize(tfm)];
>> +             } desc;
>
> Linus had a rant a while ago about using variable-sized stack vars in
> the kernel (can't find a reference right now, sorry).
>
> The problem is that either you know there's a limit to
> crypto_shash_descsize(), in which case you can just use this here, or
> you don't know, in which case, this risks a stack oveflow.
>
> Cheers,
> Rusty.

Well... descriptor size is a algo specific but constant... just
sizeof(some struct).
So there is no possibility to force overflow unless someone implement
some algo driver which
uses too big descriptor size.

- Dmitry
