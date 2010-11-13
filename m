Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419Ab0KMGGo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 01:06:44 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50896 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab0KMGGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 01:06:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kCsxn4BpiZEtq1kI3C0dhfkTcDNh1CfWMBr3H7t6Z1/8U95JEC2wTW35Zh1NpyxntH
         ePcb2+ihLOfkO4E7E9M+9x5VavpsvoltlEbTe/J6Uk8zjyrDqb1Hsu2q3L5g7qoJguF4
         ZebG1JC9HGlY4Tk/Cp2YFAkhqsUOCl+7y6ZqY=
Date: Fri, 12 Nov 2010 22:06:34 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Eric Biederman <ebiederm@aristanetworks.com>,
        Stefan Achatz <stefan_achatz@web.de>,
        "Serge E. Hallyn" <serue@us.ibm.com>, Tejun Heo <tj@kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Benjamin Thery <benjamin.thery@bull.net>
Subject: Re: [PATCH 2/2] HID: roccat: using new sysfs_create_bin_group() in
 kone driver
Message-ID: <20101113060634.GB1919@core.coreip.homeip.net>
References: <1289585921.2629.13.camel@neuromancer>
 <AANLkTik4qPyBtKgJwHVnhkTASNORoKrWms6gk8NirYeU@mail.gmail.com>
 <20101113005232.GA20865@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101113005232.GA20865@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 04:52:32PM -0800, Greg KH wrote:
> On Fri, Nov 12, 2010 at 04:21:45PM -0800, Eric Biederman wrote:
> > On Fri, Nov 12, 2010 at 10:18 AM, Stefan Achatz <stefan_achatz@web.de> wrote:
> > > hid-roccat-kone now uses new group functions for creating binary
> > > sysfs attributes.
> > 
> > Looking at this, I have a problem with the way this works.
> > You are still doing this the hard and racy way.
> > 
> > sysfs attributes that are only added when we initialize the hardware and
> > are only removed when we remove the driver should use the device layer
> > functions to create their attributes.
> > 
> > This achieves two things.  The code is easier to write because there
> > is less of it.
> > The notification to user space happens after the attributes appear so
> > that you don't
> > have strange hotplug races.
> > 
> > If there a chance you can look at implementing this in the simpler
> > race free way?
> 
> Good point, just attach this attribute group to the device and the
> driver core will automatically create the files for you.
> 

Attribute group in device structure is normally owned and managed by
subsystem core; without additional plumbing drivers should not be
touching it, at least not normally.

Plus we do not have binary attribute group in device structure [yet].

-- 
Dmitry
