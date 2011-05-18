Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933765Ab1ERT2D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 15:28:03 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:43464 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933607Ab1ERT16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 15:27:58 -0400
X-Sasl-enc: NyHm/gXdEfiSYWryrw4lW4kDLfHVyxQ2qaCg094KpzZx 1305746877
Date: Wed, 18 May 2011 12:21:10 -0700
From: Greg KH <greg@kroah.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Anders Kaseorg <andersk@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Dirk Behme <dirk.behme@googlemail.com>
Subject: Re: [PATCH] module: Use binary search in lookup_symbol()
Message-ID: <20110518192110.GB26945@kroah.com>
References: <BANLkTinPG100vbVAN1RZWb3h9Xuu6SKJ0Q@mail.gmail.com>
 <1305665763-3988-1-git-send-email-abogani@kernel.org>
 <20110517232241.GA19140@kroah.com>
 <4DD305B3.3000707@am.sony.com>
 <20110518075428.GA29998@infradead.org>
 <4DD3FB1C.3040103@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DD3FB1C.3040103@am.sony.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 10:00:12AM -0700, Tim Bird wrote:
> On 05/18/2011 12:54 AM, Christoph Hellwig wrote:
> > On Tue, May 17, 2011 at 04:33:07PM -0700, Tim Bird wrote:
> >> That said, I can answer Greg's question.  This is to speed up
> >> the symbol resolution on module loading.  The last numbers I
> >> saw showed a reduction of about 15-20% for the module load
> >> time, for large-ish modules.  Of course this is highly dependent
> >> on the size of the modules, what they do at load time, and how many
> >> symbols are looked up to link them into the kernel.
> > 
> > How large are these very large modules, and what are good examples for
> > that?
> 
> usbcore seems to be a large-ish module whose
> load time is improved by this.  More details follow:

Then add the module to the kernel image, that's what a lot of distros do
now to solve this issue.

> I don't know the exact modules, but Alan Jenkins reported a .3
> second reduction in overall boot time, on a EEE PC, presumably
> running a stock Linux distribution, and loading 41 modules.
> 
> See http://lkml.org/lkml/2009/11/3/93

That's good to know.

> Carmelo Amoroso reported some good performance gains
> in this presentation:
> http://elinux.org/images/1/18/C_AMOROSO_Fast_lkm_loader_ELC-E_2009.pdf
> (See slide 22).
> 
> He doesn't report the overall time savings, and
> he was using a different method (hash tables as opposed to
> binary search), but I believe the results are comparable
> to what the binary search enhancement provides.
> 
> The biggest offenders in his testing were usbcore,
> ehci_hcd and ohci_hcd.

Why those?  The size of them, or something else?  They don't seem to
have very many symbols they need to look up compared to anything else
that I can tell.

Is something else going on here due to the serialization of the USB
drivers themselves?

> > And why do people overly care for the load time?
> 
> To reduce overall boot time.

To reduce it even more, build the modules into the kernel :)

I'm not saying I object to this patch, I just want a whole lot more
information in it when submitted as currently there was no justification
for the change at all.

thanks,

greg k-h
