Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab0LOVwh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 16:52:37 -0500
Received: from mail-iw0-f180.google.com ([209.85.214.180]:38926 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040Ab0LOVwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 16:52:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=dfHHf/N0q6Rt3Wm379YVJsiNPX3HHx3uh+mQwkBJV9ObGBpAcwHCngEUs5Or36j1sn
         ESNSrJsOU+yaBY/8xc+dErD5wnS3/KknRsJQKrCYNOd54pb840pKnpoDSUUMHUMoE/jr
         b6Zlf2tPcWPIC0/rvF6HpzyffiJXiILhPDMSk=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Chase Douglas <chase.douglas@canonical.com>
Subject: Re: [RFC v2] input: Introduce device information ioctl
Date: Wed, 15 Dec 2010 13:52:22 -0800
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc5+; KDE/4.5.3; x86_64; ; )
Cc: Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Ping Cheng <pingc@wacom.com>, Chris Bagwell <chris@cnpbagwell.com>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1292440807-18502-1-git-send-email-rydberg@euromail.se> <4D09302C.4000309@canonical.com>
In-Reply-To: <4D09302C.4000309@canonical.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012151352.23229.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 15, 2010 01:16:28 pm Chase Douglas wrote:
> On 12/15/2010 02:20 PM, Henrik Rydberg wrote:
> > Today, userspace sets up an input device based on the data it emits.
> > This is not always enough; a tablet and a touchscreen may emit exactly
> > the same data, for instance, but the former should be set up with a
> > pointer whereas the latter does not need to. Recently, a new type of
> > touchpad has emerged where the buttons are under the pad, which
> > changes handling logic without changing the emitted data. This patch
> > introduces a new ioctl, EVIOCGPROP, which enables user access to a set
> > of device properties useful during setup. The properties are given as
> > a bitmap in the same fashion as the event types.
> > 
> > Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> > ---
> > Hi all,
> > 
> > Here is version two of the device information proposal. In addition to
> > implementing the feedback, this version only defines a single combined
> > type/capabilities field. Since we want to support a device being of
> > multiple types, it suggests that we are really after the properties
> > that make up a type, rather than the types themselves. And since
> > quirks are also properties, we end up with a single bitmap of
> > properties instead.
> > 
> > As an example of how this would work for the
> > touchpad/tablet/touchscreen triplet, there are two properties defined,
> > INPUT_PROP_POINTER and INPUT_PROP_DIRECT. A touchpad is an indirect
> > pointer device, a tablet is a direct pointer device, and the
> > touchscreen is simply a direct device.
> > 
> > What do you think?
> 
> I must have missed the first version of this patch, but I give two
> thumbs way up :). The detection code for touchpad/tablet/touchscreen in
> xf86-input-evdev is large and unwieldy, and seemingly simple changes to
> an input driver can cause incorrect interpretation. Having this
> available should help quite a bit!
> 
> Acked-by: Chase Douglas <chase.douglas@canonical.com>

As long as we document that !pointer && !direct means "unknown" or
"unspecified" so as to avoid having to update all devices at once that
should be OK.

We also need to wire up uinput.

Thanks.

-- 
Dmitry
