Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab0KRIY4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 03:24:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36307 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754894Ab0KRIYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 03:24:55 -0500
Date: Thu, 18 Nov 2010 09:24:54 +0100
From: Michal Hocko <mhocko@suse.cz>
To: "Berg, Johannes" <johannes.berg@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 5ada28bf76752 causes compilation error if !CONFIG_LEDS_CLASS
Message-ID: <20101118082454.GC15928@tiehlicka.suse.cz>
References: <20101116142027.GC19247@tiehlicka.suse.cz>
 <C5C86A19469DAE48AAAD0E5F3716E44501D41A7DC2@irsmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C5C86A19469DAE48AAAD0E5F3716E44501D41A7DC2@irsmsx504.ger.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 16-11-10 17:41:33, Berg, Johannes wrote:
> > it seems that your patch (5ada28bf76752e33dce3d807bf0dfbe6d1b943ad)
> > causes the following compilatation error:
> >   LD      .tmp_vmlinux1
> > drivers/built-in.o: In function `led_trigger_set':
> > drivers/leds/led-triggers.c:116: undefined reference to
> > `led_brightness_set'
> > make[1]: *** [.tmp_vmlinux1] Error 1
> > 
> > AFAICS, led_brightness_set is defined in drivers/leds/led-class.c which
> > is compiled only if CONFIG_LEDS_CLASS is configured which is not my
> > case (after make oldconfig with all default values from 37-rc1).
> > 
> > I am not sure what is the right solution whether CONFIG_LEDS_TRIGGERS
> > should depend on CONFIG_LEDS_CLASS or the patch should be reverted.
> > 
> > My config is attached, if somebody need it.
> 
> Hmm, we did find that, and I made a patch to fix up the Kconfig, that apparently hasn't made it in? Bit confused now.

Does this mean that I should enable CONFIG_LEDS_CLASS to work around the
issue for this moment?

> 
> johannes
> --------------------------------------------------------------------------------------
> Intel GmbH
> Dornacher Strasse 1
> 85622 Feldkirchen/Muenchen, Deutschland 
> Sitz der Gesellschaft: Feldkirchen bei Muenchen
> Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
> Registergericht: Muenchen HRB 47456 
> Ust.-IdNr./VAT Registration No.: DE129385895
> Citibank Frankfurt a.M. (BLZ 502 109 00) 600119052
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
