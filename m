Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab2EELXM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 07:23:12 -0400
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3481 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554Ab2EELXK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 07:23:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH 1/1] v4l2: use __u32 rather than enums in ioctl() structs
Date: Sat, 5 May 2012 13:22:32 +0200
User-Agent: KMail/1.13.7 (Linux/3.4.0-rc3-tschai; KDE/4.7.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        mchehab@redhat.com, remi@remlab.net
References: <1336213545-8549-1-git-send-email-sakari.ailus@iki.fi> <201205051255.01321.hverkuil@xs4all.nl> <20120505111410.GH852@valkosipuli.localdomain>
In-Reply-To: <20120505111410.GH852@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201205051322.32640.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat May 5 2012 13:14:10 Sakari Ailus wrote:
> Hi Hans,
> 
> On Sat, May 05, 2012 at 12:55:01PM +0200, Hans Verkuil wrote:
> > On Sat May 5 2012 12:25:45 Sakari Ailus wrote:
> > > From: Rémi Denis-Courmont <remi@remlab.net>
> > > 
> > > V4L2 uses the enum type in IOCTL arguments in IOCTLs that were defined until
> > > the use of enum was considered less than ideal. Recently Rémi Denis-Courmont
> > > brought up the issue by proposing a patch to convert the enums to unsigned:
> > > 
> > > <URL:http://www.spinics.net/lists/linux-media/msg46167.html>
> > > 
> > > This sparked a long discussion where another solution to the issue was
> > > proposed: two sets of IOCTL structures, one with __u32 and the other with
> > > enums, and conversion code between the two:
> > > 
> > > <URL:http://www.spinics.net/lists/linux-media/msg47168.html>
> > > 
> > > Both approaches implement a complete solution that resolves the problem. The
> > > first one is simple but requires assuming enums and __u32 are the same in
> > > size (so we won't break the ABI) while the second one is more complex and
> > > less clean but does not require making that assumption.
> > > 
> > > The issue boils down to whether enums are fundamentally different from __u32
> > > or not, and can the former be substituted by the latter. During the
> > > discussion it was concluded that the __u32 has the same size as enums on all
> > > archs Linux is supported: it has not been shown that replacing those enums
> > > in IOCTL arguments would break neither source or binary compatibility. If no
> > > such reason is found, just replacing the enums with __u32s is the way to go.
> > > 
> > > This is what this patch does. This patch is slightly different from Remi's
> > > first RFC (link above): it uses __u32 instead of unsigned and also changes
> > > the arguments of VIDIOC_G_PRIORITY and VIDIOC_S_PRIORITY.
> > > 
> > > Signed-off-by: Rémi Denis-Courmont <remi@remlab.net>
> > > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > > ---
> > >  include/linux/videodev2.h |   46 ++++++++++++++++++++++----------------------
> > >  1 files changed, 23 insertions(+), 23 deletions(-)
> > > 
> > > diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> > > index 5a09ac3..585e4b4 100644
> > > --- a/include/linux/videodev2.h
> > > +++ b/include/linux/videodev2.h
> > > @@ -292,10 +292,10 @@ struct v4l2_pix_format {
> > >  	__u32         		width;
> > >  	__u32			height;
> > >  	__u32			pixelformat;
> > > -	enum v4l2_field  	field;
> > > +	__u32			field;
> > 
> > One suggestion: add a comment like this:
> > 
> > 	__u32			field; /* refer to enum v4l2_field */
> > 
> > This keeps the link between the u32 and the enum values.
> > 
> > Note that the DocBook documentation also has to be updated.

And v4l2-compat-ioctl32 as well! :-) That too has enums in the compat structs.

Regards,

	Hans

> > 
> > Looks good to me otherwise.
> 
> Thanks for the comments. I'll make the above changes.
> 
> Cheers,
> 
> 
