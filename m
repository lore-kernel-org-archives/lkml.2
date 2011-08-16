Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481Ab1HPMAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 08:00:18 -0400
Received: from zimbra.linbit.com ([212.69.161.123]:52913 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012Ab1HPMAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 08:00:16 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: Fubo Chen <fubo.chen@gmail.com>
Subject: Re: request for review - DRBD multi volume support for 3.2
Date: Tue, 16 Aug 2011 14:00:04 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38-8-generic; KDE/4.6.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com
References: <201108081557.48504.philipp.reisner@linbit.com> <CAJAFBLC+MpBRk29dX286G1mkobi_FnXAiQuF++eACZ8VUct2XQ@mail.gmail.com>
In-Reply-To: <CAJAFBLC+MpBRk29dX286G1mkobi_FnXAiQuF++eACZ8VUct2XQ@mail.gmail.com>
X-OTRS-FollowUp-SenderType: agent
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108161400.04686.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 11. August 2011, 20:34:57 schrieb Fubo Chen:
> On Mon, Aug 8, 2011 at 3:57 PM, Philipp Reisner
> 
> <philipp.reisner@linbit.com> wrote:
> > This is a request for review of drbd-8.4. I intend to send a pull request
> > to Jens early next week, for his for-3.2/drivers branch.
> > 
> > I want to point out the idr_for_each_entry() macro, added to
> > include/linux/idr.h.  Though we use this macro extensively in the new
> > DRBD code, it is not DRBD specific. I intend to leave it in this patch
> > series, as the following patches depend on it.
> > 
> > The most noticeable change is the support for multiple replicated volumes
> > in a single DRBD connection.  Write-ordering is obeyed among all writes
> > in all volumes in a single connection.  This feature is really important
> > for users who DRBD for mirroring over longer distances. (Protocol A).
> 
> Does not build here. Is EXPORT_SYMBOL(lc_is_used) missing ?
> 
> drivers/block/drbd/drbd_main.c: In function 'drbd_buildtag':
> drivers/block/drbd/drbd_main.c:3561:19: warning: the comparison will
> always evaluate as 'true' for the address of '__this_module' will
> never be NULL [-Waddress]
> drivers/block/drbd/drbd_nl.c:2463:12: warning: 'drbd_bmio_set_susp_al'
> defined but not used [-Wunused-function]
> ERROR: "lc_is_used" [drivers/block/drbd/drbd.ko] undefined!
> ERROR: "lc_try_lock" [drivers/block/drbd/drbd.ko] undefined!
> ERROR: "drbd_nla_parse_nested" [drivers/block/drbd/drbd.ko] undefined!
> ERROR: "drbd_nla_find_nested" [drivers/block/drbd/drbd.ko] undefined!
> 
> Fubo.

Hi Fubo,

I fixed the missing EXPORT_SYMBOLS, the missing drbd_nla_* and the 
unused drbd_bmio_set_susp_al() issues. I amended the changes into
the commits where the fixes should be.

At you convenience, please retry:
  git://git.drbd.org/linux-2.6-drbd.git for-jens

Best,
 Phil
-- 
: Dipl-Ing Philipp Reisner
: LINBIT | Your Way to High Availability
: Tel: +43-1-8178292-50, Fax: +43-1-8178292-82
: http://www.linbit.com

DRBD(R) and LINBIT(R) are registered trademarks of LINBIT, Austria.
