Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab1GVOse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 10:48:34 -0400
Received: from mother.ludd.ltu.se ([130.240.16.3]:52955 "EHLO
	mother.ludd.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350Ab1GVOsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 10:48:33 -0400
X-Greylist: delayed 2513 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Jul 2011 10:48:32 EDT
Date: Fri, 22 Jul 2011 16:06:26 +0200 (MEST)
From: Nils Carlson <nils.carlson@ludd.ltu.se>
X-X-Sender: pyssling@dexter.ludd.ltu.se
To: Tony Luck <tony.luck@intel.com>
cc: Samuel Gabrielsson <samuel.gabrielsson@gmail.com>, mchehab@redhat.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] i7core_edac: Add scrubbing support
In-Reply-To: <BANLkTikyp-p8ymJvEmk2+=zsOZ1+JYYGMA@mail.gmail.com>
Message-ID: <Pine.GSO.4.58.1107221603250.9692@dexter.ludd.ltu.se>
References: <1301491283-14128-1-git-send-email-samuel.gabrielsson@gmail.com>
 <1301491283-14128-2-git-send-email-samuel.gabrielsson@gmail.com>
 <BANLkTikyp-p8ymJvEmk2+=zsOZ1+JYYGMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, thanks for the comments. Unfortunately Samuel moved on to other stuff
so I'll try to fix these.

On Fri, 24 Jun 2011, Tony Luck wrote:

> On Wed, Mar 30, 2011 at 6:21 AM, Samuel Gabrielsson
> <samuel.gabrielsson@gmail.com> wrote:
> > +       const u32 cache_line_size = 64;
> > +       const u32 freq_dclk = 800*1000000;
>
> Is dclk always 800 MHz?  If so, a #define might me nice - you use it again in
> get_sdram_scrub_rate(). If not, then getting the actual frequency from some
> place would be good.

Does anybody know a good reliable way to get the frequency from within the
kernel? dmidecode works, but any easier ways would be nice. Happy for any
help.


> > +               dw_scrub = 0x00ffffff & (cache_line_size * freq_dclk / new_bw);
>
> Does this give the right answer? It looks like you overflow the "u32" size
> of these calculations when you do 64*800000000 = 51200000000.
>
> > +       return 0xffffffff & (cache_line_size * freq_dclk / (u64) scrubval);
>
> Ditto on the overflow question here.
>

Will check. Thanks for the catch.

/Nils


> -Tony
> --
> To unsubscribe from this list: send the line "unsubscribe linux-edac" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
