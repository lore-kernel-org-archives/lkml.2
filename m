Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab1COJiu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 05:38:50 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:49492 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848Ab1COJir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 05:38:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [PATCH] Add STMicroelectronics LPS001WP pressure sensor device driver into misc
Date: Tue, 15 Mar 2011 10:38:40 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc8+; KDE/4.5.1; x86_64; ; )
Cc: Jean Delvare <khali@linux-fr.org>,
        mems applications <mems.applications@st.com>, rdunlap@xenotime.net,
        carmine.iascone@st.com, matteo.dameno@st.com, rubini@cvml.unipv.it,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <guenter.roeck@ericsson.com>, Greg KH <greg@kroah.com>
References: <1300128906-1066-1-git-send-email-matteo.dameno@st.com> <20110314224244.3d6d23ba@endymion.delvare> <4D7EA38F.5070002@cam.ac.uk>
In-Reply-To: <4D7EA38F.5070002@cam.ac.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103151038.40559.arnd@arndb.de>
X-Provags-ID: V02:K0:cQHLGk/Y37x3dGuXww7adnKPFjx9ICaPXgxEwOmBi1f
 RLUE3wz94S1AV76b54w0zD20xgG+1VmgsxzJK9z8NI8s9nlj4a
 jMNMU9nB0ylDQ9qWFu6Cr7dGu0QtWa+F/yGo9JfgT4aTWLVCXJ
 MojqxcPzQUtXqTFcuvkvnmf8YzNjwDMIdNPBYPbq8OP12AtG2y
 xruYlr/kuqjYhTmpIcr3A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 March 2011 00:23:59 Jonathan Cameron wrote:
> > 
> > This is indeed the major disadvantage. IIO seems to take a lot of time
> > to move out of staging, although I don't know what the current ETA is.
> > 
> Whilst I'd like to say soon there are a couple more big changes to make
> (such as the ongoing changes to allow threaded interrupts for the triggers
> - basically implementing what Thomas Gleixner suggested and having virtual
> interrupt chips) and some of these will take a fair bit of bedding down. In the
> original write I got quite a few things wrong :( Mind you quite a lot of
> evolution of requirements has taken place as well.
> 
> Usual sob story (50+ drivers of mixed quality to avoid breaking,
> little manpower, steady stream of new drivers keeping people busy reviewing
> etc etc)
> 
> Having said that, for the simple drivers the interfaces are mostly fixed
> and nothing much has changed for quite a few months. (e.g. anything that
> is slow and only uses hwmon style sysfs interfaces).
> 
> Of course, if anyone does have any time (looks around hopefully...)
> Particularly helpful are people pointing out what really needs fixing
> before attempting to move out of staging.   Much better if we get that
> sort of feedback in plenty of time rather than on sending a pull request
> to Linus. I like to spread my arguments out ;)

Do you think it would help to split the iio codebase into a smaller part
for the relatively clean drivers that can be put into shape for
drivers/iio, and the bulk of the code that stays in staging for a bit
longer, until it gets converted to the new one in small chunks?

That may be less frustrating than trying to do it all at once. In particular,
you could do major internal rewrites much faster if you don't have
to immediately worry about breaking dozens of drivers in the process.

	Arnd
