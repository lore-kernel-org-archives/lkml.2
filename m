Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab0IIQ74 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 12:59:56 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58825 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab0IIQ7y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 12:59:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=k2oHhvNnVDBOazylMYsm+6/8wwkrHcShRrFwiKbi0omRpJAVCG05Z9DbqiqVzbpF1B
         bxxaMmgopnfFC2atTmKqePTV7PIHYQ7WAkHa7j/glF6rvK/ZSSobN8uPCUReYn1KchWH
         q7Fo/rOh2aa7U+gOm5hdT/YqUGfiDJKsx6Tlo=
MIME-Version: 1.0
In-Reply-To: <1283963539-4039-1-git-send-email-mjg@redhat.com>
References: <1283963539-4039-1-git-send-email-mjg@redhat.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 9 Sep 2010 12:59:33 -0400
Message-ID: <AANLkTinD82aK3BWe8JXiF_hHBzH3e=k8ncFpGdUZ2edE@mail.gmail.com>
Subject: Re: [PATCH] Backlight: Add backlight type
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 8, 2010 at 12:32, Matthew Garrett <mjg@redhat.com> wrote:
> There may be multiple ways of controlling the backlight on a given machine.
> Allow drivers to expose the type of interface they are providing, making
> it possible for userspace to make appropriate policy decisions.

maybe i missed something, but i dont see the core validating the .type
value at registration time.  since the value is then used later as an
index into an array, shouldnt it verify that it is valid ?

do you want to force everyone to declare they're "raw" ?  or just go
with the memset default to have people start with "raw" ?  otherwise
it might make sense to have the first enum be BACKLIGHT_UNKNOWN and
have the core warn when it hits that.

> --- a/drivers/video/backlight/backlight.c
> +++ b/drivers/video/backlight/backlight.c
>
> +static const char *backlight_types[] = {
> +       [BACKLIGHT_RAW] = "raw",
> +       [BACKLIGHT_PLATFORM] = "platform",
> +       [BACKLIGHT_FIRMWARE] = "firmware",
> +};

const char * const backlight_types[] ?
-mke
