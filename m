Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932833Ab0EDOhi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 10:37:38 -0400
Received: from web94909.mail.in2.yahoo.com ([203.104.17.168]:27483 "HELO
	web94909.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932313Ab0EDOhh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 10:37:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=FYjpwPR7E2ik1pChg251Y9zso8QkQUVfqBbLA+/KX189wbVSTW/84X3yrPv6f6rvykFuvgMdffvnnqR2Heg8HwqjokxBmRSf1S3U6jOr71WbWUeHHm0LJdaQYu7x7sVDVOSF/7MQNmqPn3EtoCOgrTxYKmFZzYflimHy/TLc/us=;
Message-ID: <698815.43605.qm@web94909.mail.in2.yahoo.com>
X-YMail-OSG: gmuBGvcVM1kkD4k92MQZIscGvAyoqmNgHDwR2mv7Bv0fgzp
 XUJ3MNr57oar3AOfm0axli0mZiqQYC1eUkkirY28fIsVAcYn50w9gwhBQ8pD
 swYKedRTadnPnAdM2pdbcMbX1oIM7WVeFybsflJU0Due.jb2TaiGSdIo5d_h
 WFaj4EiKKpogDoUQrdiNyfuv8JuFMbmYLKNmJ0hzQCVu9nPd4dg0n.kB.OSR
 dj8O9qatstXLcqE59Ex1VOUHw2e2h1dHHuV0KOaJmaMoIgS.O8DfDu8X8867
 6Yiobts3K5feVOZlV
X-Mailer: YahooMailClassic/10.1.11 YahooMailWebService/0.8.103.269680
Date: Tue, 4 May 2010 20:07:33 +0530 (IST)
From: Pavan Savoy <pavan_savoy@yahoo.co.in>
Subject: Re: [PATCH v3] firmware_class: fix memory leak - free allocated pages
To: Greg KH <greg@kroah.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20100504140336.GA32393@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- On Tue, 4/5/10, Greg KH <greg@kroah.com> wrote:

> From: Greg KH <greg@kroah.com>
> Subject: Re: [PATCH v3] firmware_class: fix memory leak - free allocated pages
> To: "Pavan Savoy" <pavan_savoy@yahoo.co.in>
> Cc: "Tomas Winkler" <tomas.winkler@intel.com>, linux-kernel@vger.kernel.org
> Date: Tuesday, 4 May, 2010, 7:33 PM
> On Tue, May 04, 2010 at 12:16:44AM
> +0530, Pavan Savoy wrote:
> > 
> > 
> > --- On Mon, 3/5/10, Greg KH <greg@kroah.com>
> wrote:
> > 
> > > From: Greg KH <greg@kroah.com>
> > > Subject: Re: [PATCH v3] firmware_class: fix
> memory leak - free allocated pages
> > > To: "Tomas Winkler" <tomas.winkler@intel.com>
> > > Cc: "Greg Kroah-Hartman" <gregkh@suse.de>,
> linux-kernel@vger.kernel.org,
> "David Woodhouse" <dwmw2@infradead.org>,
> "Kay Sievers" <kay.sievers@vrfy.org>,
> "David Woodhouse" <David.Woodhouse@intel.com>,
> "Johannes Berg" <johannes@sipsolutions.net>,
> "Ming Lei" <tom.leiming@gmail.com>,
> "Catalin Marinas" <catalin.marinas@arm.com>
> > > Date: Monday, 3 May, 2010, 10:34 PM
> > > On Sun, May 02, 2010 at 11:21:21AM
> > > +0300, Tomas Winkler wrote:
> > > > From: David Woodhouse <David.Woodhouse@intel.com>
> > > > 
> > > > fix memory leak introduced by the patch
> 6e03a201bbe:
> > > > firmware: speed up request_firmware()
> > > > 
> > > > 1. vfree won't release pages there were
> allocated
> > > explicitly and mapped
> > > > using vmap. The memory has to be vunmap-ed
> and the
> > > pages needs
> > > > to be freed explicitly
> > > > 
> > > > 2. page array is moved into the 'struct
> > > > firmware' so that we can free it from
> > > release_firmware()
> > > > and not only in fw_dev_release()
> > > > 
> > > > The fix doesn't break the firmware load
> speed.
> > > > 
> > > > Cc: Johannes Berg <johannes@sipsolutions.net>
> > > > Cc: Greg Kroah-Hartman <gregkh@suse.de>
> > > > Cc: Ming Lei <tom.leiming@gmail.com>
> > > > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > > > Singed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> > > > Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> > > > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> > > > ---
> > > > V2: fix authorship of the patch
> > > > V3: fix const struct firmware breakage
> > > 
> > > Thanks, this looks much better, I've applied it
> now.
> > 
> > Sorry to bump-in the middle.
> > But as a user of firmware class, what should now my
> fw_entry structure be?
> > const struct firmware *fw_entry or,
> > struct firmware *fw_entry - without the const ..
> 
> You should leave it to be whatever it was before this
> patch, it has not
> changed anything now.

Ok, However this patch has changed the release_firmware,
-release_firmware(const struct firmware *fw)
+release_firmware(struct firmware *fw)


> thanks,
> 
> greg k-h
> 


