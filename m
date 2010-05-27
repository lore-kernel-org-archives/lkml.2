Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127Ab0E0Uvt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 16:51:49 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53643 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756656Ab0E0Uvs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 16:51:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lxLZA7oDIF/V33kL/DB01MVP4QARfwK2qG5Dp0WMas3aChe0xrV8vz1DQOwrS99ADB
         B17islL/rxLmYERUyzqmlccRGM9/w6ljPn0HJ8dOi3OQm4KrEEe5hAwBnre/zt0A+i6C
         IRInmKF+313GiiAZ5rge0M5t6nKA4kSRAJX+Y=
MIME-Version: 1.0
In-Reply-To: <1274993083.7399.60.camel@moss-pluto.epoch.ncsc.mil>
References: <AANLkTilavQK5qmG2B3wuWzfd2kqEK6EP54r3R7A99LI0@mail.gmail.com>
	<1274988457.7399.48.camel@moss-pluto.epoch.ncsc.mil>
	<AANLkTinNrewuTkyzLPalh-pUMZkvgGJfozB9Hl9YgOgi@mail.gmail.com>
	<1274993083.7399.60.camel@moss-pluto.epoch.ncsc.mil>
Date: Fri, 28 May 2010 01:51:47 +0500
Message-ID: <AANLkTimeohrdZyYvzExhT6gRzpZKsWjSy-BIxmN1KIMN@mail.gmail.com>
Subject: Fwd: Default security module feature of 2.6.34
From: Shaz <shazalive@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: securityengineeringresearchgroup 
	<securityengineeringresearchgroup@googlegroups.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---------- Forwarded message ----------
From: Stephen Smalley <sds@tycho.nsa.gov>
Date: Fri, May 28, 2010 at 1:44 AM
Subject: Re: Default security module feature of 2.6.34
To: Shaz <shazalive@gmail.com>
Cc: selinux <selinux@tycho.nsa.gov>


On Fri, 2010-05-28 at 01:28 +0500, Shaz wrote:
> On Fri, May 28, 2010 at 12:27 AM, Stephen Smalley <sds@tycho.nsa.gov> wrote:
> > On Thu, 2010-05-27 at 22:12 +0500, Shaz wrote:
> >> Dear all,
> >>
> >> I saw the default security feature in linux-2.6.34 and wanted to know
> >> what difference does it make to have linux DAC or selinux as the
> >> default security module?
> >
> > It doesn't appear to change anything.  Not sure if that was the intent.
> >
> > The purpose of the option was to allow specification of what security
> > module to enable at boot by default when multiple security modules are
> > built into the kernel and no security= parameter was specified on the
> > kernel command line.  Mostly useful for distributions who want to ship a
> > single kernel that can support any security module and default to a
> > particular one.  So for example you could compile SELinux, Smack, and
> > TOMOYO into your kernel while defaulting to enabling TOMOYO at boot
> > time, letting the user optionally select SELinux or Smack via the
> > security= kernel parameter.
> >
> > I think the DAC setting was just to reflect the fact that if you don't
> > enable anything else, you'll get DAC by default.  But to make that
> > option actually select DAC-only at boot (i.e. not enable any of security
> > modules), it would have to set the DEFAULT_SECURITY string to some
> > non-empty string that doesn't match any security module name rather than
> > to the empty string.
>
> If selinux is chosen at default then what would be the effect? Would
> LSM be invoked before DAC checks? If not then this kernel
> configuration scheme needs to be corrected.

No, it doesn't have anything to do with when the check is applied; it
just affects which security module is enabled by default at boot if
multiple security modules are built into your kernel.
DEFAULT_SECURITY_DAC is likely meant to disable all security modules
(DAC isn't a security module), falling back to only the default DAC
logic.  In which case the Kconfig file does need to be fixed.

--
Stephen Smalley
National Security Agency




-- 
Shaz
