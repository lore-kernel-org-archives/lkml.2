Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab2G3K6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 06:58:20 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:52049 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753061Ab2G3K6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 06:58:18 -0400
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, lenb@kernel.org,
        bhelgaas@google.com, rjw@sisk.pl
Content-Type: text/plain; charset="utf-8"
Date: Mon, 30 Jul 2012 12:58:16 +0200
From: "Witold Szczeponik" <Witold.Szczeponik@gmx.net>
In-Reply-To: <20120730082820.GA32745@liondog.tnic>
Message-ID: <20120730105816.59030@gmx.net>
MIME-Version: 1.0
References: <50158321.4030007@gmx.net> <201207292122.28249.rjw@sisk.pl>
 <50158FA9.7080700@gmx.net> <20120730082820.GA32745@liondog.tnic>
Subject: Re: [PATCH V3 0/3] PNP: Allow PNP resources to be disabled (interface)
To: Borislav Petkov <bp@alien8.de>
X-Authenticated: #787645
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX193lXoCRx135TqGzHYmZB03U3Yk+c/qYNII3l6A5m
 TUSld6z2S/9n00OPDFLyV3FJHyO0CZe0k0Nw== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: nw1kcGt2eSEqR9xnZ3QhzKB+IGRvb8A0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, Jul 29, 2012 at 09:31:53PM +0200, Witold Szczeponik wrote:
> > the aim is to select a PNP ACPI option where resources can be disabled
> > (or are not needed).  E.g., the parallel port of the 600E can be used
> > with and without IRQ lines.  The means to allow for this is to use the
> > sysfs interface to select disabled resources (just like any other 
> > resource value).  In https://lkml.org/lkml/2011/7/3/41, I used the 
> > following example:
> > 
> >   echo disable > /sys/bus/pnp/devices/$device/resources
> >   echo clear > /sys/bus/pnp/devices/$device/resources
> >   echo set irq disabled > /sys/bus/pnp/devices/$device/resources
> >   echo fill > /sys/bus/pnp/devices/$device/resources
> >   echo activate > /sys/bus/pnp/devices/$device/resources
> > 
> > The third line is made possible by the patch series.  All other
> > lines are already implemented.
> 
> Shouldn't this be rather "disable_irq" or something which is a single
> word and thus would simplify parsing a lot?
> 
> Also, <Documentation/filesystems/sysfs.txt> says
> 
> "Attributes should be ASCII text files, preferably with only one value
> per file. It is noted that it may not be efficient to contain only one
> value per file, so it is socially acceptable to express an array of
> values of the same type."
> 
> Thanks.
> 
> -- 
> Regards/Gruss,
>     Boris.

Hi Boris, 

the patch series is about adding the term "disabled" (or "<none") to
the list of possible values for resources.  The current state of the
kernel ABI already allows to use the following statement (cf. DSDT
excerpt from https://lkml.org/lkml/2011/7/3/41): 

  echo set irq 7 > /sys/bus/pnp/devices/$device/resources

i.e., the "resources" file can already parse all the values necessary for setting PNP values.  

The patch series is not about adding a new ABI or changing an existing ABI.  It is about extending the existing one to be able to handle the term "disabled" (or "<none>") as a special for a resource value. 

--- Witold
