Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab0KIUVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 15:21:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63686 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911Ab0KIUVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 15:21:49 -0500
Subject: Re: [PATCH] fanotify: Do check against max_marks and increase
 number of group marks atomically
From: Eric Paris <eparis@redhat.com>
To: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20101109181904.GB5867@lsanfilippo.unix.rd.tt.avira.com>
References: <20101109181904.GB5867@lsanfilippo.unix.rd.tt.avira.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Nov 2010 15:21:45 -0500
Message-ID: <1289334105.3083.30.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-09 at 19:19 +0100, Lino Sanfilippo wrote:
> The number of group marks is checked against max_marks and increased afterwards
>     in a non atomic way. This may result in 2 or more processes passing the check
>     at the same time and increasing the number of group marks above the max_marks
>     limit afterwards.
>     With this patch the check against max_marks is done in fsnotify_add_mark(),
>     after the group lock has been aquired to ensure that concurrent processes
>     cant exceed the group marks limit.
> 
> Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>

applied to http://git.infradead.org/users/eparis/notify.git/ #for-next

-Eric

