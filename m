Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab0EJTH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 15:07:57 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:57181 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756146Ab0EJTHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 15:07:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=mwU1B69vaB1WvDElMaLbGarO2LrFdfBzKTHbOJt5Fnq++Qr7PKeLRHEGVvFNj9Mgnv
         Cc1od8vqOHmiKy8tTrGuDUHv7vy3/Fiohgi/zT23fgsMAZi4mP4OxBineiFJmHBC/Cl+
         pakoxZIfm9mOPwHSUrSOVwR03YQCOsKuRWjTg=
Subject: Re: [regression, bisected] Xonar DX invalid PCI I/O range since 
 977d17bb174
From: Peter Henriksson <peter.henriksson@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Yinghai <yinghai.lu@oracle.com>, Clemens Ladisch <clemens@ladisch.de>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100421085408.33754cd0@virtuousgeek.org>
References: <4BCBFE89.9070401@ladisch.de>
	 <o2gf046f1351004190044h6c3f6536ga916d2fa047f3fe7@mail.gmail.com>
	 <4BCC0F10.3070208@ladisch.de>
	 <l2sf046f1351004190142ocb2e5f1fyc0e892489caa76a3@mail.gmail.com>
	 <4BCCA5FD.6060002@oracle.com> <1271706161.2505.6.camel@darwin.lan>
	 <4BCD4C8D.7070805@oracle.com>
	 <n2yf046f1351004200103zdcf703e6ofea41dc688a5e62e@mail.gmail.com>
	 <r2o86802c441004201022i32f328e2n7a125df88f67e390@mail.gmail.com>
	 <1271789155.2554.2.camel@darwin.lan> <4BCE95D1.6070105@oracle.com>
	 <20100421085408.33754cd0@virtuousgeek.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 May 2010 21:07:48 +0200
Message-ID: <1273518468.2491.1.camel@darwin.lan>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any chance of a fix for this before 2.6.34 is released?

Cheers,
Peter

On Wed, 2010-04-21 at 08:54 -0700, Jesse Barnes wrote:
> On Tue, 20 Apr 2010 23:06:09 -0700
> Yinghai <yinghai.lu@oracle.com> wrote:
> > after several times retry, mmio ranges get assigned, but io port range can be allocated enough range. it needs 16k,
> > but under 05:01.0 to 08:00.0 and 09:04.0 orginal io port from BIOS allocation get lost.
> > 
> > wonder be good, if We can restore it for such case.
> > 
> > current may have to disable bridge resizing feature by default.
> > 
> > can you send out 
> > lspci -vvxxx
> > lspci -tv 
> 
> Since we don't really know which devices will be in use until drivers
> load (and not even then if they're userspace drivers), it might be best
> to put off the reassignment until a PCI driver expresses an interest in
> the range.
> 
> At least, it seems like that would be closer to the ideal approach than
> trying to reassign everything at boot, potentially making devices that
> don't matter get resources and leaving important devices disabled.
> 


