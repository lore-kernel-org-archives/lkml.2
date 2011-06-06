Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab1FFTtw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 15:49:52 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50771 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712Ab1FFTtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 15:49:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BAiTVa4uR1VxX+LfCmgXV7gkMgjdSfdtmPej7FTaFyiGeZ/A35p06cyzqpYKDzSBvF
         ZHqn7FYnCd6rgKBGGBh8ihua0u01z2vbDzptlwQNELIEliuxdK5l41HWqxuH9xxorWPM
         JqKdlRasisHUrH55Mzte2F5jkD6hhiSEi1HbU=
Date: Mon, 6 Jun 2011 22:49:23 +0300
From: Dan Carpenter <error27@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: anish <anish198519851985@gmail.com>, devel@driverdev.osuosl.org,
        arnd@arndb.de, lucas.demarchi@profusion.mobi, gregkh@suse.de,
        linux-kernel@vger.kernel.org, jic23@cam.ac.uk,
        manuel.stahl@iis.fraunhofer.de
Subject: Re: [PATCH 1/2] staging: iio replaced kmalloc with local variables.
Message-ID: <20110606194923.GC3846@shale.localdomain>
References: <1307387257.4327.12.camel@anish-desktop>
 <BANLkTinyeBMi9LiMx0jicMLLBo=cOKdomw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinyeBMi9LiMx0jicMLLBo=cOKdomw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 09:13:29PM +0200, Geert Uytterhoeven wrote:
> On Mon, Jun 6, 2011 at 21:07, anish <anish198519851985@gmail.com> wrote:
> > From: anish kumar <anish198519851985@gmail.com>
> >
> > Replace kmalloc with local variables as it was un-necessary and
> 
> Is it really unnecessary?
> Or is this hardware that cannot transfer buffers on the stack?
> IIRC there have been similar problems with SCSI command buffers on the stack.

Yes.  You're right.  These buffers are not allowed to be stack
memory.  The documentation is the section "What memory is DMA'able?"
in Documentation/DMA-API-HOWTO.txt.

regards,
dan carpenter

