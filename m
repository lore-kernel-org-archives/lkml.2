Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab2HIJYw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 05:24:52 -0400
Received: from mail.x86-64.org ([217.9.48.20]:45712 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752873Ab2HIJYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 05:24:51 -0400
Date: Thu, 9 Aug 2012 11:24:46 +0200
From: Borislav Petkov <bp@amd64.org>
To: Amit Shah <amit.shah@redhat.com>
Cc: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        linux-kernel@vger.kernel.org, Anthony Liguori <anthony@codemonkey.ws>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@amd64.org>,
        "Franch Ch. Eigler" <fche@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Ingo Molnar <mingo@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        virtualization@lists.linux-foundation.org, qemu-devel@nongnu.org,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [RFC PATCH 2/6] virtio/console: Add a failback for unstealable
 pipe buffer
Message-ID: <20120809092446.GB27761@aftab.osrc.amd.com>
References: <20120724023657.6600.52706.stgit@ltc189.sdl.hitachi.co.jp>
 <20120724023718.6600.68836.stgit@ltc189.sdl.hitachi.co.jp>
 <20120809090312.GH3280@amit.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120809090312.GH3280@amit.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2012 at 02:33:12PM +0530, Amit Shah wrote:
> > @@ -807,9 +807,31 @@ static int pipe_to_sg(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
> >  
> >  		len = min(buf->len, sd->len);
> >  		sg_set_page(&(sgl->sg[sgl->n]), buf->page, len, buf->offset);
> > -		sgl->n++;
> > -		sgl->len += len;
> > +	} else {
> > +		/* Failback to copying a page */
> > +		struct page *page = alloc_page(GFP_KERNEL);
> 
> I prefer zeroing out the page.  If there's not enough data to be
> filled in the page, the remaining data can be leaked to the host.

get_zeroed_page()?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
