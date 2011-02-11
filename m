Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599Ab1BKM4C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 07:56:02 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53930 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174Ab1BKM4A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 07:56:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=fuhFrnvSR3nx1VRzpnoYau5tgapWQI7Sw8nZle14xtgh7CptZCuN6S3d72lHcl/msh
         86RHLMmvnVPdDGyWV3lMVx4CaX3e8o5C9aOJtR4YFvGVdLe9B2GulOMzaWzi5HHNqBpp
         MW4iHkjHYWKpFjaAveoQy1m0ZY6yI34AUWFcY=
MIME-Version: 1.0
In-Reply-To: <20110211122410.GF23404@n2100.arm.linux.org.uk>
References: <1297373487-23902-1-git-send-email-ccross@android.com>
	<1297373487-23902-4-git-send-email-ccross@android.com>
	<1297426345.17584.99.camel@e102109-lin.cambridge.arm.com>
	<20110211122410.GF23404@n2100.arm.linux.org.uk>
Date: Fri, 11 Feb 2011 12:55:59 +0000
X-Google-Sender-Auth: IEcUR6__0mNARDtRw5OpzSENTQY
Message-ID: <AANLkTiksKEZzYwkh1DzoGYRmhq=XLm9Yh+DMGys7aE0S@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3] ARM: vfp: Use cpu pm notifiers to save vfp state
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Colin Cross <ccross@android.com>, linux-arm-kernel@lists.infradead.org,
        santosh.shilimkar@ti.com, Will Deacon <Will.Deacon@arm.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 February 2011 12:24, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Fri, Feb 11, 2011 at 12:12:25PM +0000, Catalin Marinas wrote:
>> On SMP systems, we save the VFP at every context switch to deal with the
>> thread migration (though I have a plan to make this lazily on SMP as
>> well).
>
> I'm not sure it's worth the complexity.  You'd have to do an IPI to the
> old CPU to provoke it to save the context from its VFP unit.  You'd have
> to do that in some kind of atomic way as the old CPU may be in the middle
> of already saving it.  You're also going to have to add locking to the
> last_VFP_context[] array as other CPUs will be accessing non-local
> entries, and that means doing locking in assembly.  Yuck.

I wasn't thinking about that, too complex indeed. But it may be easier
to detect thread migration, possibly with some hooks into generic
scheduler and only save the VFP state at that point. I haven't looked
in detail but I heard the x86 people have patches for something
similar.

-- 
Catalin
