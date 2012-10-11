Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758620Ab2JKNPu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 09:15:50 -0400
Received: from mail.netcomga.sk ([217.118.103.2]:39026 "EHLO netcomga.sk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756353Ab2JKNPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 09:15:47 -0400
Message-ID: <1349961347.29045.8.camel@pluto.netcomga.sk>
Subject: Re: [PATCH] Platform: hp-wmi: add rfkill support for integrated GPS
From: =?ISO-8859-1?Q?Trep=E1k?= Vilmos <trepo@netcomga.sk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 11 Oct 2012 15:15:47 +0200
In-Reply-To: <20121011123415.GA6056@srcf.ucam.org>
References: <1349952660.1577.43.camel@pluto.netcomga.sk>
	 <20121011123415.GA6056@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-11 at 13:34 +0100, Matthew Garrett wrote:
> On Thu, Oct 11, 2012 at 12:51:00PM +0200, Trepák Vilmos wrote:
> > @@ -663,6 +669,24 @@ static int __devinit hp_wmi_rfkill_setup
> >  			goto register_bluetooth_error;
> >  	}
> >  
> > +	if (wireless & 0x3) {
> > +		gps_rfkill = rfkill_alloc("hp-gps", &device->dev,
> > +						RFKILL_TYPE_GPS,
> > +						&hp_wmi_rfkill_ops,
> > +						(void *) HPWMI_GPS);
> 
> I don't think this bit is right - in this codepath, wireless is a mask, 
> so 0x3 would mean wifi and bluetooth, not gps. I'd expect gps to be 0x8.

And you'd expect right. Re-tested with 0x8, it works.

>  
> The rest looks good, though.
> 

Of course it does, it's just copy & paste & replace... I don't even
think I deserve credit for it.

Is it worth it to resubmit the patch for a 1-byte change or will you
just take care of it yourself? If it's easier for you, I'll resubmit.


-- 
Trepák Vilmos <trepo@netcomga.sk>

