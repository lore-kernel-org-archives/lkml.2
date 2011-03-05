Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab1CERZR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 12:25:17 -0500
Received: from mail-gw0-f51.google.com ([74.125.83.51]:37176 "EHLO
	mail-gw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882Ab1CERZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 12:25:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=tbNWNKV6hoXc+0maSHjEURjfHMTxZioWMF7V0j/YDPIPV23/Rkq2eaBDTzajG6xzSs
         8XuE+Q1Kv7kbXw0/4v1LeYNx6pVL1hwfWOrGIgJ02X1RolLW+7BKj4dyEe6pLfJz3C8Z
         Kjg2VnMdvN4zFvmir+Ce4ObZV2r98Y0bS+R+k=
MIME-Version: 1.0
In-Reply-To: <1299343345-3984-19-git-send-email-cesarb@cesarb.net>
References: <1299343345-3984-1-git-send-email-cesarb@cesarb.net>
	<1299343345-3984-19-git-send-email-cesarb@cesarb.net>
Date: Sat, 5 Mar 2011 19:25:15 +0200
X-Google-Sender-Auth: 8xqyZPKw11HJi2LaMoONz1Fc6ew
Message-ID: <AANLkTim50m5KDdmcWixL+4-nw2kWnddOgsUaXRbrBMvR@mail.gmail.com>
Subject: Re: [PATCHv2 18/24] sys_swapon: call swap_cgroup_swapon earlier
From: Pekka Enberg <penberg@kernel.org>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org, Eric B Munson <emunson@mgebm.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 5, 2011 at 6:42 PM, Cesar Eduardo Barros <cesarb@cesarb.net> wrote:
> The call to swap_cgroup_swapon is in the middle of loading the swap map
> and extents. As it only does memory allocation and does not depend on
> the swapfile layout (map/extents), it can be called earlier (or later).
>
> Move it to just after the allocation of swap_map, since it is
> conceptually similar (allocates a map).
>
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
> Tested-by: Eric B Munson <emunson@mgebm.net>
> Acked-by: Eric B Munson <emunson@mgebm.net>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
