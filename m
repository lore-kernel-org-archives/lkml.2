Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab1EPMsn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 08:48:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755118Ab1EPMsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 08:48:42 -0400
Date: Mon, 16 May 2011 08:43:51 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: "Ostrovsky, Boris" <Boris.Ostrovsky@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Petkov, Borislav" <Borislav.Petkov@amd.com>
Subject: Re: [PATCH] cpu, AMD: Fix another bug in the new errata checking
 code
Message-ID: <20110516084351.003bb214@katamari>
In-Reply-To: <20110513151921.GA878@escobedo.osrc.amd.com>
References: <20110512195938.1728ab52@katamari>
	<20110513102154.GB9270@escobedo.osrc.amd.com>
	<4DCD2C3F.9070905@amd.com>
	<20110513105928.6216ddc8@katamari>
	<20110513151921.GA878@escobedo.osrc.amd.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 May 2011 17:19:23 +0200
Hans Rosenfeld <hans.rosenfeld@amd.com> wrote:
> > > > Could you send me the contents of MSRs 0xc0010140, 0xc0010141 and
> > > > 0xc0010055?
> > > 
> > > Knowing whether any C state above C1 is declared could be useful too.
> > > 
> > rdmsr 0xc0010140 gives 2
> 
> This means that E400 is known ...
> 
> > rdmsr 0xc0010141 gives 0
> 
> ... and no workaround is necessary ...
> 
> > rdmsr 0xc0010055 gives 0
> 
> ... because C1E is not enabled.
> 
> > And ARAT is definitely set where it wasn't before these updates.
> 
> I don't see how that could possibly make a difference if C1E is not even
> enabled. This is all very strange.
> 

Looking at commit e20a2d205c05cef6b5783df339a7d54adeb50962 ("x86, AMD: Fix
APIC timer erratum 400 affecting K8 Rev.A-E processors") I see that it
extended the E400 workaround to cover a whole range of processors that
have never supported C1E. Isn't this just more of the same problem, only
happening with processors that support C1E but have it disabled?

They are using C3 for idle states, I can confirm that now.
