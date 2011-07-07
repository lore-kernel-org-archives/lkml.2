Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596Ab1GGN1P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 09:27:15 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:51483 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755650Ab1GGN1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 09:27:14 -0400
From: Richard Weinberger <richard@nod.at>
To: Vitaliy Ivanov <vitalivanov@gmail.com>
Subject: Re: [PATCH] uml: free resources
Date: Thu, 7 Jul 2011 15:27:08 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37.6-0.5-desktop; KDE/4.6.5; x86_64; ; )
Cc: dave@gnu.org, Jeff Dike <jdike@addtoit.com>,
        uml <user-mode-linux-devel@lists.sourceforge.net>,
        lkml <linux-kernel@vger.kernel.org>,
        Jim Meyering <meyering@redhat.com>
References: <1310011371.3309.2.camel@offbook> <CAGTPOqdm7_PP68mKLQT3gigmUMD6wpoKk3sSWfXk9jeJPX+_6A@mail.gmail.com>
In-Reply-To: <CAGTPOqdm7_PP68mKLQT3gigmUMD6wpoKk3sSWfXk9jeJPX+_6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107071527.08345.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 07 Juli 2011, 15:08:22 schrieb Vitaliy Ivanov:
> On Thu, Jul 7, 2011 at 7:02 AM, Davidlohr Bueso <dave@gnu.org> wrote:
> > From: Davidlohr Bueso <dave@gnu.org>
> > 
> > When creating the temp file there's a memory and file descriptor leak
> > upon error.
> > 
> > Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> > ---
> >  arch/um/os-Linux/mem.c |    6 ++++--
> >  1 files changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/um/os-Linux/mem.c b/arch/um/os-Linux/mem.c
> > index e696144..62878cf 100644
> > --- a/arch/um/os-Linux/mem.c
> > +++ b/arch/um/os-Linux/mem.c
> > @@ -176,7 +176,7 @@ static int __init make_tempfile(const char *template,
> > char **out_tempname,
> > 
> >        find_tempdir();
> >        if ((tempdir == NULL) || (strlen(tempdir) >= MAXPATHLEN))
> > -               return -1;
> > +               goto out;
> > 
> >        if (template[0] != '/')
> >                strcpy(tempname, tempdir);
> > @@ -191,13 +191,15 @@ static int __init make_tempfile(const char
> > *template, char **out_tempname, }
> >        if (do_unlink && (unlink(tempname) < 0)) {
> >                perror("unlink");
> > -               goto out;
> > +               goto close;
> >        }
> >        if (out_tempname) {
> >                *out_tempname = tempname;
> >        } else
> >                free(tempname);
> >        return fd;
> > +close:
> > +       close(fd);
> >  out:
> >        free(tempname);
> >        return -1;
> > --
> 
> Reviewed-by: Vitaliy Ivanov <vitalivanov@gmail.com>

Applied!

Thanks,
//richard

P.s: Dave, your patch did not show up on user-mode-linux-devel@lists.sourceforge.net nor 
richard@nod.at, is your mailer broken?
