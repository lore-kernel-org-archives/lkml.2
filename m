Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291Ab0JKDWq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 23:22:46 -0400
Received: from smtp101.sbc.mail.gq1.yahoo.com ([67.195.15.60]:32857 "HELO
	smtp101.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753195Ab0JKDWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 23:22:43 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Oct 2010 23:22:43 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=DKIM-Signature:Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Subject:From:To:Cc:In-Reply-To:References:Content-Type:Date:Message-ID:Mime-Version:X-Mailer:Content-Transfer-Encoding;
  b=qrRfro1bybnZABAM6uUnFRJJKbNbdt82CgUWEmJzFATbWNFA+45x/kCUUiWiSEV2IF2uy869HDo2bTqlP9GyK0lq4jwxWwrhzdpiL7SoGPktfNsfYATkHM2/rXTFZ2g8VWs7sMkwhz0a6oEZXD0IHfZ1kCHCTM6yUUKWdzfINVk=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: J71vJQ8VM1kTU1f_JClXW8d7gafSHnRSuNMvphP6x.L6J_e
 ZTx0MQN9dP1C6s66p05jD0o9Kk09igSsrw9PMpuQ7iwUDXv04Bh43KnwYiF4
 YcuUibna.o6NeYRLSbCojuqiyhWh8KSW4h..Cd.oJULOyqE3xCqdKKJCU7p8
 WePV6jzPl2W2n0BcovTJGguXJNTod0mCbTU7etHkwqHnipksWw4bqmx6ztgR
 jtSg.r2G5frHF0bdJnnEqXJlh5cs6c4MozLyECibOW2wWAF0-
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [RFC/PATCH 2/2] usb:gadget: Add SuperSpeed support to the 
 Gadget Framework
From: David Brownell <david-b@pacbell.net>
To: tlinder@codeaurora.org
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Robert Lukassen <robert.lukassen@tomtom.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Fabien Chouteau <fabien.chouteau@barco.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <207c0a821ef60e21a605f0b45c2d3777.squirrel@www.codeaurora.org>
References: <1286092937-29191-1-git-send-email-tlinder@codeaurora.org>
	 <20101004072602.GB2256@xanatos>
	 <0daac081a669f0cc8e024644f223c0c2.squirrel@www.codeaurora.org>
	 <20101005181126.GB7383@xanatos>
	 <207c0a821ef60e21a605f0b45c2d3777.squirrel@www.codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Sun, 10 Oct 2010 20:06:58 -0700
Message-ID: <1286766418.2008.230.camel@helium>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Ok.  I suppose whatever gadget application is being used can reset these
> > values later?  So that if you had a gadget webcam, it could set the
> > wMaxPacketSize to the frame size or whatever it needed?

Yes ... in fact, every altsetting or configuration may need to set up
each endpoint differently ... that's why ep_enable() passes full
endpoint configs (as descriptors), so they can more easily be changed.

If the notion is that there are values that may need to get passed from
silicon to driver, I'd like to see that done explicitly, with drivers
updating descriptors, instead of doing anything by back-door routes
that make UDC drivers making hidden updates.

- Dave


