Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423155Ab2KNRw5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 12:52:57 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:37506 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423120Ab2KNRwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 12:52:55 -0500
Date: Wed, 14 Nov 2012 18:52:18 +0100
From: Johan Hovold <jhovold@gmail.com>
To: Richard Retanubun <richardretanubun@ruggedcom.com>
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
        Tang Nguyen <TangNguyen@ruggedcom.com>,
        linux-usb mailing list <linux-usb@vger.kernel.org>,
        stable@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>
Subject: Re: kmemleak report on isp1763 and sierra MC8705
Message-ID: <20121114175218.GA2912@localhost>
References: <Pine.LNX.4.44L0.1210291806360.31151-100000@netrider.rowland.org>
 <509D804A.7080807@ruggedcom.com>
 <CAMgPeKUPeJSKas2VOqbG+Nt5MOtdA3jUUCsFwUcDVhwDJJCr6A@mail.gmail.com>
 <50A3D0E1.4060209@ruggedcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50A3D0E1.4060209@ruggedcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 12:12:01PM -0500, Richard Retanubun wrote:
> On 10/11/12 09:30 AM, Johan Hovold wrote:
> Hi Johan,
> 
> > There was a reference-count fix for the probe error path that went in to
> > v3.5. Haven't read all the details on how you trigger your leak, but at
> > the face of it, it could be related.
> >
> > Have a look at 0658a3366db7e27fa ("usb: use usb_serial_put in
> > usb_serial_probe errors). If related, you should be seeing "Ignoring
> > blacklisted interface #n" messages when you enable debug (e.g. #define
> > DEBUG) in the sierra driver.
> 
> That was it! Thanks so much for the research.
> I can apply it cleanly to 3.0.22 and see usb_release_dev() being
> called and thus no more kmemleak.
> 
> >
> > Greg, it seems to me that the fix referred to above should be backported
> > to the earlier stable trees either way.
> I would vote "yes" for this also.
> 
> While my setup circumstances may be a corner case, (modem kept
> resetting to re-establish PPP connection) it was leaking 1192 bytes
> per occurrence.

The leak affects every failed probe, for example due to blacklisted
interfaces which is quite common, so commit 0658a3366db7 ("usb: use
usb_serial_put in usb_serial_probe errors) should be backported to the
<= 3.4 stable trees.

Thanks for reporting,
Johan
