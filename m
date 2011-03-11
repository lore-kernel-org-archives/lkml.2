Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660Ab1CKP1t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 10:27:49 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63212 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619Ab1CKP1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 10:27:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=nPMr624iT2REca1HZPq3gRs/qVkOfWvzuQUB5F35xxCkePBE4tqdHW2SZ8MM/EKwfT
         xQrub9BZUTMGSyKnHGymBfrDB1UJT0C45hlBz6wkcIaAuEKIi64qbtQLjvjx8Ssm8Cbp
         IWy5dsvtk67JxCc72EWPr9ax0xJj3YdV91qf4=
Subject: Re: [PATCH n_gsm] GSM Mux in non-transparent mode
From: =?ISO-8859-1?Q?M=E1rio?= Isidoro <marioisidoro@gmail.com>
To: Eric =?ISO-8859-1?Q?B=E9nard?= <eric@eukrea.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <4D7A24CF.9070805@eukrea.com>
References: <1299724790.1800.135.camel@Paio>  <4D7A24CF.9070805@eukrea.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Mar 2011 15:27:41 +0000
Message-ID: <1299857261.4444.14.camel@Paio>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric
My GE863-Pro^3 works well without it, however, without it the control
signals from the computer side do not seem to work correctly.

>From my tests, without the patch, the value in modem_tx will never
change when we send TIOCMSET commands.

By the way, can you confirm if your Telit modems respect the EA bit on
the MSC frame ? 

Thank you,

Mário Isidoro

On Fri, 2011-03-11 at 14:34 +0100, Eric Bénard wrote:
> Hi Mário,
> 
> On 10/03/2011 03:39, Mário Isidoro wrote:
> > @@ -2661,9 +2725,12 @@ static int gsmtty_tiocmset(struct tty_struct
> > *tty, struct file *filp,
> >   	struct gsm_dlci *dlci = tty->driver_data;
> >   	unsigned int modem_tx = dlci->modem_tx;
> >
> > -	modem_tx &= clear;
> > +	modem_tx &= ~clear;
> >   	modem_tx |= set;
> >
> good catch : this fix (and only this one in your patch) makes Telit modems 
> work realiable here with ppp (which was failing before).
> Tested on GC864-QUAD-V2, UC864-E and UC864-WD
> 
> Thanks !
> 
> Eric


