Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804Ab1LSFpU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 00:45:20 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:33109 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab1LSFpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 00:45:17 -0500
Date: Sun, 18 Dec 2011 23:42:57 -0600
From: David Fries <david@fries.net>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Istvan Varga <istvan_v@mailbox.hu>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Darron Broad <darron@kewl.org>,
        Steven Toth <stoth@kernellabs.com>
Subject: Re: [PATCH] cx88-dvb avoid dangling core->gate_ctrl pointer
Message-ID: <20111219054257.GF3298@spacedout.fries.net>
References: <20111215055920.GA3948@spacedout.fries.net>
 <20111218094859.GA8243@elie.hsd1.il.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111218094859.GA8243@elie.hsd1.il.comcast.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.7 (SpacedOut.fries.net [127.0.0.1]); Sun, 18 Dec 2011 23:43:01 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 18, 2011 at 03:48:59AM -0600, Jonathan Nieder wrote:
> Hi David,
> 
> David Fries wrote:
> 
> > DVB: registering new adapter (cx88[0])
> > DVB: registering adapter 0 frontend 0 (Oren OR51132 VSB/QAM Frontend)...
> > cx88[0]: videobuf_dvb_register_frontend failed (errno = -12)
> > cx88[0]/2: dvb_register failed (err = -12)
> > cx88[0]/2: cx8802 probe failed, err = -12
> 
> Is CONFIG_DVB_NET enabled?  If not, does reverting fcc8e7d8c0e2
> (dvb_net: Simplify the code if DVB NET is not defined, 2011-06-01)
> help?
> 
> Thanks,
> Jonathan

I had CONFIG_DVB_NET disabled, as a desktop system I didn't think
there was any need for it.  I tested with and without reverting
fcc8e7d8c0e2 and with and without CONFIG_DVB_NET enabled.  It always
worked if CONFIG_DVB_NET is enabled, it only works if CONFIG_DVB_NET
is disabled if fcc8e7d8c0e2 is reverted.  Thanks for the tip, you
saved me a whole lot of time trying to track down what was broken.

-- 
David Fries <david@fries.net>    PGP pub CB1EE8F0
http://fries.net/~david/
