Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819Ab0KKUtb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 15:49:31 -0500
Received: from borg.medozas.de ([188.40.89.202]:45251 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756128Ab0KKUta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 15:49:30 -0500
Date: Thu, 11 Nov 2010 21:49:26 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Eric Paris <eparis@redhat.com>
cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, kaber@trash.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: NF_HOOK_COND has wrong conditional
In-Reply-To: <20101111190954.29005.61686.stgit@paris.rdu.redhat.com>
Message-ID: <alpine.LNX.2.01.1011112148100.30863@obet.zrqbmnf.qr>
References: <20101111190954.29005.61686.stgit@paris.rdu.redhat.com>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 2010-11-11 20:09, Eric Paris wrote:

>The NF_HOOK_COND returns 0 when it shouldn't due to what I believe to be an
>error in the code as the order of operations is not what was intended.  C will
>evalutate == before =.  Which means ret is getting set to the bool result,
>rather than the return value of the function call.  The code says
>
>if (ret = function() == 1)
>when it meant to say:
>if ((ret = function()) == 1)

Thanks for catching. Indeed (ret = f) == 1 is desired, as can be seen in 
patch 2249065f4b22b493bae2caf549b86f175f33188e.
