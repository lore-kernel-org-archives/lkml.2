Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933117Ab1ESQGI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 12:06:08 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:12247
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932793Ab1ESQGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 12:06:06 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4DD53FDD.7070503@freescale.com>
Date: Thu, 19 May 2011 11:05:49 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20110429 Fedora/2.0.14-1.fc13 SeaMonkey/2.0.14
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: <kumar.gala@freescale.com>, <benh@kernel.crashing.org>, <greg@kroah.com>,
        <akpm@kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-console@vger.kernel.org>
Subject: Re: [PATCH 6/7] tty/powerpc: introduce the ePAPR embedded hypervisor
 byte channel driver
References: <1305813272-31826-1-git-send-email-timur@freescale.com>	<1305813272-31826-7-git-send-email-timur@freescale.com> <20110519153358.5876f310@lxorguk.ukuu.org.uk>
In-Reply-To: <20110519153358.5876f310@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> > +		/* Pass the received data to the tty layer.  Note that this
>> > +		 * function calls tty_buffer_request_room(), so I'm not sure if
>> > +		 * we should have also called tty_buffer_request_room().
>> > +		 */
>> > +		ret = tty_insert_flip_string(ttys, buffer, len);

> You only need to request_room in advance if you can't handle the case
> where the insert_flip_string returns less than you stuffed down it.

If tty_insert_flip_string() returns less than I stuffed down it, the characters
it didn't accept will be dropped.  That's because once I receive them, I have
nowhere else to put them.  I suppose I could implement a receive FIFO, but that
seems overkill.  If calling tty_buffer_request_room() ensures that
tty_insert_flip_string() always accepts all the characters, I would rather do that.

-- 
Timur Tabi
Linux kernel developer at Freescale

