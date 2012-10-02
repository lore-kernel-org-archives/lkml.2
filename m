Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925Ab2JBEj7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 00:39:59 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56988 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820Ab2JBEj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 00:39:58 -0400
Date: Tue, 2 Oct 2012 06:39:54 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jamie Gloudon <jamie.gloudon@gmail.com>
Cc: fenghua.yu@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/11] x86/microcode: Early load microcode
Message-ID: <20121002043954.GA27331@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jamie Gloudon <jamie.gloudon@gmail.com>, fenghua.yu@intel.com,
	linux-kernel@vger.kernel.org
References: <20121001161151.GA2640@darkstar>
 <20121001162745.GD23181@x1.osrc.amd.com>
 <20121001233704.GA1344@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121001233704.GA1344@darkstar>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 07:37:04PM -0400, Jamie Gloudon wrote:
> On Mon, Oct 01, 2012 at 06:27:45PM +0200, Borislav Petkov wrote:
> > On Mon, Oct 01, 2012 at 12:11:51PM -0400, Jamie Gloudon wrote:
> > > Hey,
> > > 
> > >   Any chance of this getting merge for the 3.7 cycle? 
> > 
> > It is not ready yet: http://marc.info/?l=linux-kernel&m=134910582107898
> > 
> > Out of curiosity: why do you nee it?
> > 
> Seems like a better alternative to microcode_ctl which some distros don't
> contain.

 [ Let me reorganize the mail chain as it should be,
   without top-posting. Please try not to top-post:
   http://curl.haxx.se/mail/etiquette.html#Do_Not_Top_Post ]


Well,

if you want to reload your microcode, you shouldn't be needing
microcode_ctl (I believe this should be the case too on Intel, from
staring at the code - on AMD it works).

Basically, you simply put the microcode binaries into
/lib/firmware/{amd,intel}-ucode/ and then do as root:

$ echo 1 > /sys/devices/system/cpu/microcode/reload

That's it, no need for special tools.

-- 
Regards/Gruss,
    Boris.
