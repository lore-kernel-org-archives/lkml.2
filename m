Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456Ab2AQIbP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 03:31:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189Ab2AQIbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 03:31:12 -0500
Date: Tue, 17 Jan 2012 09:28:43 +0100
From: Andrew Jones <drjones@redhat.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jerome Marchand <jmarchan@redhat.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, rientjes@google.com, mingo@elte.hu,
        david.woodhouse@intel.com, gregkh@suse.de, davem@davemloft.net,
        axboe@kernel.dk, arnd@arndb.de, holt@sgi.com,
        linux-arch@vger.kernel.org, linux@arm.linux.org.uk,
        hskinnemoen@gmail.com, egtvedt@samfundet.no, msalter@redhat.com,
        a-jacquiot@ti.com, starvik@axis.com, jesper.nilsson@axis.com,
        dhowells@redhat.com, takata@linux-m32r.org,
        yasutake.koichi@jp.panasonic.com, jonas@southpole.se, kyle@mcmartin.ca,
        deller@gmx.de, jejb@parisc-linux.org, chris@zankel.net, greg@kroah.com,
        davej@redhat.com, airlied@linux.ie, jkosina@suse.cz,
        mchehab@infradead.org, johannes@sipsolutions.net,
        linville@tuxdriver.com
Subject: Re: [PATCH] kconfig: untangle EXPERT and EMBEDDED
Message-ID: <20120117082842.GA3188@turtle.usersys.redhat.com>
References: <1326295008-29795-1-git-send-email-drjones@redhat.com>
 <4F1444FF.60205@redhat.com>
 <20120116155004.GA6999@turtle.usersys.redhat.com>
 <CAMuHMdV=yhacfyS691kdzXNOTcOEWi-AxPcUDquYci3=J3AhMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdV=yhacfyS691kdzXNOTcOEWi-AxPcUDquYci3=J3AhMQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 06:34:44PM +0100, Geert Uytterhoeven wrote:
> On Mon, Jan 16, 2012 at 16:50, Andrew Jones <drjones@redhat.com> wrote:
> > On Mon, Jan 16, 2012 at 04:40:47PM +0100, Jerome Marchand wrote:
> >> > @@ -1259,8 +1259,7 @@ config SLUB
> >> >        a slab allocator.
> >> >
> >> >  config SLOB
> >> > -   depends on EXPERT
> >> > -   bool "SLOB (Simple Allocator)"
> >> > +   bool "SLOB (Simple Allocator)" if EXPERT
> >> >     help
> >> >        SLOB replaces the stock allocator with a drastically simpler
> >> >        allocator. SLOB is generally more space efficient but
> >>
> >> Am I missing something or this particular chunk does not actually change
> >> anything?
> >
> > No, you're correct. There's no actual change, so the hunk could be dubbed
> > as an unnecessary cleanup. I made the change in order to give it the same
> > general format as the rest of the expert options in that file.
> 
> There _is_ a difference:
>   - "depends on EXPERT" means the option cannot be enabled by the user.
>     "select SLOB" will still override that, but kconf will print a warning.
>   - "bool ... if EXPERT" means the question will only be asked if EXPERT.
>     Other Kconfig logic can still "select SLOB" if it wants to.
>

No, they are equivalent. It says in the documentation
(Documentation/kbuild/kconfig-language.txt)

    - dependencies: "depends on" <expr>
      This defines a dependency for this menu entry. If multiple
      dependencies are defined, they are connected with '&&'. Dependencies
      are applied to all other options within this menu entry (which also
      accept an "if" expression), so these two examples are equivalent:

            bool "foo" if BAR
            default y if BAR
      and
            depends on BAR
            bool "foo"
            default y

SLOB doesn't have a default option in its entry (it actually can't, since
it's a choice value), or any other option type besides help, so the change
in the patch above is precisely equivalent.

If you got a warning with one style, but not the other, then that would be
a bug with kconf. However, I just tried to generate a warning with both
styles and couldn't.

Drew
