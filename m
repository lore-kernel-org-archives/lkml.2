Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab2KDO7k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 09:59:40 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:53670 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375Ab2KDO7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 09:59:39 -0500
MIME-Version: 1.0
In-Reply-To: <1351974625-10282-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1351974625-10282-1-git-send-email-Julia.Lawall@lip6.fr>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Sun, 4 Nov 2012 09:59:18 -0500
Message-ID: <CA+1xoqd-UQXg0nuE1t5ayYY1Ow81er2mHUFUow=mfcwzkCPW5A@mail.gmail.com>
Subject: Re: [PATCH 0/8] drop if around WARN_ON
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julia,

On Sat, Nov 3, 2012 at 4:30 PM, Julia Lawall <Julia.Lawall@lip6.fr> wrote:
> These patches convert a conditional with a simple test expression and a
> then branch that only calls WARN_ON(1) to just a call to WARN_ON, which
> will test the condition.
>
> // <smpl>
> @@
> expression e;
> @@
>
> (
> if(<+...e(...)...+>) WARN_ON(1);
> |
> - if (e) WARN_ON(1);
> + WARN_ON(e);
> )// </smpl>

So this deals with WARN_ON(), are you considering doing the same for
the rest of it's friends?


Thanks,
Sasha
