Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab3ADNLL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 08:11:11 -0500
Received: from multi.imgtec.com ([194.200.65.239]:56735 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754558Ab3ADNLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 08:11:09 -0500
Message-ID: <50E6D4EA.4090307@imgtec.com>
Date: Fri, 4 Jan 2013 13:11:06 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Arnd Bergmann" <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 22/44] metag: Time keeping
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com> <1354723742-6195-23-git-send-email-james.hogan@imgtec.com> <50E6A987.207@synopsys.com> <50E6C961.40009@imgtec.com> <50E6CF87.4070802@synopsys.com>
In-Reply-To: <50E6CF87.4070802@synopsys.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_01_04_13_11_07
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/13 12:48, Vineet Gupta wrote:
> Another question if you don't mind. In our setup we have a UART (non-standard ARC
> specific) which is wired up to the boot CPU (only). Now if the init/rcS happens to
> run on non-boot CPU, the setup/request_irq( ) and hence consequential low level
> cpu irq unmasking will only happen on *that* cpu. Now if user were to type a
> key-stroke, the interrupt will be asserted on boot-cpu, which has interrupt
> masked. How is this handled.

I'm guessing the best way would be to set the affinity of the irq from
the serial driver, and implement the irq_set_affinity callback for the
relevant irq_chip to do the necessary work, but others may have better
ideas.

Meta has something similar for output via jtag debug pod, but it doesn't
use interrupts so it has to poll from an add_timer_on()'d timer and
output from a kthread_bind()'d kthread.

Cheers
James

