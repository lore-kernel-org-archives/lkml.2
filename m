Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab2JKMe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 08:34:27 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54978 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758Ab2JKMeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 08:34:21 -0400
Date: Thu, 11 Oct 2012 13:34:15 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: =?iso-8859-1?Q?Trep=E1k?= Vilmos <trepo@netcomga.sk>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Platform: hp-wmi: add rfkill support for integrated GPS
Message-ID: <20121011123415.GA6056@srcf.ucam.org>
References: <1349952660.1577.43.camel@pluto.netcomga.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1349952660.1577.43.camel@pluto.netcomga.sk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 12:51:00PM +0200, Trepák Vilmos wrote:
> @@ -663,6 +669,24 @@ static int __devinit hp_wmi_rfkill_setup
>  			goto register_bluetooth_error;
>  	}
>  
> +	if (wireless & 0x3) {
> +		gps_rfkill = rfkill_alloc("hp-gps", &device->dev,
> +						RFKILL_TYPE_GPS,
> +						&hp_wmi_rfkill_ops,
> +						(void *) HPWMI_GPS);

I don't think this bit is right - in this codepath, wireless is a mask, 
so 0x3 would mean wifi and bluetooth, not gps. I'd expect gps to be 0x8. 
The rest looks good, though.


-- 
Matthew Garrett | mjg59@srcf.ucam.org
