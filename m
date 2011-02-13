Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109Ab1BMVZP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 16:25:15 -0500
Received: from smtp-out.google.com ([216.239.44.51]:38423 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047Ab1BMVZK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 16:25:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Od+7j34vmilJMPQYYkSquym3jjnGPeli7FrKDxzziseyjgQvlNc7rSHdvy9HKhb6Gc
         Np/NixnDTvHq3Sy/qPcQ==
MIME-Version: 1.0
In-Reply-To: <AANLkTinYf3G+b8n6okeZk44xvO0xP0dw8S_dfE2C4E1-@mail.gmail.com>
References: <1297373487-23902-1-git-send-email-ccross@android.com>
	<1297373487-23902-4-git-send-email-ccross@android.com>
	<1297426345.17584.99.camel@e102109-lin.cambridge.arm.com>
	<AANLkTinYf3G+b8n6okeZk44xvO0xP0dw8S_dfE2C4E1-@mail.gmail.com>
Date: Sun, 13 Feb 2011 13:25:05 -0800
X-Google-Sender-Auth: zGpk07aiNHaY5BFJFAMM-EtSpsM
Message-ID: <AANLkTik=RgXyy-RR2aPy4bVeE5XjYTsiHO7OML3ZbU7S@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3] ARM: vfp: Use cpu pm notifiers to save vfp state
From: Colin Cross <ccross@android.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        santosh.shilimkar@ti.com, Will Deacon <Will.Deacon@arm.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11, 2011 at 11:50 AM, Colin Cross <ccross@android.com> wrote:
>> Something like below (untested):
>>
>>        if (last_VFP_context[cpu]) {
>>                vfp_save_state(last_VFP_context[cpu], fpexc);
>>                /* force a reload when coming back from idle */
>>                last_VFP_context[cpu] = NULL;
>>                fmxr(FPEXC, fpexc & ~FPEXC_EN);
>>        }
One more fix is necessary, the VFP will usually not be enabled when
this is called.  The VFP needs to be enabled before vfp_save_state,
and then disabled after.

>        /* save state for resumption */
>        if (last_VFP_context[ti->cpu]) {
>                printk(KERN_DEBUG "%s: saving vfp state\n", __func__);
>                vfp_save_state(last_VFP_context[ti->cpu], fpexc);
>
>                /* disable, just in case */
>                fmxr(FPEXC, fpexc & ~FPEXC_EN);
>        }
Same fix is needed here.
