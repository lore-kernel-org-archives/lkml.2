Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760953Ab2FDVW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 17:22:57 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:48664 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236Ab2FDVW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 17:22:56 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6732"; a="197613343"
Message-ID: <4FCD272E.1020300@codeaurora.org>
Date: Mon, 04 Jun 2012 14:22:54 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Fernando Guzman Lugo <fernando.lugo@ti.com>
Subject: Re: [PATCH 2/2] remoteproc: remove the now-redundant kref
References: <1338017791-9442-1-git-send-email-ohad@wizery.com> <1338017791-9442-2-git-send-email-ohad@wizery.com> <4FC5DD74.4030202@codeaurora.org> <CAK=WgbbwaMAnTGcivC9ZR8K-MtTqHAV3+BgUmk8WjCaayifJxw@mail.gmail.com>
In-Reply-To: <CAK=WgbbwaMAnTGcivC9ZR8K-MtTqHAV3+BgUmk8WjCaayifJxw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/12 05:38, Ohad Ben-Cohen wrote:
> On Wed, May 30, 2012 at 11:42 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>>> -     /* the rproc will only be released after its refcount drops to zero */
>>> -     kref_put(&rproc->refcount, rproc_release);
>>> +     /* unroll rproc_alloc. TODO: we may want to let the users do that */
>>> +     put_device(&rproc->dev);
>> Yes I think we want rproc_free() to actually call put_device() the last
>> time and free the resources.
> Yeah that was one of the options I considered.
>
> In general, we have three options here:
> 1. Remove this last put_device invocation, and require users to call
> rproc_free() even after they call rproc_unregister().
> 2. Let rproc_unregister() still do this, by calling rproc_free().
> 3. Let rproc_unregister() still do this, by invoking put_device().
>
> I think that (1) looks better since it makes the interface symmetric
> and straight forward.
>
> (2) and (3) may be simper because users only need to call
> rproc_unregister and that's it.
>
> I eventually decided against (1) because I was concerned it will only
> confuse users at this point.
>
> But if you think that (1) is nicer too then maybe we should go ahead
> and do that change.

Option 1 is nicer and it also follows the model other subsystems have
put forth such as the input subsystem.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

