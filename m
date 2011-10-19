Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab1JSVMe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 17:12:34 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40572 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab1JSVMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 17:12:33 -0400
MIME-Version: 1.0
In-Reply-To: <1317943022.1095.25.camel@mop>
References: <1317943022.1095.25.camel@mop>
From: Paul Menage <paul@paulmenage.org>
Date: Wed, 19 Oct 2011 14:12:13 -0700
X-Google-Sender-Auth: LHzKtiuVWaFNa4N_heoixYTvIHE
Message-ID: <CALdu-PBLCNXTaZuODyzw_g_FQNyLqK_FsdObC=HjtEp75vkdFQ@mail.gmail.com>
Subject: =?windows-1252?Q?Re=3A_A_Plumber=92s_Wish_List_for_Linux?=
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel@vger.kernel.org, lennart@poettering.net, harald@redhat.com,
        david@fubar.dk, greg@kroah.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 6, 2011 at 4:17 PM, Kay Sievers <kay.sievers@vrfy.org> wrote:
>
> * fork throttling mechanism as basic cgroup functionality that is
> available in all hierarchies independent of the controllers used:
> This is important to implement race-free killing of all members of a
> cgroup, so that cgroup member processes cannot fork faster then a cgroup
> supervisor process could kill them. This needs to be recursive, so that
> not only a cgroup but all its subgroups are covered as well.

If that's your end goal, then an alternative to the freezer support
that others have mentioned would be a 'cgroup.signal' file which, when
written to, would send that signal to all members of the cgroup at
once. Perhaps simpler than having to get in the way of the fork path
more and manage a rate-limit.

>
> * allow user xattrs to be set on files in the cgroupfs (and maybe
> procfs?)

What would the use case be for this?

Paul
