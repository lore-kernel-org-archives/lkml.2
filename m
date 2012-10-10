Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404Ab2JJWoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 18:44:18 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:41103 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757215Ab2JJWoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 18:44:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Igor Murzov <e-mail@date.by>
Cc: linux-acpi@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Len Brown <lenb@kernel.org>, Sergey V <sftp.mtuci@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI video: Ignore AE_AML_PACKAGE_LIMIT errors after _DOD evaluation.
Date: Thu, 11 Oct 2012 00:47:52 +0200
Message-ID: <2002421.N00NXsf7OO@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.6.0-2.10-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <20121010044340.3abe82bd@garik-laptop.linux.org>
References: <1349821146-19155-1-git-send-email-e-mail@date.by> <1357974.cUcUJdG05H@vostro.rjw.lan> <20121010044340.3abe82bd@garik-laptop.linux.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 of October 2012 04:43:40 Igor Murzov wrote:
> On Wed, 10 Oct 2012 00:58:10 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Wednesday 10 of October 2012 02:19:06 Igor Murzov wrote:
> > > This should fix brightness controls on some laptops.
> > > Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=47861
> > > 
> > > Signed-off-by: Igor Murzov <e-mail@date.by>
> > 
> > Put more detials into the changelog, please.  The BZ entry linked above
> > may or may not be accessible when the changelog is read by someone.
> > 
> > > ---
> > >  drivers/acpi/video.c | 8 ++++++--
> > >  1 file changed, 6 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
> > > index 1e0a9e1..01bb58d 100644
> > > --- a/drivers/acpi/video.c
> > > +++ b/drivers/acpi/video.c
> > > @@ -1349,8 +1349,12 @@ acpi_video_bus_get_devices(struct acpi_video_bus *video,
> > >  	struct acpi_device *dev;
> > >  
> > >  	status = acpi_video_device_enumerate(video);
> > > -	if (status)
> > > -		return status;
> > > +	if (status) {
> > > +		if (status == AE_AML_PACKAGE_LIMIT)
> > > +			status = 0; /* Ignore this error */
> > > +		else
> > > +			return status;
> > > +	}
> > 
> > First off, please add a comment explaining _why_ we're ignoring the error.
> 
> The problem is that i'm not sure if it's ok to ignore
> AE_AML_PACKAGE_LIMIT here.

This should be written in a comment, then. :-)

> Stefan Wilkens in bugzilla
> claims that video module works fine on his Compaq 6720s
> in spite of the fact that acpi_video_device_enumerate()
> is not able to find any video device on his laptop.
> This fix is just the most obvious one, not necessarily
> the proper one.

So say something like "there are systems known to return AE_AML_PACKAGE_LIMIT
here, apparently for no valid reason" in a comment.  And give a reference to
the BZ entry in the changelog.

There are too many places where we have put workarounds like this without
documenting them properly and now we have problems when we need to change
something.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
