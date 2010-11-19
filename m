Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab0KSMRZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 07:17:25 -0500
Received: from canuck.infradead.org ([134.117.69.58]:51317 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314Ab0KSMRY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 07:17:24 -0500
Subject: Re: [PATCH v7 3/3] nl80211/mac80211: Report signal average
From: Peter Zijlstra <peterz@infradead.org>
To: Bruno Randolf <br1@einfach.org>
Cc: Bob Copeland <me@bobcopeland.com>,
        Johannes Berg <johannes@sipsolutions.net>, Jouni Malinen <j@w1.fi>,
        linville@tuxdriver.com, randy.dunlap@oracle.com, blp@cs.stanford.edu,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lars_Ericsson@telia.com, stefanr@s5r6.in-berlin.de,
        kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
        kevin.granade@gmail.com
In-Reply-To: <201011191807.06013.br1@einfach.org>
References: <20101112024901.28522.21895.stgit@localhost6.localdomain6>
	 <1290010595.3777.0.camel@jlt3.sipsolutions.net>
	 <AANLkTimoogSLAipNy=njGtHypqBQSk=usDmXut=KN9TM@mail.gmail.com>
	 <201011191807.06013.br1@einfach.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 19 Nov 2010 13:16:51 +0100
Message-ID: <1290169011.2109.1571.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-19 at 18:07 +0900, Bruno Randolf wrote:

> Hmm, maybe I suck in mathemathics, but I don't see a way to do that given the 
> formula:
> 
> (((internal * (weight - 1)) + (val * factor)) / weight

If you assume weight == 2^n, you can write that as:

(((internal << n) - internal) + (val * factor)) >> n


