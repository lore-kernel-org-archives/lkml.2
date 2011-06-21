Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438Ab1FUHKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 03:10:46 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40790 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab1FUHKo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 03:10:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MR1xfQfzKgTB1S6HY288OdKSjY8qgA9Kl05Spf1x0pOqZcz9UVUf1v+QXZinl2RRjL
         S1BzYukUgsQBjSdqZr8fZ3IVvnr5fdKB6uD1obcP2yMojU8wKzKRHxuGaizXEn5qI1g3
         GW11mhcmSlFn9piNjnrOexuMjW1+moVIOENGE=
MIME-Version: 1.0
In-Reply-To: <201106210128.52101.rjw@sisk.pl>
References: <201106210128.52101.rjw@sisk.pl>
Date: Tue, 21 Jun 2011 16:10:44 +0900
Message-ID: <BANLkTin0dq07rquuAmE-jE1nmkRnKH7aSA@mail.gmail.com>
Subject: Re: [PATCH] PM / Runtime: Handle clocks correctly if
 CONFIG_PM_RUNTIME is unset
From: Magnus Damm <magnus.damm@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Kevin Hilman <khilman@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-sh@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 8:28 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> Commit 85eb8c8d0b0900c073b0e6f89979ac9c439ade1a (PM / Runtime:
> Generic clock manipulation rountines for runtime PM (v6)) converted
> the shmobile platform to using generic code for runtime PM clock
> management, but it changed the behavior for CONFIG_PM_RUNTIME unset
> incorrectly.
>
> Specifically, for CONFIG_PM_RUNTIME unset pm_runtime_clk_notify()
> should enable clocks for action equal to BUS_NOTIFY_BIND_DRIVER and
> it should disable them for action equal to BUS_NOTIFY_UNBOUND_DRIVER
> (instead of BUS_NOTIFY_ADD_DEVICE and BUS_NOTIFY_DEL_DEVICE,
> respectively).  Make this function behave as appropriate.
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Thanks Rafael!

Acked-by: Magnus Damm <damm@opensource.se>
