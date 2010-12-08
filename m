Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab0LHX6P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 18:58:15 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51643 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab0LHX6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 18:58:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Wj3R4oX5Lv39MmT4kg/A2yDnXeaMR9pn5ktw9yeT9BJ++/qmtjsJOzitmeAlAY8CQt
         NIKLcgJQj9KvxMTPhKtusTe9FGakCQvnXOiSvNRWUt3Vj0YHYyhmGoHPDVvAhjfmd6Do
         OSy0000M1YVgMTGY91CyXhXCUEovtdpWlmB3Q=
Date: Wed, 8 Dec 2010 15:58:06 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ping Cheng <pinglinux@gmail.com>
Cc: Chase Douglas <chase.douglas@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: mt: Add an envelope tool type
Message-ID: <20101208235805.GE15294@core.coreip.homeip.net>
References: <1291721340-22652-1-git-send-email-rydberg@euromail.se>
 <4CFFC3C2.1080905@canonical.com>
 <AANLkTikmomm2hd7AAJMTnY+=J2wPyVvodv2Ft0jFe7w2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikmomm2hd7AAJMTnY+=J2wPyVvodv2Ft0jFe7w2@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 03:43:51PM -0800, Ping Cheng wrote:
> On Wed, Dec 8, 2010 at 9:43 AM, Chase Douglas
> <chase.douglas@canonical.com> wrote:
> > On 12/07/2010 03:29 AM, Henrik Rydberg wrote:
> >> Some touch devices are capable of detecting the envelope or hull
> >> of the touches, but not the touches themselves. This patch adds
> >> the MT_TOOL_ENVELOPE touch type to be used for such devices.
> >>
> >> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> >> ---
> >> Hi all,
> >>
> >> This patch represents an MT solution for those devices that can detect
> >> and report some effects of dual touch, but cannot report individual
> >> contacts. Synaptics and elantech are two examples. Having the drivers
> >> report the bounding rectangle of the touches is useful in userland,
> >> since the information makes it possible to implement zooming
> >> gestures. At the same time, it would be confusing to send these
> >> envelope points as fingers, since they clearly are not. As a remedy,
> >> introduce MT_TOOL_ENVELOPE, which tells applications that care about
> >> details that these are not real fingers, at the same time as it allows
> >> gesture applications based on MT data to function without
> >> modification.
> >
> > Is it assumed that the envelop has only two touches comprising it? Or is
> > it any number of touches? If it's any number of touches, how does one
> > know how many touches it is?
> 
> Those are good questions. Specifying how many touches are in the
> envelop makes sense. It also covers rectangle as a special case of
> envelop.

I have a feeling that trying to accomodate non-rectangular, more than 2
point shapes without using native MT data is over-engineering the
problem... Do we have examples other than older generation Elantechs and
Synaptics that need envelope notion?

-- 
Dmitry
