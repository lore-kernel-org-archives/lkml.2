Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933549Ab1FBMuB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 08:50:01 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59891 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab1FBMuA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 08:50:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=vrfy.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=YWySb09TAS/s50u2q/pUT1YXk9xs7W3HZ5la6YckQ5VhYRKdU64gvm11SebK7YmyXa
         zHl4gDID5T/v6BIBAFiGUPOpo3d+HfiNmPBX+iMjjml4MZKzv11CSXr1HY0ovu34m+HJ
         WuBbx230NCAzP7v5pu925tC/Wio1Z40nSOPoY=
MIME-Version: 1.0
In-Reply-To: <1306957788-12310-1-git-send-email-wad@chromium.org>
References: <1306957788-12310-1-git-send-email-wad@chromium.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 2 Jun 2011 14:49:44 +0200
Message-ID: <BANLkTimi2o4vnSWp5rQGrU3BTSC+YyO0qg@mail.gmail.com>
Subject: Re: [PATCH] init: add root=PARTUUID=UUID+/-%d support
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@gmail.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 1, 2011 at 21:49, Will Drewry <wad@chromium.org> wrote:
> Not sure if this is practical and/or interesting to others, but it's a
> minimal change --
>
> Expands root=PARTUUID=UUID syntax to support selecting a root partition
> by integer offset from a known, unique partition.  This approach
> provides similar properties to specifying a device and partition number,
> but using the UUID as the unique path prior to evaluating the offset.
>
> For example,
>  root=PARTUUID=99DE9194-FC15-4223-9192-FC243948F88B+1
> selects the partition with UUID 99DE.. then select the next
> partition.
>
> This change is motivated by a particular usecase in Chromium OS where
> the bootloader can easily determine what partition it is on (by UUID)
> but doesn't perform general partition table walking.
>
> That said, support for this approach provides a direct mechanism for the
> user to modify the root partition to boot without specifically needing
> to extract each PARTUUID or update the bootloader explicitly when the
> root partition UUID is changed (if it is recreated to be larger, for
> instance, restored, etc).  Pinning to a /boot partition UUID with an
> offset allows the arbitrary root partition reconfiguration/modifications
> with slightly less ambiguity than just [dev][partition] and less
> stringency than the specific root partition UUID.

Kind of a creative notation to add/substract something from a uuid. :)

If we are not sure we'll not need another magic thing in the future,
we might want to go for a named parameter to add?
Maybe instead of:
  root=PARTUUID=99DE9194-FC15-4223-9192-FC243948F88B+2
we could do:
  root=PARTUUID=99DE9194-FC15-4223-9192-FC243948F88B,PARTNROFF=2

Might be it's a but over the top, but the key is named PARTUUID, and a
+- to it doesn't seem to explain what it does and can not really be
expanded for even more creative uses. :)

Kay
