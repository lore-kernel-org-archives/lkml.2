Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab1JMIZo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 04:25:44 -0400
Received: from zimbra.linbit.com ([212.69.161.123]:55566 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509Ab1JMIZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 04:25:41 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [Drbd-dev] [PATCH 13/13] DRBD: Fix comparison always false warning due to long/long long compare
Date: Thu, 13 Oct 2011 10:25:24 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38-8-generic; KDE/4.6.2; i686; ; )
Cc: drbd-dev@lists.linbit.com, David Howells <dhowells@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
References: <1318422455-17539-1-git-send-email-philipp.reisner@linbit.com> <1318422455-17539-14-git-send-email-philipp.reisner@linbit.com> <CAMuHMdXGCEUGanrsyFkgyr3ZAr5YpgrjbVqJtvCu5Li6XMMDMA@mail.gmail.com>
In-Reply-To: <CAMuHMdXGCEUGanrsyFkgyr3ZAr5YpgrjbVqJtvCu5Li6XMMDMA@mail.gmail.com>
X-OTRS-FollowUp-SenderType: agent
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110131025.24950.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 12. Oktober 2011, 15:35:28 schrieb Geert Uytterhoeven:
> On Wed, Oct 12, 2011 at 14:27, Philipp Reisner
> 
> <philipp.reisner@linbit.com> wrote:
> > From: David Howells <dhowells@redhat.com>
> > 
> > Fix warnings of the following nature in the drbd header:
> > 
> > In file included from drivers/block/drbd/drbd_bitmap.c:32:
> > drivers/block/drbd/drbd_int.h: In function 'drbd_get_syncer_progress':
> > drivers/block/drbd/drbd_int.h:2234: warning: comparison is always false
> > due to limited range of data
> > 
> > where mdev->rs_total (an unsigned long) is being compared to 1ULL << 32,
> > which is always false on a 32-bit machine.
> 
> But on 32-bit, unsigned long is never larger than UINT_MAX neither, so
> it doesn't
> really change anything??
> 

Hi Geert,

As the commit message says, David's intention was to silence a compiler
warning, not to change anything.

Best,
 Phil
-- 
: Dipl-Ing Philipp Reisner
: LINBIT | Your Way to High Availability
: Tel: +43-1-8178292-50, Fax: +43-1-8178292-82
: http://www.linbit.com

DRBD(R) and LINBIT(R) are registered trademarks of LINBIT, Austria.
