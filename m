Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab0IASrW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 14:47:22 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46273 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998Ab0IASrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 14:47:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=hknnP4iOUA+dR6+n7uzBo2graU8vlS9XqKp8glhT9X6hClVvD6yDBIYpxZxtR7/CEh
         zUR/ZBB+KNmBecwM4lWcMv2vHWMGxf5Znv5VNc+/ePjXGZnoPXuS6YjkvIBI4d/UmUfk
         Niw09o/1nNCLCtwRF37n7mkMIJ8LBvDfO4Jxs=
Date: Wed, 1 Sep 2010 20:47:16 +0200
From: Paolo Ornati <ornati@gmail.com>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: help with git bisecting a bug 16376: random - possibly Radeon
 DRM KMS related - freezes
Message-ID: <20100901204716.775e9cfd@gmail.com>
In-Reply-To: <201008312153.45792.Martin@lichtvoll.de>
References: <201008312153.45792.Martin@lichtvoll.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Aug 2010 21:53:43 +0200
Martin Steigerwald <Martin@lichtvoll.de> wrote:

> Obviously I am not interested in kernels prior 2.6.33. Should I just do a 
> "git bisect good" without trying the kernel or is there some other remedy? 

No. Git is right in asking you to test that commit: you are ignoring
branches and merges.

Example
========

Linus Tree	Usb Tree

v2.6.33-rc2
|          \
|           | commit A (version is v2.6.33-rc2)
|           | commit B ( " )
v2.6.33     | commit C ( " )
|        __/
|     __/
|  __/
|_/
X <--- MERGE

So the commit you are testing it's like "commit A": it was done before
(in time) v2.6.33, on a kernel based on v2.6.33-rc2, but was merged in
Linus' tree _after_ v2.3.33.

So this this behaviour is normal :)

-- 
	Paolo Ornati
	Linux 2.6.35.4 on x86_64
