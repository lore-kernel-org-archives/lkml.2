Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429Ab1BZWSn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 17:18:43 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:52535 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab1BZWSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 17:18:41 -0500
Date: Sat, 26 Feb 2011 23:18:38 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Jeff Mahoney <jeffm@suse.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Roman Zippel <zippel@linux-m68k.org>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Add ``cloneconfig'' target
Message-ID: <20110226221838.GA24028@merkur.ravnborg.org>
References: <4D671556.80607@suse.com> <20110225060706.GA12723@merkur.ravnborg.org> <AANLkTimFd+KFKgiOF8iVoM8Pk77Zy+5CsFs5BCYqCw=L@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimFd+KFKgiOF8iVoM8Pk77Zy+5CsFs5BCYqCw=L@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 26, 2011 at 02:47:01PM -0500, Arnaud Lacombe wrote:
> Hi,
> 
> On Fri, Feb 25, 2011 at 1:07 AM, Sam Ravnborg <sam@ravnborg.org> wrote:
> > We already have something remotely similar in kconfig.
> > We use the following list:
> > config DEFCONFIG_LIST
> >        string
> >        depends on !UML
> >        option defconfig_list
> >        default "/lib/modules/$UNAME_RELEASE/.config"
> >        default "/etc/kernel-config"
> >        default "/boot/config-$UNAME_RELEASE"
> >        default "$ARCH_DEFCONFIG"
> >        default "arch/$ARCH/defconfig"
> >
> I may argue that anything within the Linux tree which point
> _by_default_ to something outside the tree itself is broken.
The above allows the average user to just type "make menuconfig"
and then the configuration of the current kernel is presented to
the user. This is convinient in many cases.
We know the /proc/config.gz is an incresingly popular way to gain
access to the configuration of the running kernel. So extending
the already know and working way to obtaing the configuration
of the running kernel to suppport /proc/config.gz is logical.
The fact that the configuration is gzipped does not warrant
a new option to deal with this that almost duplicate the
existing functionality.

	Sam
