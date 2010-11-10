Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757470Ab0KJXar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 18:30:47 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52200 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757268Ab0KJXap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 18:30:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=ER6HZE1/mznvCuJtjLoV7f3VGrm2ajCB3Zh40ZN5fsC/VEqC/jh7LRiOWbtNANgTXh
         hR4tqcVWQYNiyaKtXp33t83yThCJK38NJEHg+KWYymC051mpAlnCLzi+1Fu03w0RsFUa
         yfg2x3+1rPvKUN/VWO2a51oizxdGHADIv5BF0=
Date: Wed, 10 Nov 2010 15:30:36 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Trilok Soni <tsoni@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, rtc-linux@googlegroups.com,
        linux-arm-msm@vger.kernel.org
Subject: Re: [RFC v1 PATCH 1/6] matrix_keypad: Increase the max limit of rows
 and columns
Message-ID: <20101110233036.GB2121@core.coreip.homeip.net>
References: <1289393281-4459-1-git-send-email-tsoni@codeaurora.org>
 <1289393281-4459-2-git-send-email-tsoni@codeaurora.org>
 <AANLkTi=J2fGOC-RQsPB1SD4GcQ2Df2ZO_a=2mxneHbUa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=J2fGOC-RQsPB1SD4GcQ2Df2ZO_a=2mxneHbUa@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 02:33:45AM +0800, Eric Miao wrote:
> On Wed, Nov 10, 2010 at 8:47 PM, Trilok Soni <tsoni@codeaurora.org> wrote:
> > Some keyboard controller have support for more than
> > 16 columns and rows.
> >
> > Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > Cc: Eric Miao <eric.y.miao@gmail.com>
> > Signed-off-by: Trilok Soni <tsoni@codeaurora.org>
> > ---
> >  include/linux/input/matrix_keypad.h |    8 ++++----
> >  1 files changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/include/linux/input/matrix_keypad.h b/include/linux/input/matrix_keypad.h
> > index 80352ad..d80845e 100644
> > --- a/include/linux/input/matrix_keypad.h
> > +++ b/include/linux/input/matrix_keypad.h
> > @@ -4,11 +4,11 @@
> >  #include <linux/types.h>
> >  #include <linux/input.h>
> >
> > -#define MATRIX_MAX_ROWS                16
> > -#define MATRIX_MAX_COLS                16
> > +#define MATRIX_MAX_ROWS                18
> > +#define MATRIX_MAX_COLS                18
> >
> > -#define KEY(row, col, val)     ((((row) & (MATRIX_MAX_ROWS - 1)) << 24) |\
> > -                                (((col) & (MATRIX_MAX_COLS - 1)) << 16) |\
> > +#define KEY(row, col, val)     ((((row) % (MATRIX_MAX_ROWS)) << 24) |\
> > +                                (((col) % (MATRIX_MAX_COLS)) << 16) |\
> >                                 (val & 0xffff))
> >
> 
> Or maybe we can solve this completely by introducing something like:
> 
> struct matrix_keycode {
>         int row;
>         int col;
>         int value;

Though that triples the space needed to store initial keymaps.

-- 
Dmitry
