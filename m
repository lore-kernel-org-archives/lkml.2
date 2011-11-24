Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750873Ab1KXFIk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 00:08:40 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:52180 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab1KXFIi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 00:08:38 -0500
From: =?iso-8859-1?q?G=FCnter_Kukkukk?= <linux@kukkukk.com>
Organization: =?iso-8859-1?q?Entwicklungsb=FCro_f=FCr?= Informationstechnologien
To: samba-technical@lists.samba.org
Subject: Re: CIFS: Rename bug on servers not supporting inode numbers
Date: Thu, 24 Nov 2011 06:08:29 +0100
User-Agent: KMail/1.13.7 (Linux/3.1.0-46-default; KDE/4.6.5; i686; ; )
Cc: Amit Sahrawat <amit.sahrawat83@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-cifs@vger.kernel.org,
        NamJae Jeon <linkinjeon@gmail.com>, Jeff Layton <jlayton@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Steve French <sfrench@samba.org>,
        Steve French <smfrench@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, ashishsangwan2@gmail.com,
        akpm@linux-foundation.org, Anton Altaparmakov <aia21@cam.ac.uk>,
        Unix Support <unix-support@ucs.cam.ac.uk>
References: <CAKYAXd965Md2D4mnDbROoNcKZPQs2dERh8y7aDHtoJ+FJcK1QQ@mail.gmail.com> <20111123171245.3e3f18a7@lxorguk.ukuu.org.uk> <CADDb1s2OcfjwAJoTTbR6547hDL68PJFg_jD_vAs-nGmgiO6YWQ@mail.gmail.com>
In-Reply-To: <CADDb1s2OcfjwAJoTTbR6547hDL68PJFg_jD_vAs-nGmgiO6YWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201111240608.31146.linux@kukkukk.com>
X-Provags-ID: V02:K0:/o3BcvdCcDP6kGVTEy+4oOI++gDxgAUPLtfQPSD+d6T
 RqpbVSvoCzgkIyOoFbVNkWEr8GdQBaXU5gT3klUx3go+Q6PvIN
 lvYi7IWIkJJBx4LYim4PBVeKB0iaxQ5JYQWAPMqj6luANsYc9q
 cUEYJ3DWtmTKa/nydyGLmzwjjaJGrbpDC1HkFVF+U8WwVkwrCG
 1aTxPspxXLHy7VTGfgNLLQDTdED25uIFGqUngm7EoAv4Ky9oW+
 Kh5gEU7thK0RsCAYYo/NAeonxe87hUHzxaz3847/AShWeH7NzO
 MA30J7p5zh3h0pb5idNMRs77wXhTFNlW1mveWt5LKMhTLgEScN
 /UMzC6p+VdfJtTeD0cfY4W6Ds/r0BvmaBMBoLSnlW
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 November 2011 19:00:16 Amit Sahrawat wrote:
> Hi Alan,
> Ok, translations cannot be added easily. But any idea why surrogate
> pairs are not handled? I think handling for surrogate pairs can be
> added by identifying proper points(there are not many I guess). Please
> share your views.
> 
> Regards,
> Amit Sahrawat
> 
> On Wed, Nov 23, 2011 at 10:42 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > On Wed, 23 Nov 2011 11:31:47 -0500 (EST)
> > 
> > Alan Stern <stern@rowland.harvard.edu> wrote:
> >> On Wed, 23 Nov 2011, NamJae Jeon wrote:
> >> > Hi. Alan.
> >> > Would you know why there is no upper/lower case table in nls utf8 ?
> >> > And Currently Surrogate pair is not supported also in nls utf8. Is
> >> > there the reason ?
> >> 
> >> I don't know.
> > 
> > For one case translations are locale specific and very very complicated.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> > in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/

"Surrogate pairs" had to been implemented to extend the former
16 bit limit of UCS-2/UTF-16.

Unicode has been limited to max 0x0010FFFF glyphs - which
would not fit in UCS-2/UTF-16.

To extend UTF-16, the "surrogate range" between D800 and DFFF was "stolen" 
from the one of the previously named "Private Use Areas" of UCS-2.
-----

Have those "surrogate pairs" any impact on _todays_ linux file name conventions?

I think the easy answer is NO !

AFAIK - _no_ current operating system is supporting this!

We are talking here about "allowed dir/file name characters"!

The main reason behind "Surrogate pairs" was to allow "userland" (!)
applications to use worldwide special character glyphs!
---------

Anyway - in nls_base.c
.....
static const struct utf8_table utf8_table[] =
{
    {0x80,  0x00,   0*6,    0x7F,           0,         /* 1 byte sequence */},
    {0xE0,  0xC0,   1*6,    0x7FF,          0x80,      /* 2 byte sequence */},
    {0xF0,  0xE0,   2*6,    0xFFFF,         0x800,     /* 3 byte sequence */},
    {0xF8,  0xF0,   3*6,    0x1FFFFF,       0x10000,   /* 4 byte sequence */},
    {0xFC,  0xF8,   4*6,    0x3FFFFFF,      0x200000,  /* 5 byte sequence */},
    {0xFE,  0xFC,   5*6,    0x7FFFFFFF,     0x4000000, /* 6 byte sequence */},
    {0,						       /* end of table    */}
};
........
that configured range exceeds the max. allowed unicode range 0x0010FFFF
and _must_ be changed to:

static const struct utf8_table utf8_table[] =
{
    {0x80,  0x00,   0*6,    0x7F,           0,         /* 1 byte sequence */},
    {0xE0,  0xC0,   1*6,    0x7FF,          0x80,      /* 2 byte sequence */},
    {0xF0,  0xE0,   2*6,    0xFFFF,         0x800,     /* 3 byte sequence */},
    {0xF8,  0xF0,   3*6,    0x1FFFFF,       0x10000,   /* 4 byte sequence */},
    {0,						       /* end of table    */}
};

Cheers, Günter
