Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806Ab2HJRtm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 13:49:42 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:42704 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754746Ab2HJRtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 13:49:40 -0400
MIME-Version: 1.0
In-Reply-To: <20120810062829.GA4546@mwanda>
References: <1343141382-31087-1-git-send-email-benchan@chromium.org>
 <CAHdPZaOTvF=e3j8ypzK8_V5Uh_8Nk1U74uVe4tcXs+cdQvimjg@mail.gmail.com>
 <CAC5Y2nMeYvKhMjPFFa-3tGLOOyxXX1B8MZSbXrMLsNDPJmdmzA@mail.gmail.com>
 <CAHdPZaPwUHHUyvgU1N=FAggF5Gg_p7cf-290Yd1+i+9eNyDY1g@mail.gmail.com> <20120810062829.GA4546@mwanda>
From: Ben Chan <benchan@chromium.org>
Date: Fri, 10 Aug 2012 10:49:19 -0700
X-Google-Sender-Auth: fL55-qqQ0RN-dfJFGjUZl9Ul0-Q
Message-ID: <CAC5Y2nOz+Q1wrqGezZP9O+a2_EWSV+yPOZ4kP=e0E3GfJWQWFg@mail.gmail.com>
Subject: Re: [PATCH v2] staging: gdm72xx: fix reference counting in gdm_wimax_event_init
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "devendra.aaru" <devendra.aaru@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

I manually walked through the driver code and spotted the issue. But
this morning I was able to get an extra module to verify my patch on
hardware.

I tested the following patterns using two identical modules, and
checked the creation/destruction/ref_cnt of wm_event:
- insert module A, remove A
- insert A, insert B, remove A, remove B
- insert A, insert B, remove B, remove A
- insert A, insert B, remove A, remove B
- insert A, insert B, remove B, insert B, remove B, remove A

Thanks,
Ben

On Thu, Aug 9, 2012 at 11:28 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> Ben, I'm confused.  Do you have a way to test this, or are you just
> doing manual review?
>
> regards,
> dan carpenter
>
