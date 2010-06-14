Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058Ab0FNQAd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 12:00:33 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54954 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab0FNQAb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 12:00:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Y0hqions9RmWh9RKYlfMI+FKbu8UcZNOOP2dV408Zr5/JuLk7nG1i3/+Ycmm/CU9O2
         MtfLo1UCc00ygcDPKWdQFjhba3f+2fClwZOaeOCpfyvwfa9FBMQurP93y+1eBmYjMJcD
         bfvfqDAQllmbpFB0KwfmsJ60MPUPCX8jnuDL0=
MIME-Version: 1.0
In-Reply-To: <201006141653.03879.rjw@sisk.pl>
References: <201006141653.03879.rjw@sisk.pl>
Date: Mon, 14 Jun 2010 12:00:29 -0400
Message-ID: <AANLkTimQ_yCV5Xdwd_D1zFM1oom2D3ZIBeSczJh4LN1T@mail.gmail.com>
Subject: Re: [Regression, post-2.6.34] Hibernation broken on machines with 
	radeon/KMS and r300
From: Alex Deucher <alexdeucher@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Dave Airlie <airlied@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 10:53 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Alex, Dave,
>
> I'm afraid hibernation is broken on all machines using radeon/KMS with r300
> after commit ce8f53709bf440100cb9d31b1303291551cf517f
> (drm/radeon/kms/pm: rework power management).  At least, I'm able to reproduce
> the symptom, which is that the machine hangs hard around the point where an
> image is created (probably during the device thaw phase), on two different
> boxes with r300 (the output of lspci from one of them is attached for
> reference, the other one is HP nx6325).
>
> Suspend to RAM appears to work fine at least on one of the affected boxes.
>
> Unfortunately, the commit above changes a lot of code and it's not too easy to
> figure out what's wrong with it and I didn't have the time to look more into
> details of this failure.  However, it looks like you use .suspend() and
> .resume() callbacks as .freeze() and .thaw() which may not be 100% correct
> (in fact it looks like the "legacy" PCI suspend/resume is used, which is not
> recommended any more).
>

Does it work any better after Dave's last drm pull request?  With the
latest changes, pm should not be a factor unless it's explicitly
enabled via sysfs.

Alex

> Thanks,
> Rafael
>
