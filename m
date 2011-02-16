Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992Ab1BPGYk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 01:24:40 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46837 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873Ab1BPGYg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 01:24:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BZ8/CCRK6SaywVqrepgYAMl1IHyhaSbopSyc+FqLqsJi0jMYc4ubCb+WEVsTehooNR
         r1yRqEqpzkj1DcViS+/gg/VHhO5q7NHGsehOGP/wrheaMdwkrvwO7JF5sIsxIbMcBRgk
         Qqe2jrKuFOIjmud6Bh80EBBngeeKMIsTO6ln0=
MIME-Version: 1.0
In-Reply-To: <20110215012149.GM9869@sequoia.sous-sol.org>
References: <20110213062213.GA2525@darkstar.dhcp.inet.fi>
	<AANLkTimDuYgL2cSR8gE7Wrm9_w7cvG_wuUUsa=8TKs87@mail.gmail.com>
	<AANLkTimxCMgdfht7rrg8QiCppb=D7fvR92eeiewdqCpH@mail.gmail.com>
	<20110214003531.GH9869@sequoia.sous-sol.org>
	<alpine.LRH.2.00.1102141203430.12055@tundra.namei.org>
	<20110215012149.GM9869@sequoia.sous-sol.org>
Date: Wed, 16 Feb 2011 07:24:34 +0100
Message-ID: <AANLkTinS2dGVgPMNW=k6xVbWgQwxkopKVW_9YYtCZX8G@mail.gmail.com>
Subject: Re: [PATCH v3] pci: use security_capable() when checking capablities
 during config space read
From: Alex Riesen <raa.lkml@gmail.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: James Morris <jmorris@namei.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@gmail.com>,
        Dave Young <hidave.darkstar@gmail.com>, linux-kernel@vger.kernel.org,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Sedat Dilek <sedat.dilek@googlemail.com>,
        Eric Paris <eparis@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 02:21, Chris Wright <chrisw@sous-sol.org> wrote:
> This reintroduces commit 47970b1b which was subsequently reverted
> as f00eaeea.  The original change was broken and caused X startup
> failures and generally made privileged processes incapable of reading
> device dependent config space.  The normal capable() interface returns
> true on success, but the LSM interface returns 0 on success.  This thinko
> is now fixed in this patch, and has been confirmed to work properly.
>
> So, once again...Eric Paris noted that commit de139a3 ("pci: check caps
> from sysfs file open to read device dependent config space") caused the
> capability check to bypass security modules and potentially auditing.
> Rectify this by calling security_capable() when checking the open file's
> capabilities for config space reads.
>
> Reported-by: Eric Paris <eparis@redhat.com>
> Tested-by: Dave Young <hidave.darkstar@gmail.com>
> Acked-by: James Morris <jmorris@namei.org>
> Cc: Dave Airlie <airlied@gmail.com>
> Cc: Alex Riesen <raa.lkml@gmail.com>
> Cc: Sedat Dilek <sedat.dilek@googlemail.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Chris Wright <chrisw@sous-sol.org>

FWIW, I confirm the fix.
