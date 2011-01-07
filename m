Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab1AGAYc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 19:24:32 -0500
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:51296 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752671Ab1AGAYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 19:24:31 -0500
Date: Thu, 06 Jan 2011 19:24:27 -0500
Subject: Re: [RFC/PATCH v7 01/12] media: Media device node support
Message-ID: <0iuif2gxlcatpj50djfn40p8.1294359457034@email.android.com>
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hverkuil@xs4all.nl>, Greg KH <gregkh@suse.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
        clemens@ladisch.de, sakari.ailus@maxwell.research.nokia.com
Content-Type: text/plain; charset=utf-8
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2011-01-06_12:2011-01-07,2011-01-06,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=8
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1012030000 definitions=main-1101060122
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p070dMvn029026

Why, yes, there is a standard:

http://pubs.opengroup.org/onlinepubs/009695399/functions/xsh_chap02_03.html

A somewhat verbose description of the errnos is in section 2.3.

-Andy

Hans Verkuil <hverkuil@xs4all.nl> wrote:

>On Thursday, January 06, 2011 23:19:12 Greg KH wrote:
>
><snip>
>
>> > > > +static ssize_t media_read(struct file *filp, char __user *buf,
>> > > > +		size_t sz, loff_t *off)
>> > > > +{
>> > > > +	struct media_devnode *mdev = media_devnode_data(filp);
>> > > > +
>> > > > +	if (!mdev->fops->read)
>> > > > +		return -EINVAL;
>> > > > +	if (!media_devnode_is_registered(mdev))
>> > > > +		return -EIO;
>> > > 
>> > > How could this happen?
>> > 
>> > This can happen when a USB device is disconnected for instance.
>> 
>> But what's to keep that from happening on the next line as well?
>
>Nothing.
>
>> That
>> doesn't seem like a check you can ever be sure about, so I wouldn't do
>> it at all.
>
>Actually, there is a reason why this was done for v4l (and now the media
>API): typically, once a USB disconnect happens V4L drivers will call
>video_unregister_device() which calls device_unregister. Afterwards the
>device node should reject any new file operations except for release().
>
>Obviously, this check can be done in the driver as well, but doing this
>check in the V4L core has the advantage of 1) consistent return codes and
>2) drivers no longer have to check.
>
>Of course, since the disconnect can happen at any time drivers still need
>to be able to handle errors from the USB subsystem due to disconnects, but
>that is something they always have to do.
>
>> 
>> > > And are you sure -EIO is correct?
>> > 
>> > -ENXIO is probably better (I always confuse that with -ENODEV).
>
>I wondered why V4L uses -EIO and I think it is related to the V4L2 specification
>of the read() function:
>
>EIO
>I/O error. This indicates some hardware problem or a failure to communicate with
>a remote device (USB camera etc.).
>
>Well, I guess a disconnect can be seen as a failure to communicate :-)
>
>I think that ENODEV is much better. After all, there is no device
>anymore after a disconnect.
>
>Is there some standard for this?
>
>Regards,
>
>	Hans
>
>-- 
>Hans Verkuil - video4linux developer - sponsored by Cisco
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
