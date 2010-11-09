Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab0KIUVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 15:21:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754589Ab0KIUVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 15:21:14 -0500
Subject: Re: [PATCH] fanotify: correct broken ref counting in case adding a
 mark failed
From: Eric Paris <eparis@redhat.com>
To: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20101109171816.GB14516@lsanfilippo.unix.rd.tt.avira.com>
References: <20101109171816.GB14516@lsanfilippo.unix.rd.tt.avira.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Nov 2010 15:21:11 -0500
Message-ID: <1289334071.3083.29.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-09 at 18:18 +0100, Lino Sanfilippo wrote:
> If adding a mount or inode mark failed fanotify_free_mark() is called explicitly.
>     But at this time the mark has already been put into the destroy list of the
>     fsnotify_mark kernel thread. If the thread is too slow it will try to decrease
>     the reference of a mark, that has already been freed by fanotify_free_mark().
>     (If its fast enough it will only decrease the marks ref counter from 2 to 1 - note
>     that the counter has been increased to 2 in add_mark() - which has practically no
>     effect.)
>     This patch fixes the ref counting by not calling free_mark() explicitly, but
>     decreasing the ref counter and rely on the fsnotify_mark thread to cleanup in
>     case adding the mark has failed.
> 
> Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>

applied to http://git.infradead.org/users/eparis/notify.git/ #for-next

-Eric

