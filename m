Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622Ab1HKSfl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 14:35:41 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41943 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab1HKSfk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 14:35:40 -0400
MIME-Version: 1.0
In-Reply-To: <201108081557.48504.philipp.reisner@linbit.com>
References: <201108081557.48504.philipp.reisner@linbit.com>
Date: Thu, 11 Aug 2011 20:34:57 +0200
Message-ID: <CAJAFBLC+MpBRk29dX286G1mkobi_FnXAiQuF++eACZ8VUct2XQ@mail.gmail.com>
Subject: Re: request for review - DRBD multi volume support for 3.2
From: Fubo Chen <fubo.chen@gmail.com>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 8, 2011 at 3:57 PM, Philipp Reisner
<philipp.reisner@linbit.com> wrote:
> This is a request for review of drbd-8.4. I intend to send a pull request
> to Jens early next week, for his for-3.2/drivers branch.
>
> I want to point out the idr_for_each_entry() macro, added to
> include/linux/idr.h.  Though we use this macro extensively in the new DRBD
> code, it is not DRBD specific. I intend to leave it in this patch series, as
> the following patches depend on it.
>
> The most noticeable change is the support for multiple replicated volumes in
> a single DRBD connection.  Write-ordering is obeyed among all writes in all
> volumes in a single connection.  This feature is really important for users
> who DRBD for mirroring over longer distances. (Protocol A).

Does not build here. Is EXPORT_SYMBOL(lc_is_used) missing ?

drivers/block/drbd/drbd_main.c: In function 'drbd_buildtag':
drivers/block/drbd/drbd_main.c:3561:19: warning: the comparison will
always evaluate as 'true' for the address of '__this_module' will
never be NULL [-Waddress]
drivers/block/drbd/drbd_nl.c:2463:12: warning: 'drbd_bmio_set_susp_al'
defined but not used [-Wunused-function]
ERROR: "lc_is_used" [drivers/block/drbd/drbd.ko] undefined!
ERROR: "lc_try_lock" [drivers/block/drbd/drbd.ko] undefined!
ERROR: "drbd_nla_parse_nested" [drivers/block/drbd/drbd.ko] undefined!
ERROR: "drbd_nla_find_nested" [drivers/block/drbd/drbd.ko] undefined!

Fubo.
