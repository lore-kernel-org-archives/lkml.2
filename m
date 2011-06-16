Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758786Ab1FPXpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 19:45:45 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36093 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756118Ab1FPXpl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 19:45:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=QFDSj+NyST6ztnDLjg+wS+JOkaqhGNQDB5pAyERiy7Q7Irgt+PFdkhgvWXHbQHGnnQ
         Fh1LKLLIz89lcArK5gker6Buc2clG9CLxSN6BXbwRry0l+MyfWU/WCs4jy4AyoZjxxZs
         E7cw0MFZ7YCg0R3IqEzb+aOmpHKDGDgv3Okks=
MIME-Version: 1.0
In-Reply-To: <20110616233736.GA2344@broadcom.com>
References: <1308176709-14765-1-git-send-email-Gregory.Dietsche@cuw.edu>
 <20110616013615.GA14700@broadcom.com> <4DF96F22.5070508@cuw.edu> <20110616233736.GA2344@broadcom.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 17 Jun 2011 09:45:21 +1000
Message-ID: <BANLkTi=tLWXn7mMf-6pf-3gM6x8zX=WNtw@mail.gmail.com>
Subject: Re: [PATCH] staging: brcm80211: return false if not a broadcom board
To: Henry Ptasinski <henryp@broadcom.com>
Cc: Greg Dietsche <gregory.dietsche@cuw.edu>,
        "gregkh@suse.de" <gregkh@suse.de>, Brett Rudley <brudley@broadcom.com>,
        Dowan Kim <dowan@broadcom.com>, Roland Vossen <rvossen@broadcom.com>,
        Arend Van Spriel <arend@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henry,

On Fri, Jun 17, 2011 at 09:37, Henry Ptasinski <henryp@broadcom.com> wrote:
> How's this for a somewhat clearer implementation:
>
> static bool brcms_c_validboardtype(struct brcms_c_hw_info *wlc_hw)
> {
>        bool goodboard = true;
>        uint boardrev = wlc_hw->boardrev;
>
>        if (wlc_hw->sih->boardvendor == PCI_VENDOR_ID_BROADCOM) {

You could reduce indentation by having this be:

if (wlc_hw->sih->boardvendor != PCI_VENDOR_ID_BROADCOM)
    return true;

>                /* validate boardrev */
>                if (boardrev == 0)
>                        goodboard = false;

and remove the goodboard variable by having this return false immediately.

>                else if (boardrev > 0xff) {

You could also drop the else and have this as

if (boardrev <= 0xff)
    return true;

>                        /* 4 bits each for board type, major, minor, and tiny
>                        version numbers */
>                        uint brt = (boardrev & 0xf000) >> 12;
>                        uint b0 = (boardrev & 0xf00) >> 8;
>                        uint b1 = (boardrev & 0xf0) >> 4;
>                        uint b2 = boardrev & 0xf;
>
>                        if ((brt > 2) || (brt == 0) || (b0 > 9) || (b0 == 0)
>                                || (b1 > 9) || (b2 > 9))
>                                goodboard = false;

and return false here too.

>                }
>        }
>
>        return goodboard;

then just return true here.

> }

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
