Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376Ab2HOK1G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 06:27:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:35079 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab2HOK1E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 06:27:04 -0400
Message-ID: <1345026408.31459.60.camel@twins>
Subject: Re: [perf] make clean problematic bashism
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Wouter M. Koolen" <W.M.Koolen-Wijkstra@cwi.nl>
Cc: paulus@samba.org, mingo@redhat.com, acme@ghostprotocols.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 15 Aug 2012 12:26:48 +0200
In-Reply-To: <502B714E.4010700@cwi.nl>
References: <502B714E.4010700@cwi.nl>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-15 at 11:52 +0200, Wouter M. Koolen wrote:
> Dear perf maintainers,
> 
> I attempted to compile perf 3.5.1 without worrying about installing 
> dependencies first. The resulting error messages were quite helpful, and 
> led me to install a bunch of development libraries and flex.
> 
> Unfortunately, after installing flex the build still failed, even after 
> make clean.
> 
> The reason for this was a bunch of generated empty flex files in util/ 
> that were not removed by make clean. They are intended to be erased, 
> since the Makefile executes
> 
> rm -f util/*-{bison,flex}*
> 
> however, this command does not remove the files. I guess because {,} 
> alternatives are only special in bash but the makefile is run with some 
> other shell?

ISTR us getting a number of such patches, did we miss a site, acme?

> I got perf to compile now, but thought you would be interested to know 
> about this little problem.
> 
> With kind regards,
> 
> Wouter Koolen
> 
> 
> PS: as a side note: GNU make has the .DELETE_ON_ERROR: special target, 
> which removes the target file when its generating command fails. This 
> would have prevented my problem and sounds like a good idea in general. 
> Maybe perf could make use of this feature when on GNU make?

I don't think we build with anything but gnu make, mind sending a patch
implementing your suggestion?
