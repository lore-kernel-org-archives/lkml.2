Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130Ab1LMF73 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 00:59:29 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:58577 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab1LMF71 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 00:59:27 -0500
X-AuditID: cbfee61a-b7b89ae000001a15-9f-4ee6e9bdc00a
From: "HeungJun, Kim" <riverful.kim@samsung.com>
To: "'Ming Lei'" <ming.lei@canonical.com>
Cc: "'Sylwester Nawrocki'" <snjw23@gmail.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
References: <1322838172-11149-1-git-send-email-ming.lei@canonical.com>
 <1322838172-11149-7-git-send-email-ming.lei@canonical.com>
 <4EDD3DEE.6060506@gmail.com>
 <CACVXFVPrAro=3t-wpbR_cVahzcx7SCa2J=s2nyyKfQ6SG-i0VQ@mail.gmail.com>
 <4EDE90A3.7050900@gmail.com>
 <CACVXFVN=-0OQ_Tz+HznDug4baLmLNjxVE21gv6CGFoU+hzCtPQ@mail.gmail.com>
 <4EE14787.8090509@gmail.com>
 <CACVXFVNV3TLNvPMU4oj6X+Yj5wqhNvcU_ZpyCd1wMm8B2azT4w@mail.gmail.com>
 <4EE4EBCF.8000202@gmail.com>
 <CACVXFVNjawdPEYHoXNxc3U2-H8f4VVF_+2HDruNGQwg16M8njA@mail.gmail.com>
 <000d01ccb8c6$bf235160$3d69f420$%kim@samsung.com>
 <CACVXFVNBagCuxF7g5ZpGRR9PoPsR4MkacmmNp=YiHXNGOpnWyw@mail.gmail.com>
In-reply-to: <CACVXFVNBagCuxF7g5ZpGRR9PoPsR4MkacmmNp=YiHXNGOpnWyw@mail.gmail.com>
Subject: RE: [RFC PATCH v1 6/7] media: video: introduce face detection driver
 module
Date: Tue, 13 Dec 2011 14:59:24 +0900
Message-id: <002f01ccb95c$5de23f60$19a6be20$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Acy5S+0xb26Ako+YSreUUjMdyKOdbAACUFiw
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ming and Sylwester,

Thanks for the reply.

> -----Original Message-----
> From: Ming Lei [mailto:ming.lei@canonical.com]
> Sent: Tuesday, December 13, 2011 1:02 PM
> To: HeungJun, Kim
> Cc: Sylwester Nawrocki; linux-omap@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; linux-kernel@vger.kernel.org; linux-
> media@vger.kernel.org
> Subject: Re: [RFC PATCH v1 6/7] media: video: introduce face detection driver
> module
> 
> Hi,
> 
> On Mon, Dec 12, 2011 at 8:08 PM, HeungJun, Kim <riverful.kim@samsung.com>
wrote:
> > Hi Ming,
> >
> > It's maybe late, but I want to suggest one thing about FD API.
> >
> > This OMAP FD block looks detection ability of just face.
> > But, It's possible to occur another device which can detect
> > specific "object" or "patterns". Moreover, this API can expand
> > "object recognition" area. So, I think it's good to change the API name
> > like "v4l2_recog".
> 
> IMO, object detection is better,  at least now OMAP4 and samsung has
> face detection IP module, and face recognition is often done on results
> of face detection and more complicated interfaces will be involved.
Actually, the detection point is different, I guess.
The OMAP has the detection block separately, named FDIF. But, Samsung
Exynos doing detection process with externel sensor - m5mols, in our case.
This sensor(m5mols) has ISP function, and these ISP can process detection.
The expert of FIMC is Sylwester. Probably, he can tell the differences
between both in more details. :)

> 
> >
> > Actually, I'm preparing similar control class for mainline with m5mols
> > camera sensor driver. The m5mols camera sensor has the function about
> > "face detection". But, I has experienced about Robot Recognition, and I
> > remember the image processing chip which can detect spefic "pattern".
> > So, I hesitated naming the API(control or ioctl whatever) with "face".
> > It can be possible to provide just "object" or "pattern", not face.
> > Even user library on windows, there is famous "OpenCV". And this is also
> > support not only "face", but also "object".
> 
> Yes, object is better than face, and we can use enum flag to describe that
> the objects detected are which kind of objects. In fact, I plan to rename the
> face detection generic driver as object detection generic driver and let
> hardware driver to handle the object detection details.
> 
> >
> > The function of OMAP FDIF looks like m5mols ISP's one.
> > please understand I don't have experience about OMAP AP. But, I can tell
> > you it's better to use the name "object recognition", not the "face
> detection",
> > for any other device or driver.
> >
> > In a few days, I'll share the CIDs I have thought for m5mols driver.
> > And, I hope to discuss about this with OMAP FDIF.
> 
> You have been doing it already, :-)
Yeah, actually I did. :)
But, until I see OMAP FDIF case, I did not recognize AP(like OMAP) can
have detection capability. :) So, although I did not think about at that time,
I also think we should re-consider this case for now.

As I look around your patch quickly, the functions is very similar with ours.
(even detection of left/right eye)
So, the problem is there are two ways to proceed "recognition".
- Does it handle at the level of IOCTLs? or CIDs?

If the detection algorithm is proceeded at the level of HW block,
it's right the platform driver provide APIs as IOCTLs(as you're FDIF patches).
On the other hand, if it is proceeded at the sensor(subdevice) level,
I think it's more right to control using CIDs.

We need the solution including those two cases.
And the name - object detection? object recognition?

So, do you have any good ideas?

ps. There can be another not-matched HW block level issues.
But, the problem which I can check is just above issue for now.


Thanks,
Heungjun Kim


> 
> thanks,
> --
> Ming Lei
> 
> >
> > Thank you.
> >
> > Regards,
> > Heungjun Kim
> >
> >
> >> -----Original Message-----
> >> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> >> owner@vger.kernel.org] On Behalf Of Ming Lei
> >> Sent: Monday, December 12, 2011 6:50 PM
> >> To: Sylwester Nawrocki
> >> Cc: linux-omap@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
linux-
> >> kernel@vger.kernel.org; linux-media@vger.kernel.org
> >> Subject: Re: [RFC PATCH v1 6/7] media: video: introduce face detection
> driver
> >> module
> >>
> >> Hi,
> >>
> >> On Mon, Dec 12, 2011 at 1:43 AM, Sylwester Nawrocki <snjw23@gmail.com>
> >>
> >> >> For OMAP4 FD, it is not needed to include FD into MC framework since a
> >> >> intermediate buffer is always required. If your HW doesn't belong to
this
> >> >> case, what is the output of your HW FD in the link? Also sounds FD
> results
> >> >> may not be needed at all for use space application in the case.
> >> >
> >> > The result data is similar to OMAP4 one, plus a few other attributes.
> >> > User buffers may be filled by other than FD device driver.
> >>
> >> OK.
> >>
> >>
> >> >> Could you provide some practical use cases about these?
> >> >
> >> > As above, and any device with a camera that controls something and makes
> >> > decision according to presence of human face in his view.
> >>
> >> Sounds a reasonable case, :-)
> >>
> >>
> >> >> If FD result is associated with a frame, how can user space get the
frame
> >> seq
> >> >> if no v4l2 buffer is involved? Without a frame sequence, it is a bit
> >> >> difficult to retrieve FD results from user space.
> >> >
> >> > If you pass image data in memory buffers from user space, yes, it could
be
> >> > impossible.
> >>
> >> It is easy to get the frame sequence from v4l2_buffer for the case too, :-)
> >>
> >> >
> >> > Not really, still v4l2_buffer may be used by other (sub)driver within
same
> >> video
> >> > processing pipeline.
> >>
> >> OK.
> >>
> >> A related question: how can we make one application to support the two
kinds
> > of
> >> devices(input from user space data as OMAP4, input from SoC bus as Samsung)
> >> at the same time? Maybe some capability info is to be exported to user
space?
> >> or other suggestions?
> >>
> >> And will your Samsung FD HW support to detect faces from memory? or just
> only
> >> detect from SoC bus?
> >>
> >>
> >> > It will be included in the FD result... or in a dedicated v4l2 event data
> >> structure.
> >> > More important, at the end of the day, we'll be getting buffers with
image
> >> data
> >> > at some stage of a video pipeline, which would contain same frame
> identifier
> >> > (I think we can ignore v4l2_buffer.field for FD purpose).
> >>
> >> OK, I will associate FD result with frame identifier, and not invent a
> >> dedicated v4l2 event for query frame seq now until a specific requirement
> >> for it is proposed.
> >>
> >> I will convert/integrate recent discussions into patches of v2 for further
> >> review, and sub device support will be provided. But before starting to do
> it,
> >> I am still not clear how to integrate FD into MC framework. I understand FD
> >> sub device is only a media entity, so how can FD sub device find the media
> >> device(struct media_device)?  or just needn't to care about it now?
> >>
> >>
> >> thanks,
> >> --
> >> Ming Lei
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

