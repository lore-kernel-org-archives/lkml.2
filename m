Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab1FIIeG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 04:34:06 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:55546 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab1FIIeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 04:34:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=Ifs162CbhpvZJ7B1NnTCIpXPIlknghbKsA4CohXLNsxTxzvZ/d575VapR3hwJfrYCs
         4ZnmMBMk+mN+dizmbzz9nAzn1hdzqiqGJ7EMoi02U6U/YujR8o0pQPtTKLBrDiKnNF2T
         2+9/Y8F3LKCEkqMl388bA5MYcf3TAC+g3TkcI=
Date: Thu, 9 Jun 2011 17:33:45 +0900
From: Johan Hedberg <johan.hedberg@gmail.com>
To: Waldemar.Rymarkiewicz@tieto.com
Cc: keithp@keithp.com, padovan@profusion.mobi, marcel@holtmann.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Regression caused by "Bluetooth: Map sec_level to link key
 requirements"
Message-ID: <20110609083345.GA2894@dell.ccr.corp.intel.com>
Mail-Followup-To: Waldemar.Rymarkiewicz@tieto.com, keithp@keithp.com,
	padovan@profusion.mobi, marcel@holtmann.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
References: <yunboy7a2so.fsf@aiko.keithp.com>
 <99B09243E1A5DA4898CDD8B700111448175AA2DB2A@EXMB04.eu.tieto.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99B09243E1A5DA4898CDD8B700111448175AA2DB2A@EXMB04.eu.tieto.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jun 09, 2011, Waldemar.Rymarkiewicz@tieto.com wrote:
> >Patch 13d39315c22b128f4796fc008b04914a7c32bb1a is causing a 
> >regression From 2.6.39. I cannot communicate with my Nokia 
> >N900 using either the SyncML or DUN RFCOMM services.  I get a 
> >connection reset error shortly after startup.
> >
> >I've reverted this patch on top of something past -rc2 (to be 
> >precise, I'm branching from ef2398019b305827ea7130ebaf7bf521b444530e).
> >With the following fix-up to make things build again, my 
> >bluetooth works again.
> 
> Logs from kernel and bluez would be much appreciated to see what happend.
> As I remember this was pretty well tested with BITE test by Johan.

The patch was not only fine but actually *needed* by the BITE. So
reverting it will make some qualification tests fail.

There's no DUN support in the N900 by default and the only package I'm
aware that provides it uses the command line rfcomm tool with high
security on the socket to block just-works SSP pairing (since the rfcomm
tool doesn't use the authorization framework to guarantee a user pop-up
dialog). The SyncML code I can't comment on since I haven't seen it.

So potentially this might be limited to high security sockets.
Speculating further, if the device connecting to the N900 has a pre-2.1
Bluetooth controller this could simply be about not having a 16-digit
PIN which high security services require. So could whoever is able to
reproduce the issue try repairing and entering a 16-digit PIN to see if
the problem goes away? And if this is in fact the case then the kernel
code is working exactly as it should; the only issue is that these
services should really be using medium security level instead of high.

Johan
