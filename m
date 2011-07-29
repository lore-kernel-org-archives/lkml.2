Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553Ab1G2SNj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 14:13:39 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:44929 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751282Ab1G2SNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 14:13:38 -0400
Date: Fri, 29 Jul 2011 14:13:37 -0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Breno Leitao <leitao@linux.vnet.ibm.com>
Subject: Re: Very strange data loss with jsm driver
Message-ID: <20110729181337.GM8562@caffeine.csclub.uwaterloo.ca>
References: <20110729160416.GK8562@caffeine.csclub.uwaterloo.ca>
 <20110729172736.4b199d31@lxorguk.ukuu.org.uk>
 <20110729165342.GB8566@caffeine.csclub.uwaterloo.ca>
 <20110729180650.GL8562@caffeine.csclub.uwaterloo.ca>
 <20110729191442.35d09111@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110729191442.35d09111@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 07:14:42PM +0100, Alan Cox wrote:
> > I noticed fifosize in the uart_port info is set to 16, even though the
> > fifo size is actually 64 bytes as all actual driver bits know.  What is
> > fifosize actually used for?
> 
> Only within the driver. The generic code merely knows how it as a
> configuration property but doesn't use it.

Well the driver certainly never uses that value.  I guess setserial can
poke at it, but it won't do anything with it.

I wonder how I should go about trying to figure out why the driver acts
so strangely with this particular input pattern.

It seems it can't be the tty layer, since other serial drivers seem to
work fine.  It has to be the jsm.

-- 
Len Sorensen
