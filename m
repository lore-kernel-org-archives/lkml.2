Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942Ab0I2VEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 17:04:23 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35848 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755897Ab0I2VEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 17:04:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=f50mGKzuiTB+y4ljCikr+N6tTONSq4a87Zn8T0WtsHgfJmMemUJQVwWM8QYDWhbFsT
         FdYyeEU8IQUgOK7XAIes4cPqm5LobtiDv35xvrzW1dAQPsH5F+GrQYasW++H2GIicCZ3
         harzbzolGLiJnOqL8ax6NFyqgm55mw/cfu/q8=
MIME-Version: 1.0
In-Reply-To: <1285657392-28937-1-git-send-email-linus.walleij@stericsson.com>
References: <1285657392-28937-1-git-send-email-linus.walleij@stericsson.com>
Date: Wed, 29 Sep 2010 14:04:21 -0700
X-Google-Sender-Auth: Y-El59Y9j1mEw2tjYy9C8eHxVN8
Message-ID: <AANLkTimBvtwnHmWeT_uEo+ScZtYePKnZYkFEJyOVD5DO@mail.gmail.com>
Subject: Re: [PATCH 1/2] DMAENGINE: define a dummy filter function for coh901318
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 12:03 AM, Linus Walleij
<linus.walleij@stericsson.com> wrote:
> All platform data has to be made conditional on
> as to avoid cluttering the code with other #ifdef:s.
>

The filter id function assumes that the channel passed in is a
coh901318 which requires that you are in a mach-u300 build and that no
other dma driver will ever appear on this platform.  Which may be
true, but it would be safer to look at
chan->device->dev->platform_data and deduce that it is indeed a
coh901318 channel before de-referencing private fields.  Taken further
if you rewrite the filter_id function in terms of platform_data then
it could live purely in the arch code and not depend on the driver.

...or did you already try this route and hit a snag?

--
Dan
