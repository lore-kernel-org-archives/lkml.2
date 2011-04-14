Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab1DNXCY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 19:02:24 -0400
Received: from smtp-out.google.com ([216.239.44.51]:6522 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364Ab1DNXCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 19:02:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=s54j+07SsyaeKr+pp/YVaynd0IFCgWAfGvi0Wd8Hcz1Q+l9YO7XySSw7cl0fcyaWvq
         JsJdiwQKXWoOG5tDOnSA==
MIME-Version: 1.0
In-Reply-To: <4D9DFB08.8090206@codeaurora.org>
References: <1302131890-20953-1-git-send-email-sjg@chromium.org>
	<4D9DFB08.8090206@codeaurora.org>
Date: Thu, 14 Apr 2011 16:02:17 -0700
X-Google-Sender-Auth: AsvU628wVHn4RdMaif0peuL0hzg
Message-ID: <BANLkTikRDowxG+q5tnhCCsCWCQEk-thqGg@mail.gmail.com>
Subject: Re: [PATCH v3] ARM: Use generic BUG() handler
From: Simon Glass <sjg@chromium.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Joe Perches <joe@perches.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Alexander Shishkin <virtuoso@slind.org>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>,
        Rabin Vincent <rabin@rab.in>, linux-kernel@vger.kernel.org,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        Dave Martin <dave.martin@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 7, 2011 at 10:57 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 04/06/2011 04:18 PM, Simon Glass wrote:
>> From: Simon Glass <sjg@google.com>
>>
>> ARM uses its own BUG() handler which makes its output slightly different
>> from other archtectures.
>>
> [snip]
>>
> Also, have you tried this with a module? I think you would at least need
> to modify arch/arm/kernel/module.c to hook up the module_bug_finalize()
> and module_bug_cleanup() stuff.

Actually this just works, except that I need to allow the PC to be
below PAGE_OFFSET where modules are loaded. This is a benefit of using
generic Linux code.

I have sent a new version of the patch to review.

Regards,
Simon
