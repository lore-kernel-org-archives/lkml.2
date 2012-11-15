Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992666Ab2KOBwl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 20:52:41 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:62783 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992622Ab2KOBwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 20:52:40 -0500
MIME-Version: 1.0
In-Reply-To: <1352944274-21699-1-git-send-email-dhsharp@google.com>
References: <1352944274-21699-1-git-send-email-dhsharp@google.com>
From: David Sharp <dhsharp@google.com>
Date: Wed, 14 Nov 2012 17:52:18 -0800
Message-ID: <CAJL_ekuL2NjA50eZ-anDefwjAbLBKignXxUvyEPVZvUag5W=Ng@mail.gmail.com>
Subject: Re: [PATCH 1/4] kernelshark: Fix bug with Plot CPU filtering
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Cc: Venkatesh Pallipadi <venki@google.com>, David Sharp <dhsharp@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sorry for the dups... typoed Steve's domain.

On Wed, Nov 14, 2012 at 5:51 PM, David Sharp <dhsharp@google.com> wrote:
> From: Venkatesh Pallipadi <venki@google.com>
>
> Plot CPU filtering in kernelshark has the following bug:
> 1) Deselect CPU A from Plot CPU list
> 2) Plot gets updated with no CPU A
> 3) Deselect CPU B
> 4) Plot continues to have CPU B
>
> This is due to a bug in graph_plot_cpus_update_callback(),
> which seems to be checking old_all_cpus != new_all_cpus before doing any
> update. This condition is true on 1, but false on 2.
> Removing that check fixes the problem.
>
> Tested:
> Above sequence now does expected filtering.
>
> Google-bug-id: 4258610
> Signed-off-by: Venkatesh Pallipadi <venki@google.com>
> Signed-off-by: David Sharp <dhsharp@google.com>
