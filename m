Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab1EYUyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 16:54:23 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:44527 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561Ab1EYUyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 16:54:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=BLETtF3bTPbY0BZSAhQKMGfTcTltM9MVSDavl642IwlBHnXtSPpLYQsbXUK6p2QeVf
         6nhG9z5j5jnNtcEgKqVaXDlVPYbWpUdfWKwz/y0fFzEm7InZB2zfKSmV0SPCQrf7nPo6
         EVVc8go61GCU3xrFjiz4pSNgsL1dv5+vSwo/4=
MIME-Version: 1.0
In-Reply-To: <4DDD5A7E.4030903@fusionio.com>
References: <201105252116.37839.linux@rainbow-software.org>
	<4DDD5A7E.4030903@fusionio.com>
Date: Wed, 25 May 2011 22:54:21 +0200
X-Google-Sender-Auth: erVk6JvoFj5NQmIJ12J6Dn5q_sk
Message-ID: <BANLkTimD31sNsWy0EzCREFj2oMWP+WQcWA@mail.gmail.com>
Subject: Re: [bisected] 2.6.39 breaks floppy
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Ondrej Zary <linux@rainbow-software.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, May 25, 2011 at 9:37 PM, Jens Axboe <jaxboe@fusionio.com> wrote:
>> Bisected it to 9fd097b14918875bd6f125ed699d7bbbba5893ee
>> (block: unexport DISK_EVENT_MEDIA_CHANGE for legacy/fringe drivers)
>>
>> Adding the removed line back to floppy.c fixes the problem.

It's the same one as the following.  Patch posted.  It's caused by
genhd->ev not allocated when ->events | async_events is empty.

  https://bugzilla.kernel.org/show_bug.cgi?id=35832

Will soon post a patch.

Thanks.

-- 
tejun
