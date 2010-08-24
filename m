Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab0HXMxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 08:53:43 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36499 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab0HXMxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 08:53:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=xFFkApiMroV+U+zAQLcggBa1A+9W+lAF8Kc881YFQo5qgPYKBJ+V1w8oInGtNTlJrV
         mLOoR5IIQcD1liXWew7hbG1B3PHL2h3WVQoDUYf62wF5DxiGoNoky4e2fQn3FLhF3BsC
         QfP/3mTeooe9Hh+9qokLzbo95fVuCKeOK7cjM=
Subject: Re: [PATCH 2/2] drivers/mtd/ubi: Eliminate update of
 list_for_each_entry loop cursor
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Julia Lawall <julia@diku.dk>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.1008071109140.5821@ask.diku.dk>
References: <Pine.LNX.4.64.1008071109140.5821@ask.diku.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Aug 2010 15:52:12 +0300
Message-ID: <1282654332.24044.170.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-08-07 at 11:09 +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> list_for_each_entry uses its first argument to move from one element to the
> next, so modifying it can break the iteration.  The variable re1 is already
> used within the loop as a temporary variable, and is not live here.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @r@
> iterator name list_for_each_entry;
> expression x,E;
> position p1,p2;
> @@
> 
> list_for_each_entry@p1(x,...) { <... x =@p2 E ...> }
> 
> @@
> expression x,E;
> position r.p1,r.p2;
> statement S;
> @@
> 
> *x =@p2 E
> ...
> list_for_each_entry@p1(x,...) S
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Pushed to ubi-2.6.git tree. This won't be seen in linux-next for some
time though, but I'll make it visible in linux-next at some point soon.

Thanks!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

