Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab2G1BF5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 21:05:57 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:48584 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751259Ab2G1BF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 21:05:56 -0400
X-Sasl-enc: fWrcDTirMjWrWPf8zhbscWjbEcPBEH4GMS0bCDAWAP3c 1343437555
Date: Fri, 27 Jul 2012 22:05:48 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, padovan@profusion.mobi, marcel@holtmann.org,
        peterz@infradead.org, mingo@redhat.com, davem@davemloft.net,
        dougthompson@xmission.com, ibm-acpi@hmh.eng.br, cbou@mail.ru,
        rui.zhang@intel.com, Jens Axboe <axboe@kernel.dk>,
        Jiri Kosina <jkosina@suse.cz>, David Airlie <airlied@linux.ie>,
        Roland Dreier <roland@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Len Brown <len.brown@intel.com>, David Howells <dhowells@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 14/15] workqueue: use mod_delayed_work() instead of
 cancel + queue
Message-ID: <20120728010548.GA7874@khazad-dum.debian.net>
References: <1343433308-26614-1-git-send-email-tj@kernel.org>
 <1343433308-26614-15-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343433308-26614-15-git-send-email-tj@kernel.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2012, Tejun Heo wrote:
> Convert delayed_work users doing [__]cancel_delayed_work() +
> queue_delayed_work() to mod_delayed_work().
> 
> Most conversions are straight-forward.  Ones worth mentioning are,
> 
> * drivers/edac/edac_mc.c: edac_mc_workq_setup() converted to always
>   use mod_delayed_work() and cancel loop in
>   edac_mc_reset_delay_period() is dropped.
> 
> * drivers/platform/x86/thinkpad_acpi.c: No need to remember whether
>   watchdog is active or not.  @fan_watchdog_active and related code
>   dropped.

For the thinkpad_acpi.c part:
Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
