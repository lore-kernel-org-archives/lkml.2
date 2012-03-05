Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757771Ab2CEUyH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 15:54:07 -0500
Received: from mxout1.idt.com ([157.165.5.25]:45504 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757730Ab2CEUyF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 15:54:05 -0500
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "Kim, Chul" <Chul.Kim@idt.com>,
        Matt Porter <mporter@kernel.crashing.org>
Subject: RE: [PATCH] rapidio/tsi721: fix bug in inbound doorbell handler
Thread-Topic: [PATCH] rapidio/tsi721: fix bug in inbound doorbell handler
Thread-Index: AQHM+w9IFZVaGHz9mUKPWaXSzcqKppZcr3wA//97UEA=
Date: Mon, 5 Mar 2012 20:53:54 +0000
Message-ID: <8D983423E7EDF846BB3056827B8CC5D101019D@corpmail1.na.ads.idt.com>
References: <1330979585-29429-1-git-send-email-alexandre.bounine@idt.com>
 <20120305123714.0750129e.akpm@linux-foundation.org>
In-Reply-To: <20120305123714.0750129e.akpm@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.165.140.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, March 05, 2012 3:37 PM Andrew Morton wrote:
> Alexandre Bounine <alexandre.bounine@idt.com> wrote:
> 
> > Fixes queue wrapping bug in Inbound Doorbell handling routine.
> 
> The changelog doesn't describe the user-visible impact of the bug.
> Please always include this so that people know whether to backport the
> fix into their kernels, and so they can determine whether the patch
> will fix a problem which they are observing.

This patch fixes the bug that causes kernel panic when number of received
doorbells is larger than number of entries in the inbound doorbell
queue (current default value = 512).
Another possible indication for this bug is large number of spurious
doorbells reported by tsi721 driver after reaching the queue size maximum.

