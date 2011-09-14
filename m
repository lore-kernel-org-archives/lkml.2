Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342Ab1INSir (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 14:38:47 -0400
Received: from void.printf.net ([89.145.121.20]:48380 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757299Ab1INSiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 14:38:46 -0400
From: Chris Ball <cjb@laptop.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Philip Rakity <prakity@marvell.com>,
        "linux-mmc\@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Manoj Iyer <manoj.iyer@canonical.com>
Subject: Re: SDHCI regression since 2.6.39
References: <4E6EA3E4.5080401@goop.org> <m2bouo37by.fsf@bob.laptop.org>
	<4E6F8C24.3090207@goop.org> <m2wrdc1i5b.fsf@bob.laptop.org>
	<4E6FA44F.1050705@goop.org> <m2aaa89t1m.fsf@bob.laptop.org>
	<alpine.DEB.2.02.1109131419430.3556@lazy> <4E6FBCA1.6040307@goop.org>
	<D45CBF70-F0B1-453A-9E31-A621F52C21B9@marvell.com>
	<4E6FC422.9080306@goop.org>
	<7C3ED924-555D-4C50-9000-36077650328C@marvell.com>
	<4E6FCE28.5040403@goop.org>
	<F54ECF19-5E4C-40A6-8E26-99BF223F9FE2@marvell.com>
	<4E6FDA0B.9060007@goop.org> <4E6FDC3E.8030702@goop.org>
	<003A4041-99F9-4598-AB9A-D08C76CDAECB@marvell.com>
	<4E6FFADE.5090004@goop.org> <m2k49b9qvu.fsf@bob.laptop.org>
	<4E70D62B.2030007@goop.org>
Date: Wed, 14 Sep 2011 14:38:38 -0400
In-Reply-To: <4E70D62B.2030007@goop.org> (Jeremy Fitzhardinge's message of
	"Wed, 14 Sep 2011 09:28:27 -0700")
Message-ID: <m2boun9dg1.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Sep 14 2011, Jeremy Fitzhardinge wrote:
> I powered it off with battery unplugged for about an hour, and rebooted
> into the known-working kernel, making sure that any fancy power mgmt
> features were disabled (like aspm), but it still failed in the same way.
>
> I'm wondering if it's simply something like the socket has failed, and
> one or more of the terminals isn't connecting to the card?  Though that
> would only show problems on card insertion, but I gather the driver is
> having problems from the moment it detects the controller?

I don't think it's true that we're having any problems talking to the
controller other than with a card inserted -- do you see any errors in
dmesg before inserting a card?

It could indeed be some kind of signal integrity issue.  The easy way to
investigate that would be to boot Windows and see if it works there, and
the hard way would be to find a friendly hardware hacker with a nice scope.

(In your dmesg with debug turned on, all we see is the card no longer
responding to any command: "mmc0: req done (CMD18): -110: 00000000
00000000 00000000 00000000" where -110 is ETIMEDOUT, and in your
original mail we also see some -84, EILSEQ, which is either the
controller raising a CRC error -- suggesting a bad physical connection
or poor signal quality -- or responding with data out of sequence.  You
could find out which by instrumenting sdhci.c's "error = -EILSEQ" lines
with printks, but it's probably not practically useful to know.)

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
