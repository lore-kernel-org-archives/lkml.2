Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab0DVR6A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 13:58:00 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:39274 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755147Ab0DVR56 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 13:57:58 -0400
From: "Woodruff, Richard" <r-woodruff2@ti.com>
To: Kevin Hilman <khilman@deeprootsystems.com>, Mike Chan <mike@android.com>
CC: "tony@atomide.com" <tony@atomide.com>, "paul@pwsan.com" <paul@pwsan.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 22 Apr 2010 12:57:51 -0500
Subject: RE: [PATCH 1/2] omap: pm34xx: Enable IO / IO-CHAIN wakeups for PER
Thread-Topic: [PATCH 1/2] omap: pm34xx: Enable IO / IO-CHAIN wakeups for PER
Thread-Index: AcrhsMiKK3Pr1iKAQn+M4MwWhvZKrgAjnB1A
Message-ID: <13B9B4C6EF24D648824FF11BE896716203BABB8733@dlee02.ent.ti.com>
References: <1271295665-26187-1-git-send-email-mike@android.com>
 <87aasw5oyx.fsf@deeprootsystems.com>
In-Reply-To: <87aasw5oyx.fsf@deeprootsystems.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> From: linux-omap-owner@vger.kernel.org [mailto:linux-omap-
> owner@vger.kernel.org] On Behalf Of Kevin Hilman

> I'm a little puzzled on this one.  My understanding is that the IO pad
> is only armed when CORE is in RET or OFF.

For ES3 and before the io ring wake was 'armed' when ever core went to idle.  When core power state changed accounting was done for state.

This scheme created a small time window where per wake events could be lost in handoff from gpio to io daisy chain when targeting chip off.

In ES3.1 the EN_IO_CHAIN bit was added as a way to cover this hole.  It allows enabling the wake up daisy chain in software prior to idling core.  The trm does detail the exact steps.

The 3.1 bug fix covered the transition window observed going to chip states but probably can cover here.  I'm not sure about the patch as applied with studying.

Regards,
Richard W.

