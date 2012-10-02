Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab2JBNLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 09:11:46 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:41726 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806Ab2JBNLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 09:11:44 -0400
Date: Tue, 2 Oct 2012 09:11:38 -0400
From: Jamie Gloudon <jamie.gloudon@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com
Subject: Re: [PATCH 00/11] x86/microcode: Early load microcode
Message-ID: <20121002131138.GA1387@darkstar>
References: <20121001161151.GA2640@darkstar>
 <20121001162745.GD23181@x1.osrc.amd.com>
 <20121001233704.GA1344@darkstar>
 <20121002043954.GA27331@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121002043954.GA27331@liondog.tnic>
User-Agent: Mutt/ (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 06:39:54AM +0200, Borislav Petkov wrote:
> On Mon, Oct 01, 2012 at 07:37:04PM -0400, Jamie Gloudon wrote:
> > On Mon, Oct 01, 2012 at 06:27:45PM +0200, Borislav Petkov wrote:
> > > On Mon, Oct 01, 2012 at 12:11:51PM -0400, Jamie Gloudon wrote:
> > > > Hey,
> > > > 
> > > >   Any chance of this getting merge for the 3.7 cycle? 
> > > 
> > > It is not ready yet: http://marc.info/?l=linux-kernel&m=134910582107898
> > > 
> > > Out of curiosity: why do you nee it?
> > > 
> > Seems like a better alternative to microcode_ctl which some distros don't
> > contain.
> 
>  [ Let me reorganize the mail chain as it should be,
>    without top-posting. Please try not to top-post:
>    http://curl.haxx.se/mail/etiquette.html#Do_Not_Top_Post ]
> 
> 
> Well,
> 
> if you want to reload your microcode, you shouldn't be needing
> microcode_ctl (I believe this should be the case too on Intel, from
> staring at the code - on AMD it works).
> 
> Basically, you simply put the microcode binaries into
> /lib/firmware/{amd,intel}-ucode/ and then do as root:
> 
> $ echo 1 > /sys/devices/system/cpu/microcode/reload
> 
> That's it, no need for special tools.
> 
> -- 
> Regards/Gruss,
>     Boris.

My main interest was getting PEBS events support for perf on Intel SNB cpus. Loading the microcode at runtime was not going to work. 

However, thanks for pointing me in the right direction. I notice today this is not the case anymore from the thread below.

http://marc.info/?l=linux-kernel&m=133905353211963&w=2


Regards,
Jamie Gloudon

