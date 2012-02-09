Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891Ab2BIFIH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 00:08:07 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59326 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab2BIFIF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 00:08:05 -0500
MIME-Version: 1.0
In-Reply-To: <20120207.091612.181444339.anemo@mba.ocn.ne.jp>
References: <20120207.091612.181444339.anemo@mba.ocn.ne.jp>
Date: Thu, 9 Feb 2012 00:08:03 -0500
Message-ID: <CACqU3MXdKti6J2ozx3mt3UHdhv1fyPredvT6zJGR+u_hNU70Cg@mail.gmail.com>
Subject: Re: kconfig: tristate choice with depender choice
From: Arnaud Lacombe <lacombar@gmail.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Feb 6, 2012 at 7:16 PM, Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
> If a tristate choice has another choice dependers, kconfig produce
> wrong value.
>
> Example:
>
> choice
>        prompt "choice list AB"
> config A
>        tristate "a"
> config B
>        tristate "b"
> endchoice
> choice
>        prompt "choice list CD"
>        depends on A
> config C
>        bool "c"
> config D
>        bool "d"
> endchoice
>
> kconfig outputs CONFIG_A=m from defconfig with CONFIG_A=y.
>
> This happens if the choice list CD depends on A.
> Also, if defconfig contains CONFIG_A=y and "# CONFIG_B is not set",
> output is correct.
>
confirmed.

> I found commit a64b44ea ("kconfig: fix tristate choice with minimal
> config"), but this problem still exists on v3.3-rc1.  More fix is
> needed for choice with dependers?
>
it would seem so.

 - Arnaud
