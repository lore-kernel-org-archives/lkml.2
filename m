Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934945Ab0KQQvM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 11:51:12 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64446 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757032Ab0KQQvK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 11:51:10 -0500
Date: Wed, 17 Nov 2010 14:50:42 -0200
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Pavan Savoy <pavan_savoy@sify.com>
Cc: marcel@holtmann.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] Bluetooth: btwilink driver
Message-ID: <20101117165042.GA21729@vigoh>
References: <1289394446-14021-1-git-send-email-pavan_savoy@ti.com>
 <20101116225418.GA15101@vigoh>
 <AANLkTikbhaZOvM43Vv6wdcbmK8nh2Nq2Hc1i_naxWjYM@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <AANLkTikbhaZOvM43Vv6wdcbmK8nh2Nq2Hc1i_naxWjYM@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavan,

* Pavan Savoy <pavan_savoy@sify.com> [2010-11-17 11:04:59 +0530]:

> Gustavo,
> 
> On Wed, Nov 17, 2010 at 4:24 AM, Gustavo F. Padovan
> <padovan@profusion.mobi> wrote:
> > Hi Pavan,
> >
> > * pavan_savoy@ti.com <pavan_savoy@ti.com> [2010-11-10 08:07:26 -0500]:
> >
> >> From: Pavan Savoy <pavan_savoy@ti.com>
> >>
> >> Marcel,
> >>
> >> Thanks for the comments...
> >> This patch contains,
> >> v5 comments :-
> >> declaration and assiging of variables and private data fixed up.
> >> proper casting.
> >> removed redundant un-necessary checks in send_frame.
> >> HCI_RUNNING fixes in terms of test_and_set/clear bit instead of set and
> >> clear.
> >> removed redundant checks for hdev, skb being NULL.
> >> removed module_param of reset, also WiLink don't need HCI_RESET anyways.
> >> removed ti_st_register_dev function and functionality moved to _probe.
> >> module_init/exit function names fixed up.
> >>
> >> stat byte counter increments and tx_complete is similar to hci_ldisc.
> >> Also I have not implemented the flush routine, since the functionality
> >> which needs to be done in flush routine is done in the underlying driver
> >> which is the shared transport driver and moreover the btwilink driver by
> >> itself doesn't maintains queue or data relevant to transport, so nothing
> >> to do.
> >>
> >> And Yes, I have verified this driver with multiple up/down reset on
> >> hci0.
> >> Also I generally test a2dp/ftp to verify large data transfers.
> >
> > Before re-submit a patch you have to fix all issues reported by the
> > reviewer or reply to patch thread why do you think you right and don't
> > want to change that. That is not happening with your patches, you are
> > not fixing all the stuff before re-submiting and it is not the first
> > time.  If you do it right we can review it fast and your code goes
> > earlier to mainline.
> > You should also answer the questions first  like "Where is the
> > ti_st_proto.write coming from?" You just ignored the
> > review and submitted a new patch.
> 
> This is the reason, I tend to keep the patch comments in the mail.
> I have mentioned here the
> 1. comments I have taken care of,
> 2. few comments which I don't understand why it is like that and which
> are not taken care of.

You should reply inline, and not do top posting like this.

> 
> Also the question on ti_st_proto.write, I have answered it twice in
> mail, once to you and once to marcel, for more clarity I have even
> added it in the code comments, Please have a look @ line
> >> +     /* ti_st_proto.write is filled up by the underlying shared
> >> +      * transport driver upon registration
> >> +      */
> As to why this function is not EXPORT_SYMBOL and just an function
> pointer, Yes I had it as function pointer - But since something like
> _read is  callback from the protocol driver perspective - to maintain
> uniformity I have this as function pointer.
> (Note: comments to other drivers which are based on ST driver intended
> read/write to be pointers which register/unregister to be EXPORTs).
> 
> Ok, apart from this there was an open question as why I am checking
> for only 2 error conditions, it is because the underlying driver only
> can send those 2 errors and nothing else (st_register has few errors
> it can throw...)

I don't care if it can send only two errors, someone can change the
underlying driver and we at the Bluetooth subsystem may never know that.
So check for all errors there, instead of two.

-- 
Gustavo F. Padovan
http://profusion.mobi
