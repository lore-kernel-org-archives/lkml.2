Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933301Ab1ESPJZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 11:09:25 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:33444
	"EHLO CH1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932238Ab1ESPJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 11:09:22 -0400
X-SpamScore: -3
X-BigFish: VS-3(zz98dKzz1202hzz8275dhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4DD5329C.2040200@freescale.com>
Date: Thu, 19 May 2011 10:09:16 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20110429 Fedora/2.0.14-1.fc13 SeaMonkey/2.0.14
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <kumar.gala@freescale.com>, <benh@kernel.crashing.org>, <greg@kroah.com>,
        <akpm@kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-console@vger.kernel.org>
Subject: Re: [PATCH 6/7] tty/powerpc: introduce the ePAPR embedded hypervisor
 byte channel driver
References: <1305813272-31826-1-git-send-email-timur@freescale.com> <1305813272-31826-7-git-send-email-timur@freescale.com> <201105191702.39919.arnd@arndb.de>
In-Reply-To: <201105191702.39919.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> Why is this using a full tty driver instead of the hvc framework that most
> other hypervisor consoles use?

Because HVC uses the same interface for consoles and tty, and that resulted in
dropped characters if the client driver returns EAGAIN because it's output
buffer is full.  I posted a patch that "fixes" this, but it was rejected.
Here's the original patch:

http://lists.ozlabs.org/pipermail/linuxppc-dev/2010-August/085136.html

And here's the thread discussing our concerns:

http://lists.ozlabs.org/pipermail/linuxppc-dev/2010-September/thread.html

(search for "fix dropping of characters when output byte channel is full")

-- 
Timur Tabi
Linux kernel developer at Freescale

