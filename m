Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309Ab1ECKaG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 06:30:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179Ab1ECKaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 06:30:04 -0400
Message-ID: <4DBFD919.3090409@redhat.com>
Date: Tue, 03 May 2011 07:29:45 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>, Hans de Goede <hdegoede@redhat.com>,
        Joerg Heckenbach <joerg@heckenbach-aw.de>,
        Dwaine Garden <dwainegarden@rogers.com>, linux-media@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usbvision: remove (broken) image format conversion
References: <201104252323.20420.linux@rainbow-software.org> <4DB6B28D.5090607@redhat.com> <f2291b622da20d240c4ebe0ae72beb8c.squirrel@webmail.xs4all.nl> <201104262240.40497.linux@rainbow-software.org>
In-Reply-To: <201104262240.40497.linux@rainbow-software.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 26-04-2011 17:40, Ondrej Zary escreveu:
> On Tuesday 26 April 2011 14:33:20 Hans Verkuil wrote:

> After digging in the code for hours, I'm giving this up. It's not worth it.
> 
> The ISOC_MODE_YUV422 mode works as V4L2_PIX_FMT_YVYU with VLC and 
> mplayer+libv4lconvert, reducing the loop (and dropping strech_*) in 
> usbvision_parse_lines_422() to:
>  scratch_get(usbvision, frame->data + (frame->v4l2_linesize * frame->curline),
>  2 * frame->frmwidth);
> 
> The ISOC_MODE_YUV420 is some weird custom format with 64-byte lines of YYUV. 
> usbvision_parse_lines_420() is real mess with that scratch_* crap everywhere.
> 
> ISOC_MODE_COMPRESS: There are callbacks to usbvision_request_intra() and also 
> usbvision_adjust_compression(). This is not going to work outside the kernel.
> 
> 
> So I can redo the conversion removal patch to keep the RGB formats and also 
> provide another one to remove the testpattern (it oopses too). But I'm not 
> going to do any major changes in the driver.

While in a perfect world, this should be moved to userspace, I'm ok on keeping
it there, but the OOPS/Panic conditions should be fixed.

Could you please work on a patch fixing the broken stuff, without removing the
conversions?

Thanks,
Mauro
 

