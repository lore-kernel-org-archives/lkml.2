Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394Ab1EKQYA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:24:00 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:44545 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755933Ab1EKQX5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:23:57 -0400
Date: Wed, 11 May 2011 16:27:43 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-fbdev@vger.kernel.org, lethal@linux-sh.org,
        linux-kernel@vger.kernel.org,
        Andy Whitcroft <andy.whitcroft@canonical.com>
Subject: Re: [PATCH V3] fbcon -- fix race between open and removal of
 framebuffers
Message-ID: <20110511162743.6b363f1f@pluto.restena.lu>
In-Reply-To: <4DCA9899.6070403@canonical.com>
References: <1304617307-7389-1-git-send-email-tim.gardner@canonical.com>
	<4DC94314.8050701@canonical.com>
	<20110510234424.5a5b7a08@neptune.home>
	<4DCA9899.6070403@canonical.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 May 2011 16:09:29 Tim Gardner wrote:
> On 05/10/2011 11:44 PM, Bruno Prémont wrote:
> > On Tue, 10 May 2011 Tim Gardner<tim.gardner@canonical.com>  wrote:
> > This only partially protects the list and count as two concurrent
> > framebuffer registrations do still race against each other.
> > For the issue addressed by this patch I don't think it makes sense to
> > have this spinlock at all as it's only used in get_framebuffer_info()
> > and in put_framebuffer_info() and put_framebuffer_info() doesn't even
> > look at registered_fb or num_registered_fb.
> > Such a spinlock makes sense in a separate patch that really protects
> > all access to registered_fb or num_registered_fb, be it during framebuffer
> > (un)registration or during access from fbcon.
> >
> 
> Our goal was merely to stop the user space open/close races. I agree 
> that the framebuffer registration list needs more orthogonal protection, 
> but that is going to be a much larger patch.

I know that such a protection needs a much larger patch. (that would be
for 2.6.40 or 2.6.41, I have preparing patches for that cooking)

My main issue for tis patch is that the comment reads as if spinlock was
protecting registered_fb[] and num_registered_fb. So changing the
comment would be a good thing (say it protects fb_info->ref_count).
Later patch can then protect registered_fb against concurrent
framebuffer registrations.

Bruno
