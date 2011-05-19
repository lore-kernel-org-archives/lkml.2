Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933546Ab1ESQb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 12:31:57 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:4060
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932238Ab1ESQb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 12:31:56 -0400
X-SpamScore: -3
X-BigFish: VS-3(zz98dKzz1202hzzz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4DD545E4.9090408@freescale.com>
Date: Thu, 19 May 2011 11:31:32 -0500
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
> You really also need a hangup method so vhangup() does the right thing
> and you can securely do logins etc and sessions on your console. As
> you've got no hardware entangled in this and you already use tty_port
> helpers the hangup helper will do the work for you.

So all I need is this?

static void ehv_bc_tty_hangup(struct tty_struct *ttys)
{
	struct ehv_bc_data *bc = ttys->driver_data;

	tty_port_hangup(&bc->port);
}

I've noticed that some drivers flush their transmit buffers before calling
tty_port_hangup(), but some others don't.  Should I do this too?  I don't know
if hangup should be as quick as possible.

-- 
Timur Tabi
Linux kernel developer at Freescale

