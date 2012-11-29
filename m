Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760Ab2K2Qd3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 11:33:29 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:49366 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab2K2Qd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 11:33:28 -0500
MIME-Version: 1.0
In-Reply-To: <201211291822.16565.vitas@nppfactor.kiev.ua>
References: <201211271348.14603.vitas@nppfactor.kiev.ua>
	<20121128210509.GA2590@local>
	<CAM3j68rrBePLoamRb1pCH+TeAfLDO-5Jd_kk7-JRCNnEBhLp2Q@mail.gmail.com>
	<201211291822.16565.vitas@nppfactor.kiev.ua>
Date: Thu, 29 Nov 2012 17:33:24 +0100
X-Google-Sender-Auth: JYeCPvND3q2YgaW7K-BncWWv-_w
Message-ID: <CAM3j68p0i-AeuKX9CfU99pbmtj9PT_GOom+nzCZWdAMmGm8XMQ@mail.gmail.com>
Subject: Re: [PATCH] uio.c: Fix warning: 'ret' might be used uninitialized
From: Cong Ding <dinggnu@gmail.com>
To: Vitalii Demianets <vitas@nppfactor.kiev.ua>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No, there are some exceptions. Imagine this case, when mi=0,
everything works correct in the loop, and then mi=1, if the kzalloc in
line 286 fails, you patch will goto err_map with ret=-ENOMEM, while
Hans's patch will goto err_map with ret=0 (the ret=0 is from line 295
when mi=0).

On Thu, Nov 29, 2012 at 5:22 PM, Vitalii Demianets
<vitas@nppfactor.kiev.ua> wrote:
> Actually, both patches do exactly the same thing. Hans's patch establishes
> default value for the ret for all those "other" cases when ret is not
> explicitly overridden. My patch explicitly enumerates all those "other" cases
> in more wordily manner.
