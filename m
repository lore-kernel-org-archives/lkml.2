Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235Ab0FIKWL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 06:22:11 -0400
Received: from web94915.mail.in2.yahoo.com ([203.104.17.192]:35176 "HELO
	web94915.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751677Ab0FIKWI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 06:22:08 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Jun 2010 06:22:07 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=NGuOpfTexzDaRLKVRQQFlySBWqtOM2Kc6stWd/81LdG0SuQvsXkhFkDs4ZYdkAMaPQBlbW3EW1qE8z9NZ4A5QfB4kNRLVCdcoluik71nMl82zBiBEsxGlHIwNcTYmwxOZ+WG0GdwqG2UP186af4Ofmd+MwtD+hhLmx1uqPNzLws=;
Message-ID: <899595.96336.qm@web94915.mail.in2.yahoo.com>
X-YMail-OSG: Be7S6lkVM1l_tSh5TCLXNvpMH4uavX12geoyJpESE4Kqrq_
 fC9bfi_8tjSJ.fHaBCYDRIYsD7YUqBAs3qV9Js_4hK.nEwf7YgxUuLT7Qs4T
 oJEaH8URcaVLQWFsQll.SNxUfCtLdv4xwaE1JKQgulJATP8NWR4W3TBVPCmI
 0q6xGAEL_NfhPWyTqyE3EEt8lxWesgsunnsA1ZpiLXNQj1O3PQroKekFKKFz
 quWbMwcBVwd1dNBm8FFRw4M8d7UVWxjRs6FXYSX1cXZiGk_DOITyLAnboLr.
 4epvcVYElbQDEOlGNbomT.kvxjEQJ
X-Mailer: YahooMailClassic/11.1.3 YahooMailWebService/0.8.103.269680
Date: Wed, 9 Jun 2010 15:45:23 +0530 (IST)
From: Pavan Savoy <pavan_savoy@yahoo.co.in>
Subject: rfkill switch state during suspend?
To: Johannes Berg <johannes@sipsolutions.net>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20100326065803.GD26602@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I remember in 2.6.29, the rfkill switch state during suspend was set to SOFT_BLOCKED by calling the toggle_radio of rfkill drivers.

What happens now ? 2.6.32+ ... ?

This previously posed a problems to drivers which mapped their chip enable GPIOs to the rfkill entries, because on suspend, the gpio was pulled low because of the SOFT_BLOCKED state.

A couple of lines regarding same in Documentation/rfkill.txt would be ideal too.

Thanks in advance.
Pavan Savoy.


--- On Fri, 26/3/10, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Subject: Re: [PATCH] rfkill: core: add custom rfkill switch
> To: "Johannes Berg" <johannes@sipsolutions.net>
> Cc: "Pavan Savoy" <pavan_savoy@yahoo.co.in>
> Date: Friday, 26 March, 2010, 12:28 PM
> On Thu, Mar 25, 2010 at 11:39:10PM
> -0700, Johannes Berg wrote:
> > On Thu, 2010-03-25 at 23:23 -0700, Dmitry Torokhov
> wrote:
> > 
> > > > I do have an actual driver it's just that
> all 3 cores are controlled
> > > > by 1 chip_enable and individual cores are
> powered up down by s/w
> > > > commands.
> > > > 
> > > 
> > > Hmm, so the main portion of the driver needs to
> count the number of
> > > active users across rfkill interfaces 
> before powering down the chip. I
> > > do not quite understand what the issue is
> here...
> > 
> > He also wants to (ab)use rfkill to signal to userspace
> what the value of
> > that counter is ...
> > 
> 
> Well, this one is easy - just say 'No' ;)
> 
> -- 
> Dmitry
> 


