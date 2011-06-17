Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798Ab1FQWBZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 18:01:25 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:1354 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758427Ab1FQWBS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 18:01:18 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Date: Fri, 17 Jun 2011 15:01:08 -0700
From: "Henry Ptasinski" <henryp@broadcom.com>
To: "Julian Calaby" <julian.calaby@gmail.com>
cc: "Greg Dietsche" <gregory.dietsche@cuw.edu>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "Brett Rudley" <brudley@broadcom.com>,
        "Dowan Kim" <dowan@broadcom.com>,
        "Roland Vossen" <rvossen@broadcom.com>,
        "Arend Van Spriel" <arend@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Henry Ptasinski" <henryp@broadcom.com>
Subject: Re: [PATCH] staging: brcm80211: return false if not a broadcom
 board
Message-ID: <20110617220108.GH3801@broadcom.com>
References: <1308176709-14765-1-git-send-email-Gregory.Dietsche@cuw.edu>
 <20110616013615.GA14700@broadcom.com> <4DF96F22.5070508@cuw.edu>
 <20110616233736.GA2344@broadcom.com>
 <BANLkTi=tLWXn7mMf-6pf-3gM6x8zX=WNtw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <BANLkTi=tLWXn7mMf-6pf-3gM6x8zX=WNtw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-WSS-ID: 61E51014538660321-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 04:45:21PM -0700, Julian Calaby wrote:
> Henry,
> 
> On Fri, Jun 17, 2011 at 09:37, Henry Ptasinski <henryp@broadcom.com> wrote:
> > How's this for a somewhat clearer implementation:
> >
> > static bool brcms_c_validboardtype(struct brcms_c_hw_info *wlc_hw)
> > {
> >        bool goodboard = true;
> >        uint boardrev = wlc_hw->boardrev;
> >
> >        if (wlc_hw->sih->boardvendor == PCI_VENDOR_ID_BROADCOM) {
> 
> You could reduce indentation by having this be:
> 
> if (wlc_hw->sih->boardvendor != PCI_VENDOR_ID_BROADCOM)
>     return true;
> 
> >                /* validate boardrev */
> >                if (boardrev == 0)
> >                        goodboard = false;
> 
> and remove the goodboard variable by having this return false immediately.
> 
> >                else if (boardrev > 0xff) {
> 
> You could also drop the else and have this as
> 
> if (boardrev <= 0xff)
>     return true;
> 
> >                        /* 4 bits each for board type, major, minor, and tiny
> >                        version numbers */
> >                        uint brt = (boardrev & 0xf000) >> 12;
> >                        uint b0 = (boardrev & 0xf00) >> 8;
> >                        uint b1 = (boardrev & 0xf0) >> 4;
> >                        uint b2 = boardrev & 0xf;
> >
> >                        if ((brt > 2) || (brt == 0) || (b0 > 9) || (b0 == 0)
> >                                || (b1 > 9) || (b2 > 9))
> >                                goodboard = false;
> 
> and return false here too.
> 
> >                }
> >        }
> >
> >        return goodboard;
> 
> then just return true here.
> 
> > }
> 
> Thanks,
> 
> -- 
> Julian Calaby

Yea, it's a lot flatter with those changes.  Look for it in a patch set
relatively soon ...

- Henry


