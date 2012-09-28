Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422667Ab2I1T5B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:57:01 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:58764 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964849Ab2I1T4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:56:49 -0400
Date: Fri, 28 Sep 2012 12:54:07 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH 30/57] power: ab8500: Flush & sync all works
Message-ID: <20120928195407.GB28243@lizard>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
 <1348589574-25655-31-git-send-email-mathieu.poirier@linaro.org>
 <20120927072358.GL8836@lizard>
 <5065EC33.90109@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5065EC33.90109@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 12:28:03PM -0600, Mathieu Poirier wrote:
[...]
> >> +	flush_delayed_work_sync(&di->attach_work);
> >> +	flush_delayed_work_sync(&di->usb_charger_attached_work);
> >> +	flush_delayed_work_sync(&di->ac_charger_attached_work);
> >> +	flush_delayed_work_sync(&di->check_usbchgnotok_work);
> >> +	flush_delayed_work_sync(&di->check_vbat_work);
> >> +	flush_delayed_work_sync(&di->kick_wd_work);
> >> +
> >> +	flush_work_sync(&di->usb_link_status_work);
> >> +	flush_work_sync(&di->ac_work);
> >> +	flush_work_sync(&di->detect_usb_type_work);
> > 
> > I belive each of these have to be added by the patches that add the
> > appropriate work structs. But really, it's better to avoid these many
> > delayed work.
> 
> Agreed - on the flip side they were added over multiple patches spanning
> many centuries.  Tracking all this work down would be impossible as
> history was re-written many time over.  What would you like to see
> happening here ?

Um.. why can't we just fold

+	flush_delayed_work_sync(&di->attach_work);

Into "[PATCH 20/57] power: Adds support for legacy USB chargers"?

Then 

+	flush_delayed_work_sync(&di->usb_charger_attached_work);
+	flush_delayed_work_sync(&di->ac_charger_attached_work);

Into "[PATCH 07/57] power: ab8500_bm: Detect removed charger"

etc...

That is, at the same time you introduce the work structs, you have to
flush them appropriately.

For work structs that were already in mainline, you'll have this patch to
fixup things. But adding new code with known bugs, and then fixing them in
one go is usually not how things should be done (unless there's a good
technical reason behind this).

Thanks,
Anton.
