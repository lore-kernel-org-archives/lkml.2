Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652Ab0IFIS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 04:18:26 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56302 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab0IFISY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 04:18:24 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 6 Sep 2010 17:13:07 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Ondrej Zary <linux@rainbow-software.org>,
        Andrea Gelmini <andrea.gelmini@gmail.com>,
        Balbir Singh <balbir@in.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Nigel Cunningham <nigel@tuxonice.net>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] swap: revert special hibernation allocation
Message-Id: <20100906171307.9e8d9637.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.LSU.2.00.1009060104410.13600@sister.anvils>
References: <alpine.LSU.2.00.1009060104410.13600@sister.anvils>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Sep 2010 01:10:55 -0700 (PDT)
Hugh Dickins <hughd@google.com> wrote:

> Please revert 2.6.36-rc commit d2997b1042ec150616c1963b5e5e919ffd0b0ebf
> "hibernation: freeze swap at hibernation".  It complicated matters by
> adding a second swap allocation path, just for hibernation; without in
> any way fixing the issue that it was intended to address - page reclaim
> after fixing the hibernation image might free swap from a page already
> imaged as swapcache, letting its swap be reallocated to store a different
> page of the image: resulting in data corruption if the imaged page were
> freed as clean then swapped back in.  Pages freed to si->swap_map were
> still in danger of being reallocated by the alternative allocation path.
> 
> I guess it inadvertently fixed slow SSD swap allocation for hibernation,
> as reported by Nigel Cunningham: by missing out the discards that occur
> on the usual swap allocation path; but that was unintentional, and needs
> a separate fix.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: Ondrej Zary <linux@rainbow-software.org>
> Cc: Andrea Gelmini <andrea.gelmini@gmail.com>
> Cc: Balbir Singh <balbir@in.ibm.com>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Nigel Cunningham <nigel@tuxonice.net>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

