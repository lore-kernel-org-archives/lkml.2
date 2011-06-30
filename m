Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab1F3NKd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 09:10:33 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:38454 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751211Ab1F3NK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 09:10:26 -0400
X-Sasl-enc: qUPNLK3p2n5V3kViiJq/JuDKuL2x+hrLp5JnWI+pC3H1 1309439424
Message-ID: <4E0C75BD.1050103@ladisch.de>
Date: Thu, 30 Jun 2011 15:10:21 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: Takashi Iwai <tiwai@suse.de>, linux-arch@vger.kernel.org,
        linux-mips@linux-mips.org, alsa-devel@alsa-project.org,
        florian@linux-mips.org, "David S. Miller" <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>, sparclinux@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Matt Turner <mattst88@gmail.com>,
        Florian Fainelli <florian@openwrt.org>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [alsa-devel] SB16 build error.
References: <20110630091754.GA12119@linux-mips.org>	<s5h8vsjy68z.wl%tiwai@suse.de> <20110630105254.GA25732@linux-mips.org>
In-Reply-To: <20110630105254.GA25732@linux-mips.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ralf Baechle wrote:
> I have no idea how big the soundblaster microcode being loaded actually is,
> that is if the reduced size of 0x1f00 will be sufficient.

The biggest file is WFM0001A.CSP with 0x2df0 bytes.

> I don't see how the old ioctl can possibly have been
> used before so there isn't a compatibility problem.

The code uses SNDRV_SB_CSP_MAX_MICROCODE_FILE_SIZE but doesn't care what
the size field of the ioctl code is, so we could use any random value on
those architectures.

> Or you could entirely sidestep the problem and use request_firmware()
> but I guess that's more effort than you want to invest.

The driver already implements this for a bunch of predefined CSP code
blobs.  I'm not sure whether anybody has ever loaded additional .csp
files.


Regards,
Clemens
