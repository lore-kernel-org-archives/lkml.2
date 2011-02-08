Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab1BHO5Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 09:57:25 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:31959 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab1BHO5Y (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 8 Feb 2011 09:57:24 -0500
Date: Tue, 8 Feb 2011 09:55:51 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@Oracle.Com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>, Jan Beulich <JBeulich@novell.com>
Subject: Re: [PATCH] x86/mm/init: respect memblock reserved regions when
 destroying mappings
Message-ID: <20110208145551.GA4606@dumpdata.com>
References: <4D4E4E0D.2080806@zytor.com>
 <4D4EF553.6000000@kernel.org>
 <alpine.DEB.2.00.1102071524140.7277@kaball-desktop>
 <4D50343E.1020906@kernel.org>
 <alpine.DEB.2.00.1102071839060.7277@kaball-desktop>
 <4D504161.2060900@kernel.org>
 <4D506A85.9030802@goop.org>
 <4D50B4B5.4050505@kernel.org>
 <4D50CCFA.1040004@goop.org>
 <AANLkTi=koyyz8h1A3qWbp2F+N3kA46rJfHPSPN+Ms8hm@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=koyyz8h1A3qWbp2F+N3kA46rJfHPSPN+Ms8hm@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4D515989.006C:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> could be used to skip clear highmap for xen path?
> >
> > Seems pretty ad-hoc.
> >
> 
> then what is size for mfn-list after _end...

8 bytes * nr_pages. For 4GB, 2048 pages. For 32GB, 8192 pages. For 128GB,
32768 pages, and so on.
> 
> could be copied or move to BRK.

The _brk size is determined during build-time. We don't know what the
memory size will be during bootup time and would have to select the
highest values (128MB) which is quite a large amount to be reserved
in _brk area.
