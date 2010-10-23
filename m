Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769Ab0JWUaB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 16:30:01 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50678 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758296Ab0JWU36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 16:29:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=T+yWrULYenprqbMZ6oCTdw1V0xvlSnefjYBIbykS7uHFOzq3zaz1caUkvFeJwwJTG8
         7wwiJiFK1avwVg/D9/58Cnmv3EhanNx/atPkgYEXfNubMMOEIP14AUTZSp+idJUS13By
         bwidKlnElnY+8X1BHob9KQ2nIx4wvjnURhPuE=
Date: Sat, 23 Oct 2010 22:29:53 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Alon Ziv <alon+git@nolaviz.org>, linux-usb@vger.kernel.org,
        Stefani Seibold <stefani@seibold.net>,
        Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Export usb_serial_generic_write_room for use in
 other modules
Message-ID: <20101023202953.GA10343@localhost>
References: <1287850818-12050-1-git-send-email-alon-git@nolaviz.org>
 <1287850818-12050-2-git-send-email-alon-git@nolaviz.org>
 <20101023163747.GA20381@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101023163747.GA20381@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 23, 2010 at 09:37:47AM -0700, Greg KH wrote:
> On Sat, Oct 23, 2010 at 06:20:17PM +0200, Alon Ziv wrote:
> > Any module using usb_serial_generic_write (which is already exported)
> > had better use usb_serial_generic_write_room as well.
> 
> Are you implying that the one driver using this function today is
> broken?  Care to provide a patch for it as well?

Actually, most usb serial drivers use usb_serial_generic_write as well
as usb_serial_generic_write_room. The generic implementations are used
unless drivers explicitly define their own. So far there has been no
need to export usb_serial_generic_write_room but perhaps Alon's patch
does require this.

Either way the patch description is thus actually wrong (or rather
misleading) as it stands.

I'll try to have a look at the other patch tomorrow.

Johan
