Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295Ab0EDPwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 11:52:25 -0400
Received: from web94906.mail.in2.yahoo.com ([203.104.17.156]:30460 "HELO
	web94906.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754369Ab0EDPwX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 11:52:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=C4hzUrMj/PMgjNvGM3hmJe68oXFCer1DYaa0JkU5A4T3OMAIgF2eBhMyUyFX17gllkyhAcBlFDTv/8vCRDUBMvHXxRMmOc8QZWnctjB8l/VFL6Jd9I0uPBwM8Sl0rUgniKh+p+wHUwTQsbqisVOKcmr34MaqGY5zVU/GEc6seRA=;
Message-ID: <868194.36957.qm@web94906.mail.in2.yahoo.com>
X-YMail-OSG: N3q3F8gVM1n.jxqBXgFYdAd81ub6ox8HM8K_5wFLbUYAsnT
 usCssjMufhTvYl_M1TjofnwWJSVdXdv_cj0VOoK03rhNbGJZUKaCjf1Sv1XM
 Z_Vjuczmx14Pmhy7R5MyLzJ25Y43oa9F9yMFRNyLD8wiPnKbidSasU7Sne9m
 fn25Pc5d2gZAS30Bxj0E4XBWB1c9e10_KGA3krX3m.MxEgfkITn_Ui2xGT.T
 An91DctdHGAPaGVLHcsjzFh9wNk1IBeH9iiJBQmZSPHfn7g3jZ9eYSoWiN1K
 hRlybft7IsahBc_eJ
X-Mailer: YahooMailClassic/10.1.11 YahooMailWebService/0.8.103.269680
Date: Tue, 4 May 2010 21:22:20 +0530 (IST)
From: Pavan Savoy <pavan_savoy@yahoo.co.in>
Subject: Re: [PATCH v3] firmware_class: fix memory leak - free allocated pages
To: Greg KH <greg@kroah.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20100504154733.GA24636@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Tue, 4/5/10, Greg KH <greg@kroah.com> wrote:

> From: Greg KH <greg@kroah.com>
> Subject: Re: [PATCH v3] firmware_class: fix memory leak - free allocated pages
> To: "Pavan Savoy" <pavan_savoy@yahoo.co.in>
> Cc: "Tomas Winkler" <tomas.winkler@intel.com>, linux-kernel@vger.kernel.org
> Date: Tuesday, 4 May, 2010, 9:17 PM
> On Tue, May 04, 2010 at 08:07:33PM
> +0530, Pavan Savoy wrote:
> > 
> > --- On Tue, 4/5/10, Greg KH <greg@kroah.com>
> wrote:
> > 
> > > From: Greg KH <greg@kroah.com>
> > > Subject: Re: [PATCH v3] firmware_class: fix
> memory leak - free allocated pages
> > > To: "Pavan Savoy" <pavan_savoy@yahoo.co.in>
> > > Cc: "Tomas Winkler" <tomas.winkler@intel.com>,
> linux-kernel@vger.kernel.org
> > > Date: Tuesday, 4 May, 2010, 7:33 PM
> > > On Tue, May 04, 2010 at 12:16:44AM
> > > +0530, Pavan Savoy wrote:
> > > > 
> > > > 
> > > > --- On Mon, 3/5/10, Greg KH <greg@kroah.com>
> > > wrote:
> > > > 
> > > > > From: Greg KH <greg@kroah.com>
> > > > > Subject: Re: [PATCH v3] firmware_class:
> fix
> > > memory leak - free allocated pages
> > > > > To: "Tomas Winkler" <tomas.winkler@intel.com>
> > > > > Cc: "Greg Kroah-Hartman" <gregkh@suse.de>,
> > > linux-kernel@vger.kernel.org,
> > > "David Woodhouse" <dwmw2@infradead.org>,
> > > "Kay Sievers" <kay.sievers@vrfy.org>,
> > > "David Woodhouse" <David.Woodhouse@intel.com>,
> > > "Johannes Berg" <johannes@sipsolutions.net>,
> > > "Ming Lei" <tom.leiming@gmail.com>,
> > > "Catalin Marinas" <catalin.marinas@arm.com>
> > > > > Date: Monday, 3 May, 2010, 10:34 PM
> > > > > On Sun, May 02, 2010 at 11:21:21AM
> > > > > +0300, Tomas Winkler wrote:
> > > > > > From: David Woodhouse <David.Woodhouse@intel.com>
> > > > > > 
> > > > > > fix memory leak introduced by the
> patch
> > > 6e03a201bbe:
> > > > > > firmware: speed up
> request_firmware()
> > > > > > 
> > > > > > 1. vfree won't release pages there
> were
> > > allocated
> > > > > explicitly and mapped
> > > > > > using vmap. The memory has to be
> vunmap-ed
> > > and the
> > > > > pages needs
> > > > > > to be freed explicitly
> > > > > > 
> > > > > > 2. page array is moved into the
> 'struct
> > > > > > firmware' so that we can free it
> from
> > > > > release_firmware()
> > > > > > and not only in fw_dev_release()
> > > > > > 
> > > > > > The fix doesn't break the firmware
> load
> > > speed.
> > > > > > 
> > > > > > Cc: Johannes Berg <johannes@sipsolutions.net>
> > > > > > Cc: Greg Kroah-Hartman <gregkh@suse.de>
> > > > > > Cc: Ming Lei <tom.leiming@gmail.com>
> > > > > > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > > > > > Singed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> > > > > > Signed-off-by: David Woodhouse
> <David.Woodhouse@intel.com>
> > > > > > Signed-off-by: Tomas Winkler
> <tomas.winkler@intel.com>
> > > > > > ---
> > > > > > V2: fix authorship of the patch
> > > > > > V3: fix const struct firmware
> breakage
> > > > > 
> > > > > Thanks, this looks much better, I've
> applied it
> > > now.
> > > > 
> > > > Sorry to bump-in the middle.
> > > > But as a user of firmware class, what should
> now my
> > > fw_entry structure be?
> > > > const struct firmware *fw_entry or,
> > > > struct firmware *fw_entry - without the
> const ..
> > > 
> > > You should leave it to be whatever it was before
> this
> > > patch, it has not
> > > changed anything now.
> > 
> > Ok, However this patch has changed the
> release_firmware,
> > -release_firmware(const struct firmware *fw)
> > +release_firmware(struct firmware *fw)
> 
> Does your code now complain about a warning?  If so,
> do you have a
> pointer to it?

Yes, code now has warnings, I have something like,
        const struct firmware *fw_entry; declared in my header file,
and use it as,
            request_firmware(&kim_gdata->fw_entry, bts_scr_name,
                             &kim_gdata->kim_pdev->dev);
and then I get warnings at,
        release_firmware(kim_gdata->fw_entry);

You want me to have a pointer to &kw_gdata->fw_entry which is const ?
as in 
const struct firmware **fw_const_ptr;
fw_const_ptr = &kim_gdata->fw_entry; ?


> thanks,
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


