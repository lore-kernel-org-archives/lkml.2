Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804Ab1FOPwz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 11:52:55 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43770 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966Ab1FOPwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 11:52:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=tfj8CdzVmSliVEg/+08A8WvXRn/uRZ8boYmvPIfCfFl1vdjCALNAlOcXLfRO19ZTpS
         RVJjOsYpV1EaZQ2gvU0Ixg3oe7IdPcM8zwyEp6Bi1bbTyjkcGG1iGJtTL7ihvjptj/Hx
         uk/ctnuKUnkeINxYaPMIohpnkF2GP2R/42Sqs=
MIME-Version: 1.0
In-Reply-To: <874o3rimbn.wl%ysato@users.sourceforge.jp>
References: <874o3rimbn.wl%ysato@users.sourceforge.jp>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 15 Jun 2011 11:52:33 -0400
Message-ID: <BANLkTins0CB0V+oxszTUZfP75Cj5t0M7rw@mail.gmail.com>
Subject: Re: [PATCH] binfmt_flat: missing argv table
To: ysato@users.sourceforge.jp
Cc: linux-kernel@vger.kernel.org,
        uClinux development list <uclinux-dev@uclinux.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 03:30, Yoshinori Sato wrote:
> "put_user" is multiple times evalute on argument
> (in asm-generic/uaccess.h).
> So this code building argv table include gabage.

NAK.  asm-generic/uaccess.h is broken.  i posted some fixes some time
ago to lkml for the header to clean it all up, but it had some minor
build warnings that needed to be addressed.

if you want to actually fix this issue, please start with my patch and
get the issues around it resolved:
  asm-generic: uaccess: do not expand args multiple times
-mike
