Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757665Ab1DMIRN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 04:17:13 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64288 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569Ab1DMIRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 04:17:07 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.163.109]
In-Reply-To: <201104121946.01618.arnd@arndb.de>
References: <1302535464-12294-1-git-send-email-mathieu.poirier@linaro.org> <201104121946.01618.arnd@arndb.de>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 13 Apr 2011 11:16:47 +0300
Message-ID: <BANLkTinGt1wey0ofLRUVzS4Ru==OLvChTQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] ux500: Adding support for u8500 Hsem functionality V2
To: Arnd Bergmann <arnd@arndb.de>
Cc: mathieu.poirier@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, lee.jones@linaro.org,
        patches@linaro.org, linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 8:46 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> When you do that, this can be a single allocation.
>
> Thinking about it some more, it may actually be worthwhile to still improve
> the API here: I think the owner field should be part of the operations structure,
> because it is constant. It would also be nice to have a "private" pointer
> in struct hwspinlock, so you don't need to wrap it if you don't want to.

These are good improvements, part of which I planned to do so too
(especially to take out the dev, ops and owner fields into a dedicated
structure, and have all the hwspinlock instances, which belong to that
block, point at it).

By introducing a "private" pointer, and removing the platform-specific
wrapping around it, we can also get rid of the 'id' field, and induce
it with a simple pointers arithmetic (namely, id = pointer of instance
- array base address).
