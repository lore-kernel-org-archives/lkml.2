Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab2E1KTp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 06:19:45 -0400
Received: from mga14.intel.com ([143.182.124.37]:17002 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903Ab2E1KTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 06:19:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="148532000"
Date: Mon, 28 May 2012 13:20:57 +0300
From: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: linux-bluetooth@vger.kernel.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, adobriyan@gmail.com,
        andriy.shevchenko@linux.intel.com
Subject: Re: [PATCHv2] vsprintf: Add %pMR for Bluetooth MAC address
Message-ID: <20120528102055.GA3537@aemeltch-MOBL1>
Mail-Followup-To: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	linux-bluetooth@vger.kernel.org, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, adobriyan@gmail.com,
	andriy.shevchenko@linux.intel.com
References: <1337956368-30621-1-git-send-email-andrei.emeltchenko.news@gmail.com>
 <1338195605-22513-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
 <CAHp75Vc3sut7R7FF=xHQ0-3HaydPBh86sNnzRjKP8+ow=SOfLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHp75Vc3sut7R7FF=xHQ0-3HaydPBh86sNnzRjKP8+ow=SOfLg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

On Mon, May 28, 2012 at 01:01:05PM +0300, Andy Shevchenko wrote:
> On Mon, May 28, 2012 at 12:00 PM, Andrei Emeltchenko
> <Andrei.Emeltchenko.news@gmail.com> wrote:
> > From: Andrei Emeltchenko <andrei.emeltchenko@intel.com>
> >
> > Bluetooth uses mostly LE byte order which is reversed for visual
> > interpretation. Currently in Bluetooth in use unsafe batostr function.
> >
> > This is slightly modified version of Joe Perches <joe@perches.com>
> > patch (sent Sat, Dec 4, 2010).
> >
> > Signed-off-by: Andrei Emeltchenko <andrei.emeltchenko@intel.com>
> > ---
> >        v2: changed bluetooth to reversed, syntax fixes
> >
> >  lib/vsprintf.c |   22 +++++++++++++++++-----
> >  1 file changed, 17 insertions(+), 5 deletions(-)
> >
> > diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> > index abbabec..d98b12d 100644
> > --- a/lib/vsprintf.c
> > +++ b/lib/vsprintf.c
> > @@ -557,17 +557,27 @@ char *mac_address_string(char *buf, char *end, u8 *addr,
> >  {
> >        char mac_addr[sizeof("xx:xx:xx:xx:xx:xx")];
> >        char *p = mac_addr;
> > -       int i;
> > +       int i, index;
> >        char separator;
> > +       bool reversed = false;
> >
> > -       if (fmt[1] == 'F') {            /* FDDI canonical format */
> > +       switch (fmt[1]) {
> > +       case 'F':
> >                separator = '-';
> > -       } else {
> > +               break;
> > +
> > +       case 'R':
> > +               reversed = true;
> > +               /* fall through */
> This solution looks a bit limited. On one hand it makes difficult to add another
> case where format specifies colon separator with something else. On
> the other hand

I believe it is good as is for now. The other option would be to name it
as "B" or "b" for bluetooth.

> I don't see any troubles if you allow reverse as a modifier for both
> cases %pMF & %pM

MF is used for FDDI and it makes no sense to reverse it.

> 
> > +
> > +       default:
> >                separator = ':';
> > +               break;
> >        }
> >
> >        for (i = 0; i < 6; i++) {
> > -               p = hex_byte_pack(p, addr[i]);
> > +               index = !reversed ? i : 5 - i;
> > +               p = hex_byte_pack(p, addr[index]);
> I guess instead of using additional variable (index), you could use
> just normal if () {} else {} sentence
> here.

I can change this

Best regards 
Andrei Emeltchenko 
