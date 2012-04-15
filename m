Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab2DOXJU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 19:09:20 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:28416 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab2DOXJT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 19:09:19 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 6/6] tilegx network driver: initial support
Thread-Topic: [PATCH 6/6] tilegx network driver: initial support
Thread-Index: AQHNFlepET0l5ZukJ0iSfaweoi+rjJaTA2kAgAEgQoCACGhfgQ==
Date: Sun, 15 Apr 2012 23:06:17 +0000
Message-ID: <9D6CA7A63751804FADD8B075304A6858109A5B47@USMAExch1.tad.internal.tilera.com>
References: <201204062059.q36KxjEO011317@farm-0027.internal.tilera.com>
 <201204091349.54484.arnd@arndb.de>
 <4F835510.4060100@tilera.com>,<201204101042.39877.arnd@arndb.de>
In-Reply-To: <201204101042.39877.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> > We need "tile_net_devs_for_channel" because we share a single hardware
> > queue for all devices, and each packet's metadata contains a "channel"
> > value which indicates the device.
> 
> Ok, but please remove tile_net_devs then.

I spent some time on Friday with the driver author and we made some good changes, switching over to using more of a per-channel model for everything. We also removed the per-cpu per-driver stats structures and just use atomics to update the per-driver stats directly.  The upshot is a much cleaner set of data structures, but unfortunately we didn't have time to work all the way through the ramifications before the weekend, and I'm out next week for spring school vacation.

Thanks again for the feedback!

Chris Metcalf