Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229Ab2ADWh5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 17:37:57 -0500
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:35918 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757177Ab2ADWhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 17:37:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=date:from:to:cc
	:subject:message-id:references:mime-version:content-type
	:in-reply-to; q=dns; s=sasl; b=MH1qNdt2q3qO+M+BPUjW1mlh19UTUnEfE
	u/hIP+tpBnrABWZAN7jWR4/UKGa1yga7ytJMY6OzBpxSrwApNFNgw+h5dQCLkxcj
	iZxIR6mgGctzsfe423umH7HxuSi5IlIBlOjjt2OQwTVKasEpvfh8DjmGMTFYEL3t
	nOEyb1GPew=
Date: Wed, 4 Jan 2012 16:37:53 -0600
From: Chris Elmquist <chrise@pobox.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: serial ports now asserting DTR and RTS during boot; breaks
 connected hardware
Message-ID: <20120104223752.GA1149@n0jcf.net>
References: <20120103153707.GA12771@redhat.com>
 <20120103160655.69107c93@pyramind.ukuu.org.uk> <4F04BC85.9060803@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F04BC85.9060803@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Pobox-Relay-ID: BD999EBC-3724-11E1-82BC-9DB42E706CDE-00683243!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday (01/04/2012 at 09:54PM +0100), Jiri Slaby wrote:
> >> Jiri,
> >> We got this report from a user who notes a change in behaviour for
> >> his serial hardware over the last few kernel versions.
> >>  
> >> https://bugzilla.redhat.com/show_bug.cgi?id=771010
> >>
> >> This sounds like it might be related to your DTR/RTS changes back in March 2011 maybe ? 
> > 
> > Looks like your userspace to me at first glance.
> > 
> > ftdi_sio sets up the modem lines in set_termios. Set_termios is called
> > from ftdi_open. ftdi_open is triggered by userspace.
> > 
> >>  > The following code in the ftdi_sio driver is one suspect but this behavior
> >>  > happens on 8250 UARTs also so it is systemic now,
> > 
> > Likewise 8250 sets up the lines in serial8250_startup. This is called via
> > uart_startup which is called via open.
> 
> Ok, let's apply the cut&paste rule. Does uninstalling ModemManager fix
> the issue?

I'm going with 'cut' :-)

Indeed, removing ModemManager fixes the issue.  I removed it, rebooted,
and on an 8250 UART port, I never saw DTR or RTS assert during boot.

I'm not currently able to verify on an FTDI interface as I had a hardware
failure that has taken it offline (this is the actual radio interface that
was originally affected) but I will verify that soon once the hardware is
back online.

Note that if you 'yum remove' ModemManager it wants to take NetworkManager
out with it due to dependancy... which doesn't seem cool.  I removed it
with 'rpm' and --nodeps.  Probably better to disable it the correct way
which I am still learning due to the systemd/chkconfig changeover which has
slowed me down a bit.

Thanks guys.  I think this will resolve the issue for me once I verify on
FTDI hardware.

Chris

-- 
Chris Elmquist

