Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999Ab1CQSZQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 14:25:16 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50881 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794Ab1CQSZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 14:25:13 -0400
Date: Thu, 17 Mar 2011 12:25:10 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Daney <ddaney@caviumnetworks.com>, linux-serial@vger.kernel.org,
        gregkh@suse.de, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [RFC PATCH 1/2] serial: 8250: Add a notifier chain for driver
 registration.
Message-ID: <20110317182510.GN9597@angua.secretlab.ca>
References: <1300325167-26433-1-git-send-email-ddaney@caviumnetworks.com>
 <1300325167-26433-2-git-send-email-ddaney@caviumnetworks.com>
 <20110317121849.49d7c425@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110317121849.49d7c425@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 12:18:49PM +0000, Alan Cox wrote:
> On Wed, 16 Mar 2011 18:26:06 -0700
> David Daney <ddaney@caviumnetworks.com> wrote:
> 
> > The 8250 driver is a bit weird in that in addition to supporting
> > platform devices, extra devices can be added by calling
> > serial8250_register_port().
> > 
> > The problem is that if we call serial8250_register_port() before the
> > driver is initialized Bad Things happen (we dereference NULL
> > pointers).
> > 
> > There doesn't seem to be a general way to know if a driver has been
> > initialized
> 
> I've had a bigger dig into this. I think the correct answer is probably
> "always go via platform devices or similar". That *is* the notifier in
> the kernel of today. serial8250_register_port ultimately should I think
> ultimatly become an internal helper.

+1

Depending on serial8250_register_port() definitely the wrong thing to
do for platform support code.  It would be better to figure out how to
get the dt bits you need into 8250.c or of_serial.c.

g.

