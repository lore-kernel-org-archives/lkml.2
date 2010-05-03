Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336Ab0ECSqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 14:46:48 -0400
Received: from web94905.mail.in2.yahoo.com ([203.104.17.152]:30450 "HELO
	web94905.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753782Ab0ECSqr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 14:46:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=dHxZk0De/iUaVdk9DhvDXu9gfCnXbpSvPhvsqvZf3lCeLIfVyAxOTP2W3jhsekXEj84Pw24WeWmzfQLBQ6PnlebdmTabTINisxjzFFcPVKJECsL8bM38jsDRjF3HH9t6YYeKS/jwtzJ39DpSCsWhEVus1MM/aUZcXvRLf/MGz8A=;
Message-ID: <65027.33303.qm@web94905.mail.in2.yahoo.com>
X-YMail-OSG: d0UoiggVM1nNEjzfo4iaQ5GpRvu4BVDHTOSrBVxGugTuN9M
 CwzxoCyRa5maYnyc4EzIedsRhxoJbmqzcOuCO6WuGM2qX5_Oigpn4m_QGT3E
 b.xgOiS1KZhjBE4XZVjbKU6Fp9XdhGq0Fj0zPgbXPWHNsBrn1niFn0ZhYuSg
 odwaYv7CYuG2NO6Fr1O.yT0_tJv5xziBBNQKpozlSY.fdvBn_Y8QeA9YSOCD
 xsS73VgDzDbMjFw_oYNfjaPOjVpDTNIoqfoVdjtp3ccvxqvI10wi1na3os7L
 tEhteAEPzVG_hVa5fgU.NysqzzFzGmg--
X-Mailer: YahooMailClassic/10.1.11 YahooMailWebService/0.8.102.267879
Date: Tue, 4 May 2010 00:16:44 +0530 (IST)
From: Pavan Savoy <pavan_savoy@yahoo.co.in>
Subject: Re: [PATCH v3] firmware_class: fix memory leak - free allocated pages
To: Tomas Winkler <tomas.winkler@intel.com>, Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20100503170449.GA31336@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Mon, 3/5/10, Greg KH <greg@kroah.com> wrote:

> From: Greg KH <greg@kroah.com>
> Subject: Re: [PATCH v3] firmware_class: fix memory leak - free allocated pages
> To: "Tomas Winkler" <tomas.winkler@intel.com>
> Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, linux-kernel@vger.kernel.org, "David Woodhouse" <dwmw2@infradead.org>, "Kay Sievers" <kay.sievers@vrfy.org>, "David Woodhouse" <David.Woodhouse@intel.com>, "Johannes Berg" <johannes@sipsolutions.net>, "Ming Lei" <tom.leiming@gmail.com>, "Catalin Marinas" <catalin.marinas@arm.com>
> Date: Monday, 3 May, 2010, 10:34 PM
> On Sun, May 02, 2010 at 11:21:21AM
> +0300, Tomas Winkler wrote:
> > From: David Woodhouse <David.Woodhouse@intel.com>
> > 
> > fix memory leak introduced by the patch 6e03a201bbe:
> > firmware: speed up request_firmware()
> > 
> > 1. vfree won't release pages there were allocated
> explicitly and mapped
> > using vmap. The memory has to be vunmap-ed and the
> pages needs
> > to be freed explicitly
> > 
> > 2. page array is moved into the 'struct
> > firmware' so that we can free it from
> release_firmware()
> > and not only in fw_dev_release()
> > 
> > The fix doesn't break the firmware load speed.
> > 
> > Cc: Johannes Berg <johannes@sipsolutions.net>
> > Cc: Greg Kroah-Hartman <gregkh@suse.de>
> > Cc: Ming Lei <tom.leiming@gmail.com>
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Singed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> > Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> > ---
> > V2: fix authorship of the patch
> > V3: fix const struct firmware breakage
> 
> Thanks, this looks much better, I've applied it now.

Sorry to bump-in the middle.
But as a user of firmware class, what should now my fw_entry structure be?
const struct firmware *fw_entry or,
struct firmware *fw_entry - without the const ..


> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


