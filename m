Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751419Ab1FIFZj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 01:25:39 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49665 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab1FIFZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 01:25:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=DJm8nOQeWbZJToei25u2cLT0mcgN0GQym3lb1/aW+mHi6fo/PwaNiadSRm9ZiDmlQ2
         HhkBnEfUAyu5isbDdXrf8N/K8vMkh6+kUurQ/400WBsFSV9JN5194lU9+gubYvqCZyM1
         k3pOr/JnsyGeTQqNynt7WVGQhKFsTLGINpwgA=
Subject: Re: Change in functionality of futex() system call.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: George Spelvin <linux@horizon.com>
Cc: luto@mit.edu, david@rgmadvisors.com, dvhart@linux.intel.com,
        kyle@moffetthome.net, linux-kernel@vger.kernel.org
In-Reply-To: <20110609044354.1171.qmail@science.horizon.com>
References: <20110609044354.1171.qmail@science.horizon.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Jun 2011 07:25:33 +0200
Message-ID: <1307597133.3980.65.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 09 juin 2011 à 00:43 -0400, George Spelvin a écrit :

> Just for example, consider a circular buffer that a few (trusted)
> processes can write to, but many (less trusted) can read.  Obviously,
> being able to sleep on the head pointer is useful.


If its useful, then it needs a futex extension (and this must be
emulated on old kernels without this extension)

Remember futex_wake() call would just have to wakeup _all_ threads
instead of one, if kernel lacks this function.

If you dont trust futex_wait() users, just use futex_wake(ALL)

Its should not be a consequence of a previous (unrelated) patch, it
should be an added functionality, dully documented.



