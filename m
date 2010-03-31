Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045Ab0CaSCq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 14:02:46 -0400
Received: from web94911.mail.in2.yahoo.com ([203.104.17.176]:44661 "HELO
	web94911.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757642Ab0CaSCn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 14:02:43 -0400
Message-ID: <157465.85166.qm@web94911.mail.in2.yahoo.com>
X-YMail-OSG: fhAI5AIVM1lyQXbX8nWfpf.n2rHBxNSrPBBPZ7gBwUE0qMy
 df6c2aQfgm3sHK7Ts8xA1gsObbO5LyLqaG6SwqB21HPATu4jmnJJFbQdby6x
 3yIB0L3zKbJYwfzWegLKfpJ_.QdryoHgRB2ydk0vdTDPfixLjpjxE.Uh33xw
 zCQc8sq_mO.PxSg_21i6QE6EbSf7EGZFHxLrMXSfh3nXhW2JNkwunbWR0p8j
 Fvo0ShuLNPmYPPJkb2SALGp1nCDbN8HkeJICO9OmkEadrNJ6r9Wspg.ghJga
 dPwQZp9rxpOMcScDQCEzehMc-
X-RocketYMMF: pavan_savoy
X-Mailer: YahooMailClassic/10.0.8 YahooMailWebService/0.8.100.260964
Date: Wed, 31 Mar 2010 23:32:39 +0530 (IST)
From: Pavan Savoy <pavan_savoy@ti.com>
Reply-To: pavan_savoy@ti.com
Subject: Re: [PATCH] drivers:staging: sources for ST core
To: Greg KH <gregkh@suse.de>
Cc: Marcel Holtmann <marcel@holtmann.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100331173049.GD8906@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Wed, 31/3/10, Greg KH <gregkh@suse.de> wrote:

> From: Greg KH <gregkh@suse.de>
> Subject: Re: [PATCH] drivers:staging: sources for ST core
> To: "Pavan Savoy" <pavan_savoy@ti.com>
> Cc: "Marcel Holtmann" <marcel@holtmann.org>, alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
> Date: Wednesday, 31 March, 2010, 11:00 PM
> On Wed, Mar 31, 2010 at 04:20:22AM
> +0530, Pavan Savoy wrote:
> > 
> > --- On Wed, 31/3/10, Pavan Savoy <pavan_savoy@ti.com>
> wrote:
> > 
> > > From: Pavan Savoy <pavan_savoy@ti.com>
> > > Subject: Re: [PATCH] drivers:staging: sources for
> ST core
> > > To: gregkh@suse.de
> > > Cc: "Marcel Holtmann" <marcel@holtmann.org>,
> alan@lxorguk.ukuu.org.uk
> > > Date: Wednesday, 31 March, 2010, 4:11 AM
> > > --- On Wed, 31/3/10, Pavan Savoy
> > > <pavan_savoy@yahoo.co.in>
> > > wrote:
> > > 
> > > > From: Pavan Savoy <pavan_savoy@yahoo.co.in>
> > > > Subject: Re: [PATCH] drivers:staging:
> sources for ST
> > > core
> > > > To: "pavan_savoy@yahoo.co.in"
> > > <pavan_savoy@yahoo.co.in>
> > > > Date: Wednesday, 31 March, 2010, 4:06 AM
> > > > > From: Greg KH [gregkh@suse.de]
> > > > > Sent: Wednesday, March 31, 2010 3:17
> AM
> > > > > To: Savoy, Pavan
> > > > > Cc: Alan Cox; marcel@holtmann.org;
> > > > > linux-kernel@vger.kernel.org
> > > > > Subject: Re: [PATCH] drivers:staging:
> sources for
> > > ST
> > > > core
> > > > > 
> > > > > On Wed, Mar 31, 2010 at 02:35:55AM
> +0530, Pavan
> > > Savoy
> > > > > wrote:
> > > > > > So, something like the below is
> ok, I have
> > > > defined my
> > > > > own pr_fmt,
> > > > > > however default log level on my
> board is 7,
> > > and
> > > > hence
> > > > > pr_info is a bit
> > > > > > more annoying than usual.
> > > > > 
> > > > > No, a driver should use dev_dbg() and
> other
> > > > dev_printk()
> > > > > calls, not
> > > > > pr_debug() or anything like that.
> > > > > 
> > > > > Please don't roll your own formats, use
> the ones
> > > that
> > > > are
> > > > > well defined
> > > > > and uniquely describe your driver and
> device in
> > > a
> > > > format
> > > > > that the whole
> > > > > kernel uses.
> > > > 
> > > 
> > 
> > forgot lkml the last time..
> > 
> > Nope, I couldn't find any instance of struct device at
> all,
> > I need that to use dev_dbg right ? - None of the
> tty_*
> > structure accessible by ldiscs seems to have a
> reference to
> > it.
> > Also I happened to look at other line discipline
> driver, if
> > they have a smarter way of doing this, Nope - n_tty,
> n_hdlc,
> > n_slip all seem to use plain old printks.
> >  
> > Any clues ??
> 
> Sorry, you are correct, we only have a struct kref right
> now for tty
> core objects, not a struct device.  So nevermind, this
> should be fine.

Oh cool. Thanks, So that leaves me with 1 pending item from Alan which is to tie these 3 modules (KIM/Core/LL) up onto a TTY device specific context, and avoid all global ptrs.

So without that is it good to go in ?

> thanks,
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


      Your Mail works best with the New Yahoo Optimized IE8. Get it NOW! http://downloads.yahoo.com/in/internetexplorer/
