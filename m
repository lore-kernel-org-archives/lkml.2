Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933603Ab0GOPdM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 11:33:12 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36207 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933418Ab0GOPdI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 11:33:08 -0400
MIME-Version: 1.0
In-Reply-To: <1279154621-25868-5-git-send-email-john.johansen@canonical.com>
References: <1279154621-25868-1-git-send-email-john.johansen@canonical.com>
	<1279154621-25868-5-git-send-email-john.johansen@canonical.com>
Date: Thu, 15 Jul 2010 11:33:07 -0400
Message-ID: <AANLkTim_l1RDI3icW1Ko7NWvECT1JzuM2c3Qqa8wvQR6@mail.gmail.com>
Subject: Re: [PATCH 04/13] AppArmor: core policy routines
From: Eric Paris <eparis@parisplace.org>
To: John Johansen <john.johansen@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 8:43 PM, John Johansen
<john.johansen@canonical.com> wrote:
> The basic routines and defines for AppArmor policy.  AppArmor policy
> is defined by a few basic components.
>      profiles - the basic unit of confinement contain all the information
>                 to enforce policy on a task
>
>                 Profiles tend to be named after an executable that they
>                 will attach to but this is not required.
>      namespaces - a container for a set of profiles that will be used
>                 during attachment and transitions between profiles.
>      sids - which provide a unique id for each profile
>
> Signed-off-by: John Johansen <john.johansen@canonical.com>
> ---

> +       PFLAG_MMAP_MIN_ADDR = 0x80,     /* profile controls mmap_min_addr */

You don't actually support this per ?domain? mmap_min_addr and I'm not
sure how you ever can (given the nature of round_hint_to_min()) so
maybe you should rip it all out rather than having the half
implemented stuff in patches 4 and 6?
