Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457Ab2KUMpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 07:45:47 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63477 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab2KUMpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 07:45:46 -0500
MIME-Version: 1.0
In-Reply-To: <20121116192606.11799.35711.stgit@localhost.localdomain>
References: <20121116192606.11799.35711.stgit@localhost.localdomain>
Date: Wed, 21 Nov 2012 07:45:45 -0500
Message-ID: <CA+5PVA6nKNZY70UoeDUhQo9Rj4Ck+k+XTHL++gwErgzqAdy6Aw@mail.gmail.com>
Subject: Re: [PATCH] fb: Rework locking to fix lock ordering on takeover
From: Josh Boyer <jwboyer@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, florianschandinat@gmx.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 2:27 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>
> [The fb maintainer appears to be absent at the moment].
>
> This is needed to fix a pile of lockdep splats that now show up because console_lock()
> is being properly audited. Hugh Dickins and Sasha Levin have tested it and both reports
> all looks good. This is probably not the whole story - the entire fb layer has locking
> confusion problems that were previously hidden but it seems to get the ones people hit
> in testing. This hopefully explains a few of the weird fb hangs that have been floating
> around forever.
>
> From: Alan Cox <alan@linux.intel.com>
>
> Adjust the console layer to allow a take over call where the caller already
> holds the locks. Make the fb layer lock in order.
>
> This s partly a band aid, the fb layer is terminally confused about the
> locking rules it uses for its notifiers it seems.
>
> Signed-off-by: Alan Cox <alan@linux.intel.com>

Should this eventually get into the stable trees?

josh
