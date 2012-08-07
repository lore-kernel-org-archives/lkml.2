Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276Ab2HGU4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 16:56:38 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:44666 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab2HGU4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 16:56:36 -0400
Date: Tue, 7 Aug 2012 13:56:31 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Colin Cross <ccross@android.com>
Cc: linux-kernel@vger.kernel.org, Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>,
        linux-leds@vger.kernel.org
Subject: Re: [PATCH v2] leds: triggers: send uevent when changing triggers
Message-ID: <20120807205631.GA3889@kroah.com>
References: <1344369495-21943-1-git-send-email-ccross@android.com>
 <20120807204228.GA32389@kroah.com>
 <CAMbhsRQd6djCh3z3-4mowQqzWZ+RrQKjMBi-NiV3daxJS1L35A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMbhsRQd6djCh3z3-4mowQqzWZ+RrQKjMBi-NiV3daxJS1L35A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 01:47:23PM -0700, Colin Cross wrote:
> On Tue, Aug 7, 2012 at 1:42 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Tue, Aug 07, 2012 at 12:58:15PM -0700, Colin Cross wrote:
> >> Some triggers create sysfs files when they are enabled.  Send a uevent
> >> "change" notification whenever the trigger is changed to allow userspace
> >> processes such as udev to modify permissions on the new files.
> >>
> >> A change notification will also be sent during registration of led class
> >> devices or led triggers if the default trigger of an led class device
> >> is found.
> >
> > Why would a change event be needed at this point in time?  Nothing would
> > have changed from the original "add" notification, right?
> 
> If the led class device has a default trigger configured,
> device_create will called before the trigger has been set and the
> trigger sysfs files have been created.  The "change" notification will
> happen after the extra files have been created.

Ok, that make sense, and is a good reason to send the change event,
thanks for explaining it.

greg k-h
