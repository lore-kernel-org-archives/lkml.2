Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab1JSXKN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 19:10:13 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53578 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283Ab1JSXKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 19:10:11 -0400
MIME-Version: 1.0
In-Reply-To: <20111019230347.GA32295@tango.0pointer.de>
References: <1317943022.1095.25.camel@mop> <CALdu-PBLCNXTaZuODyzw_g_FQNyLqK_FsdObC=HjtEp75vkdFQ@mail.gmail.com>
 <20111019230347.GA32295@tango.0pointer.de>
From: Paul Menage <paul@paulmenage.org>
Date: Wed, 19 Oct 2011 16:09:51 -0700
X-Google-Sender-Auth: KLPo0NVGQcT_Vtb0BJM9AYDjL98
Message-ID: <CALdu-PCRj4+tL-6MXwsZKuODHRQn_pixdfVLwC6PV2a0q4sw4g@mail.gmail.com>
Subject: =?windows-1252?Q?Re=3A_A_Plumber=92s_Wish_List_for_Linux?=
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        harald@redhat.com, david@fubar.dk, greg@kroah.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 4:03 PM, Lennart Poettering
<mzxreary@0pointer.de> wrote:
>
> For our systemd usecase a cgroup.signal file would not be useful. This
> is because we actually kill all members of the service's cgroup plus the
> main process of the service, which is usually also in the service's
> cgroup but sometimes isn't (for example: when the user logs in, the
> whole /sbin/login process ends up in the user's session cgroup, and is
> removed from the original service cgroup). Since we want to avoid
> killing the main service process twice in the case where it isn't in the
> servce cgroup we'd hence prefer to have some fork throttling logic in
> place, so that we can kill members flexibly in accordance with these
> rules.

By fork-throttling, do you just mean "0 or unlimited", or would you
actually want some kind of rate-limited throttling? If the former,
than I agree with Frederick that his task counter should solve that
problem.

Paul
