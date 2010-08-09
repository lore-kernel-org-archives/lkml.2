Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab0HISgz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 14:36:55 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45824 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910Ab0HISgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 14:36:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=qsMUH04MegCe2Uyg3h/+dzvMvERVVFYFEqMJg9NShcds3Rmhdl0xvNmX0yVZveCuiL
         3W616YROvLvvkvemGMHvL8rP8A7Mbcs6ZqPOHvCD2ZxZt9gMbc3Dn4E7+UCHJ4PYKkMJ
         OCVMy6UqYWTjqmIaroTLdKoyweGFOe+xvA4a4=
MIME-Version: 1.0
In-Reply-To: <1281374816-904-3-git-send-email-ngupta@vflare.org>
References: <1281374816-904-1-git-send-email-ngupta@vflare.org>
	<1281374816-904-3-git-send-email-ngupta@vflare.org>
Date: Mon, 9 Aug 2010 21:36:53 +0300
X-Google-Sender-Auth: tEyuu-v76S8fhbeaLXTlZzqLvOs
Message-ID: <AANLkTinsoHUb307N+v6pGfRraHK-epBU70fD0FxPCNup@mail.gmail.com>
Subject: Re: [PATCH 02/10] Remove need for explicit device initialization
From: Pekka Enberg <penberg@kernel.org>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Linux Driver Project <devel@driverdev.osuosl.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 9, 2010 at 8:26 PM, Nitin Gupta <ngupta@vflare.org> wrote:
> Currently, the user has to explicitly write a positive value to
> initstate sysfs node before the device can be used. This event
> triggers allocation of per-device metadata like memory pool,
> table array and so on.
>
> We do not pre-initialize all zram devices since the 'table' array,
> mapping disk blocks to compressed chunks, takes considerable amount
> of memory (8 bytes per page). So, pre-initializing all devices will
> be quite wasteful if only few or none of the devices are actually
> used.
>
> This explicit device initialization from user is an odd requirement and
> can be easily avoided. We now initialize the device when first write is
> done to the device.
>
> Signed-off-by: Nitin Gupta <ngupta@vflare.org>

AFAICT, most hardware block device drivers do things like this in the
probe function. Why can't we do that for zram as well and drop the
->init_done and ->init_lock parts?
