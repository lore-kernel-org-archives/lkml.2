Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab1BTN7a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 08:59:30 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63831 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab1BTN73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 08:59:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=ail3diTVe4yO2/OcEIwZ/I0ukJ4GCmetu7KbYBI9aZXXxI2hMISl5cLmnZXIp+5uRU
         LE993PV0lKlnMiCaiCFPdipmV+Z9ISz3WozshztP3/8+d96Cb7gtxIvdOc3N6gmT4HZK
         VHm18y/YgjYQ3NX7sAbKI6qUgqU6tH81gTlKs=
Date: Sun, 20 Feb 2011 21:59:20 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: davem@davemloft.net, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, greg@kroah.com, rdunlap@xenotime.net,
        pavel@ucw.cz
Subject: Re: [PATCH] MAINTAINERS: Quote non-alphanumeric email addresses
Message-ID: <20110220135918.GB1972@gmail.com>
References: <20110210025133.GA3285@gmail.com>
 <20110209190631.f29419ef.akpm@linux-foundation.org>
 <20110209.191752.226762899.davem@davemloft.net>
 <20110219164839.GA20047@ucw.cz>
 <1298152790.7179.27.camel@Joe-Laptop>
 <AANLkTi=DbJUFfKA9EMnaUm89Fk2OEDWo64-Lu5H8Yjjv@mail.gmail.com>
 <20110220024842.GA2138@gmail.com>
 <1298177214.7179.55.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1298177214.7179.55.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 19, 2011 at 08:46:54PM -0800, Joe Perches wrote:
> Add quotes around email address with periods and commas.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> On Sun, 2011-02-20 at 10:48 +0800, Harry Wei wrote:
> > On Sun, Feb 20, 2011 at 10:38:06AM +0800, harryxiyou wrote:
> > > From: Joe Perches <joe@perches.com>
> > > On Sat, 2011-02-19 at 17:48 +0100, Pavel Machek wrote:
> > > > On Wed 2011-02-09 19:17:52, David Miller wrote:
> > > > > From: Andrew Morton <akpm@linux-foundation.org>
> > > > > > I suspect that some mail clients will explode if you provide them with
> > > > > > an unquoted string containing periods.  That would make copy-n-paste
> > > > > > rather a hassle.
> > > > > It's not clients, it's servers.
> > > > > SMTP rules state that characters such as "." cannot appear
> > > > > unquoted in email headers.
> > > > > vger.kernel.org rejects mail when this violation occurs.
> > > > Ok, but should not MUA do this quotation? Quick test shows that mutt
> > > does...
> > > My recollection is that the get_maintainer script
> > > cannot parse M: lines with multiple entries with
> > > periods without the quotes.
> > > M:      First I. Last <fil@foo.bar>, Last.I.First <lif@foo.bar>
> > > fails and
> > > M:      "First I. Last" <fil@foo.bar>, "Last.I.First" <lif@foo.bar>
> > > succeeds.
> > > You are welcome to improve the parsing in that routine.
> > In order to improve the parsing in that routine we should remove all
> > the the double-quotation-marks in the MAINTAINERS ?
> 
> No, that'd be wrong before improving parsing and
> verifying that all currently used client/MUAs work
> without quotes.
> 
> > Maybe we have other better ways?  Tell me and i will patch for us.
> 
> I think leaving the quotes is the right thing to do.
> 
> Quoting names that have non alphanumeric
> characters before any open angle bracket '<'
> is better than remove quotes.
Hmm, what about some other conditions except 
for periods and commas in maintainers' M:. 
Like following:

1> Character '-' in M:
CALGARY x86-64 IOMMU
Muli Ben-Yehuda <muli@il.ibm.com>

2> No name of the M:
M:      support@lsi.com  

3> Messy code in M:
M:      Benoît Cousson <b-cousson@ti.com>

Should we also patch for them?
Can client/MUAs work them well?

Thanks.
Best Regards.
Harry Wei.
> 
>  MAINTAINERS |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e45eabe..af586f8 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1044,7 +1044,7 @@ L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>  S:	Maintained
>  
>  ARM/TETON BGA MACHINE SUPPORT
> -M:	Mark F. Brown <mark.brown314@gmail.com>
> +M:	"Mark F. Brown" <mark.brown314@gmail.com>
>  L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>  S:	Maintained
>  
> @@ -1448,7 +1448,7 @@ F:	drivers/mtd/devices/block2mtd.c
>  
>  BLUETOOTH DRIVERS
>  M:	Marcel Holtmann <marcel@holtmann.org>
> -M:	Gustavo F. Padovan <padovan@profusion.mobi>
> +M:	"Gustavo F. Padovan" <padovan@profusion.mobi>
>  L:	linux-bluetooth@vger.kernel.org
>  W:	http://www.bluez.org/
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-2.6.git
> @@ -1457,7 +1457,7 @@ F:	drivers/bluetooth/
>  
>  BLUETOOTH SUBSYSTEM
>  M:	Marcel Holtmann <marcel@holtmann.org>
> -M:	Gustavo F. Padovan <padovan@profusion.mobi>
> +M:	"Gustavo F. Padovan" <padovan@profusion.mobi>
>  L:	linux-bluetooth@vger.kernel.org
>  W:	http://www.bluez.org/
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-2.6.git
> @@ -2909,7 +2909,7 @@ F:	Documentation/blockdev/cpqarray.txt
>  F:	drivers/block/cpqarray.*
>  
>  HEWLETT-PACKARD SMART ARRAY RAID DRIVER (hpsa)
> -M:	Stephen M. Cameron <scameron@beardog.cce.hp.com>
> +M:	"Stephen M. Cameron" <scameron@beardog.cce.hp.com>
>  L:	iss_storagedev@hp.com
>  S:	Supported
>  F:	Documentation/scsi/hpsa.txt
> @@ -4197,7 +4197,7 @@ F:	Documentation/serial/moxa-smartio
>  F:	drivers/char/mxser.*
>  
>  MSI LAPTOP SUPPORT
> -M:	Lee, Chun-Yi <jlee@novell.com>
> +M:	"Lee, Chun-Yi" <jlee@novell.com>
>  L:	platform-driver-x86@vger.kernel.org
>  S:	Maintained
>  F:	drivers/platform/x86/msi-laptop.c
> 
> 
