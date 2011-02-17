Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab1BQCbJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 21:31:09 -0500
Received: from smtp.scorch.co.nz ([27.110.127.199]:33845 "HELO scorch.co.nz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755497Ab1BQCbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 21:31:07 -0500
X-Virus-Checked: Checked by ClamAV on scorch.co.nz
From: Charles Manning <manningc2@actrix.gen.nz>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 0/10] Add yaffs2 file system:  Fifth patchset
Date: Thu, 17 Feb 2011 15:31:03 +1300
User-Agent: KMail/1.9.10
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ryan@bluewatersys.com,
        akpm@linux-foundation.org
References: <1297221968-6747-1-git-send-email-cdhmanning@gmail.com> <201102171112.07101.manningc2@actrix.gen.nz> <20110217014808.GD5824@sirena.org.uk>
In-Reply-To: <20110217014808.GD5824@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201102171531.03924.manningc2@actrix.gen.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 February 2011 14:48:08 Mark Brown wrote:
> On Thu, Feb 17, 2011 at 11:12:06AM +1300, Charles Manning wrote:
> > On Wednesday 16 February 2011 21:04:20 Christoph Hellwig wrote:
> > > The procfs interfaces should be replaced by something saner,
> > > the insane amount of ad-hoc tracing crap should be replaced by much
> > > less strategically placed trace events, and all those stupid compile
> > > time options have absolutely no business at all beeing there for a
> > > filesystem -
> >
> > Why not?
> >
> > > remember you can get media from all over the place.
> >
> > No you can't. This is a flash file system for soldered down flash. I
> > think that is a fundamental place where your understanding of what yaffs
> > is falls down.

I'm not sure I really understand what Christoph means by "get media from all 
over the place". I took that to mean he thinks people will pug in random 
flash cards and would need to fiddle with options to make them work. That 
would of course suck badly.

That is obviously not the case for a flash file system used on hard-wired 
flash where the system integrator is in control. Users don't get to fiddle.

>
> Even for embedded systems people do end up wanting to do things like
> using the same kernel on multiple systems which may have different
> hardware configurations (distros and reference boards are the obvious
> examples, but I've worked on systems where multiple generations and
> builds of the product were in active use and similar enough to be
> maintained from the same kernel).  Even with single system kernels
> there's still an issue with things like reference boards where users are
> doing things like picking up a new upstream kernel rather than the
> vendor BSP.

Every one of the "stupid compile time options" is there because someone that 
actually **uses** yaffs wanted it. None are there just for fun. The 
compile-time switches are very limited - mostly just there to set up default 
runtime flags that can be overridden at runtime. Some of them are there to 
work around bugs and limitations in the mtd.

Even with BSPs, there will often be some board tuning to, do things like set 
up the mtd partitions.

Picking up an new kernel is easy, so long as the mtd code has not been broken 
in the interum. 

Last week I dropped the yaffs code into an omap3 build of 2.6.37 with no 
fiddling and with default settings and it "just worked".

>
> > > If you can't encode these difference in your on-disk format it has
> > > absolutely no business going into mainline with this format.
> >
> > Yaffs does not really have an on-disk format like most other fs do.
>
> I'm not sure exactly how you'd do this for a filesystem but this is
> starting to sound a lot like platform data...  Though presumably if the
> data isn't stored on the device currently it'd be a simple matter of
> programming (if wasteful) to add it.

NB flash file system - not file system! Working via mtd is different to 
working via blocks.

Most of the required data is passed through mtd and you don't need any special 
platform data beyond the nand setup in the board tuning file.




