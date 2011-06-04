Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab1FDVzA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 17:55:00 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57738 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364Ab1FDVy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 17:54:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=OoQbfyjJF8ruu2pTN4qaVGEyWnk1Y0ax4MxoYJ/PiApyJi6wz5THEHUR3Igwyfi8K2
         M0cjJsL5t/ILIUKIBuEmFUwe1C9w0EDe5JUkRTvnNq9h51BF6ZVomuS5DXySQWQr0VUL
         /jEnUJjtJbAgzePSV+Q1fcBW9E0c2tzdYlH9s=
Date: Sat, 4 Jun 2011 23:54:49 +0200
From: Andre Bartke <andre.bartke@googlemail.com>
To: "Michal Nazarewicz" <mina86@mina86.com>
Cc: "Andre Bartke" <andre.bartke@googlemail.com>, gregkh@suse.de,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/usb/gadget: add missing kfree calls
Message-ID: <20110604235449.6a00218c@kvasir>
In-Reply-To: <op.vwkl82ut3l0zgt@mnazarewicz-glaptop>
References: <1307216094-13570-1-git-send-email-andre.bartke@gmail.com>
	<op.vwkl82ut3l0zgt@mnazarewicz-glaptop>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 04 Jun 2011 23:35:16 +0200
"Michal Nazarewicz" <mina86@mina86.com> wrote:

> On Sat, 04 Jun 2011 21:34:54 +0200, Andre Bartke  
> <andre.bartke@googlemail.com> wrote:
> > diff --git a/drivers/usb/gadget/rndis.c b/drivers/usb/gadget/rndis.c
> > @@ -700,6 +701,7 @@ static int rndis_reset_response(int configNr,  
> > rndis_reset_msg_type *buf)
> >  	resp->AddressingReset = cpu_to_le32(1);
> > 	params->resp_avail(params->v);
> > +	kfree(r);
> >  	return 0;
> >  }
> 
> Have you tested this?  It does not look right to me.
> rndis_add_response() allocates memory and puts the request on a
> list.  It is later freed in rndis_free_response().
> 

Nope, the only way I can test this is a build - which it does.
You might be right though.
